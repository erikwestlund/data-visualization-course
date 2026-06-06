# Prepare county air quality statistics from EPA's county factbook workbook.
#
# Source file expected by default:
# /Users/erik/Downloads/ctyfactbook2024_0.xlsx
#
# You can override that path with the EPA_COUNTY_AIR_XLSX environment variable.

required_packages <- c("dplyr", "readr", "readxl", "stringr", "tidyr")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing_packages) > 0) {
  stop(
    "Install required packages before running this script: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

library(dplyr)
library(readr)
library(readxl)
library(stringr)
library(tidyr)

air_quality_path <- Sys.getenv(
  "EPA_COUNTY_AIR_XLSX",
  unset = "/Users/erik/Downloads/ctyfactbook2024_0.xlsx"
)

if (!file.exists(air_quality_path)) {
  stop("Could not find EPA county air quality workbook: ", air_quality_path, call. = FALSE)
}

output_dir <- "data/real"
codebook_dir <- "data/codebooks"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(codebook_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading EPA county air quality workbook from: ", air_quality_path)
message("Writing cleaned EPA county air quality data to: ", normalizePath(output_dir, mustWork = FALSE))

write_course_csv <- function(data, filename) {
  path <- file.path(output_dir, filename)
  write_csv(data, path, na = "")
  message("Wrote ", path, " (", nrow(data), " rows, ", ncol(data), " columns)")
}

write_codebook <- function(filename, lines) {
  path <- file.path(codebook_dir, filename)
  writeLines(lines, path)
  message("Wrote ", path)
}

state_lookup <- tibble(
  state_name = c(state.name, "District of Columbia", "Puerto Rico"),
  state = c(state.abb, "DC", "PR")
)

metric_lookup <- tibble(
  source_column = c(
    "CO           8-hour (ppm)",
    "Lead             3-month (µg/m3)",
    "NO2         AM      (ppb)",
    "NO2           1-hour (ppb)",
    "Ozone         8-hour (ppb)",
    "PM10        24-hour (µg/m3)",
    "PM2.5     Wtd AM (µg/m3)",
    "PM2.5      24-hour (µg/m3)",
    "SO2          1-hour (ppb)",
    "SO2    Wtd AM (ppb)"
  ),
  metric_key = c(
    "co_8hr_ppm",
    "lead_3mo_ug_m3",
    "no2_annual_mean_ppb",
    "no2_1hr_ppb",
    "ozone_8hr_ppb",
    "pm10_24hr_ug_m3",
    "pm25_annual_mean_ug_m3",
    "pm25_24hr_ug_m3",
    "so2_1hr_ppb",
    "so2_annual_mean_ppb"
  ),
  pollutant = c("CO", "Lead", "NO2", "NO2", "Ozone", "PM10", "PM2.5", "PM2.5", "SO2", "SO2"),
  statistic = c("8-hour", "3-month", "annual mean", "1-hour", "8-hour", "24-hour", "weighted annual mean", "24-hour", "1-hour", "weighted annual mean"),
  unit = c("ppm", "ug/m3", "ppb", "ppb", "ppb", "ug/m3", "ug/m3", "ug/m3", "ppb", "ppb"),
  naaqs_standard = c(9, 0.15, 53, 100, 70, 150, 9, 35, 75, 10)
)

raw_air_quality <- read_excel(
  air_quality_path,
  sheet = "AQ Stats by County 2025",
  skip = 2,
  col_types = "text"
)

epa_air_quality_county_2025_long <- raw_air_quality |>
  filter(
    !is.na(`County FIPS Code`),
    str_detect(`County FIPS Code`, "^[0-9]{5}$")
  ) |>
  transmute(
    year = 2025L,
    state_name = State,
    county_name = County,
    county_fips = `County FIPS Code`,
    population_2020 = parse_number(`Population (2020 Census)`),
    across(all_of(metric_lookup$source_column))
  ) |>
  left_join(state_lookup, by = "state_name") |>
  relocate(state, .after = state_name) |>
  pivot_longer(
    cols = all_of(metric_lookup$source_column),
    names_to = "source_column",
    values_to = "source_value"
  ) |>
  left_join(metric_lookup, by = "source_column") |>
  mutate(
    status = case_when(
      source_value == "ND" ~ "no_data",
      source_value == "IN" ~ "insufficient_data",
      is.na(source_value) ~ "missing",
      TRUE ~ "reported"
    ),
    value = parse_number(if_else(status == "reported", source_value, NA_character_)),
    value_as_fraction_of_standard = value / naaqs_standard,
    exceeds_standard = case_when(
      status != "reported" ~ NA,
      TRUE ~ value > naaqs_standard
    )
  ) |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    population_2020,
    pollutant,
    statistic,
    unit,
    metric_key,
    value,
    status,
    naaqs_standard,
    value_as_fraction_of_standard,
    exceeds_standard
  ) |>
  arrange(state, county_name, pollutant, statistic)

epa_air_quality_county_2025_wide_values <- epa_air_quality_county_2025_long |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    population_2020,
    metric_key,
    value
  ) |>
  pivot_wider(
    names_from = metric_key,
    values_from = value
  )

epa_air_quality_county_2025_wide_status <- epa_air_quality_county_2025_long |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    metric_key,
    status
  ) |>
  mutate(metric_key = paste0(metric_key, "_status")) |>
  pivot_wider(
    names_from = metric_key,
    values_from = status
  )

epa_air_quality_county_2025_wide <- epa_air_quality_county_2025_wide_values |>
  left_join(
    epa_air_quality_county_2025_wide_status,
    by = c("year", "state", "state_name", "county_fips", "county_name")
  ) |>
  arrange(state, county_name)

write_course_csv(epa_air_quality_county_2025_long, "epa_air_quality_county_2025_long.csv")
write_course_csv(epa_air_quality_county_2025_wide, "epa_air_quality_county_2025_wide.csv")

write_codebook(
  "epa_air_quality_county_2025_long.md",
  c(
    "# EPA Air Quality County 2025 Long",
    "",
    "Source: EPA Air Quality Statistics by County, 2025 workbook. The source notes that values are based on EPA AQS monitoring data as of June 5, 2025.",
    "",
    "Unit of observation: one county-pollutant-statistic row for counties with monitoring data in the EPA workbook.",
    "",
    "Important caution: counties without monitoring data for a pollutant/statistic are marked as `no_data`; counties with insufficient data are marked as `insufficient_data`. This dataset describes monitored county summaries, not all possible air quality exposure variation within counties.",
    "",
    "## Variables",
    "",
    "- `year`: factbook year, set to 2025.",
    "- `state`: state abbreviation, including `DC` and `PR` where present.",
    "- `state_name`: state or territory name.",
    "- `county_fips`: county FIPS code.",
    "- `county_name`: county name from the EPA workbook.",
    "- `population_2020`: county population from the 2020 Census column in the workbook.",
    "- `pollutant`: pollutant name, such as `Ozone`, `PM2.5`, or `NO2`.",
    "- `statistic`: statistic used for the pollutant, such as `8-hour`, `24-hour`, or `weighted annual mean`.",
    "- `unit`: measurement unit.",
    "- `metric_key`: analysis-friendly metric name.",
    "- `value`: numeric reported value; missing when status is not `reported`.",
    "- `status`: `reported`, `no_data`, `insufficient_data`, or `missing`.",
    "- `naaqs_standard`: applicable National Ambient Air Quality Standards value listed in the source workbook notes.",
    "- `value_as_fraction_of_standard`: value divided by `naaqs_standard`.",
    "- `exceeds_standard`: whether the reported value exceeds the listed standard."
  )
)

write_codebook(
  "epa_air_quality_county_2025_wide.md",
  c(
    "# EPA Air Quality County 2025 Wide",
    "",
    "Source: EPA Air Quality Statistics by County, 2025 workbook. The source notes that values are based on EPA AQS monitoring data as of June 5, 2025.",
    "",
    "Unit of observation: one county row for counties with monitoring data in the EPA workbook.",
    "",
    "Important caution: numeric pollutant columns are missing when the source value was `ND` (no data) or `IN` (insufficient data). Use the matching `_status` columns to distinguish these cases.",
    "",
    "## Identifier Variables",
    "",
    "- `year`: factbook year, set to 2025.",
    "- `state`: state abbreviation, including `DC` and `PR` where present.",
    "- `state_name`: state or territory name.",
    "- `county_fips`: county FIPS code.",
    "- `county_name`: county name from the EPA workbook.",
    "- `population_2020`: county population from the 2020 Census column in the workbook.",
    "",
    "## Numeric Metric Variables",
    "",
    "- `co_8hr_ppm`: CO second maximum non-overlapping 8-hour concentration, ppm.",
    "- `lead_3mo_ug_m3`: lead maximum rolling 3-month average concentration, ug/m3.",
    "- `no2_annual_mean_ppb`: NO2 annual arithmetic mean concentration, ppb.",
    "- `no2_1hr_ppb`: NO2 98th percentile daily maximum 1-hour concentration, ppb.",
    "- `ozone_8hr_ppb`: ozone fourth highest daily maximum 8-hour concentration, ppb.",
    "- `pm10_24hr_ug_m3`: PM10 second maximum 24-hour concentration, ug/m3.",
    "- `pm25_annual_mean_ug_m3`: PM2.5 weighted annual mean concentration, ug/m3.",
    "- `pm25_24hr_ug_m3`: PM2.5 98th percentile 24-hour concentration, ug/m3.",
    "- `so2_1hr_ppb`: SO2 99th percentile daily maximum 1-hour concentration, ppb.",
    "- `so2_annual_mean_ppb`: SO2 weighted annual mean concentration, ppb.",
    "",
    "## Status Variables",
    "",
    "Each numeric metric has a matching `_status` column with values `reported`, `no_data`, `insufficient_data`, or `missing`."
  )
)

message("Done preparing EPA county air quality data files.")
