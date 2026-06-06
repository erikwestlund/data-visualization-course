# Prepare small course-ready extracts from CDC PLACES census tract data.
#
# Source file expected by default:
# /Users/erik/Downloads/PLACES__Local_Data_for_Better_Health,_Census_Tract_Data,_2025_release_20260604.csv
#
# You can override that path with the PLACES_TRACT_CSV environment variable.

required_packages <- c("dplyr", "readr", "stringr", "tidyr")
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
library(stringr)
library(tidyr)

places_path <- Sys.getenv(
  "PLACES_TRACT_CSV",
  unset = "/Users/erik/Downloads/PLACES__Local_Data_for_Better_Health,_Census_Tract_Data,_2025_release_20260604.csv"
)

if (!file.exists(places_path)) {
  stop("Could not find PLACES tract file: ", places_path, call. = FALSE)
}

output_dir <- "data/real"
codebook_dir <- "data/codebooks"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(codebook_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading PLACES tract data from: ", places_path)
message("Writing cleaned PLACES data to: ", normalizePath(output_dir, mustWork = FALSE))

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

wtd_mean <- function(x, w) {
  ok <- !is.na(x) & !is.na(w) & w > 0
  if (!any(ok)) {
    return(NA_real_)
  }
  sum(x[ok] * w[ok]) / sum(w[ok])
}

selected_measures <- c(
  "ACCESS2",
  "BPHIGH",
  "CSMOKING",
  "DIABETES",
  "LPA",
  "MHLTH",
  "OBESITY"
)

measure_labels <- c(
  ACCESS2 = "Current lack of health insurance among adults aged 18-64 years",
  BPHIGH = "High blood pressure among adults",
  CSMOKING = "Current cigarette smoking among adults",
  DIABETES = "Diagnosed diabetes among adults",
  LPA = "No leisure-time physical activity among adults",
  MHLTH = "Frequent mental distress among adults",
  OBESITY = "Obesity among adults"
)

places_raw <- read_csv(
  places_path,
  col_select = c(
    Year,
    StateAbbr,
    StateDesc,
    CountyName,
    CountyFIPS,
    LocationName,
    DataSource,
    Category,
    Measure,
    MeasureId,
    Data_Value,
    Low_Confidence_Limit,
    High_Confidence_Limit,
    TotalPopulation,
    TotalPop18plus,
    Geolocation,
    LocationID
  ),
  show_col_types = FALSE
)

places_selected <- places_raw |>
  filter(
    Year == 2023,
    MeasureId %in% selected_measures
  ) |>
  mutate(
    data_value = parse_number(as.character(Data_Value)),
    low_confidence_limit = parse_number(as.character(Low_Confidence_Limit)),
    high_confidence_limit = parse_number(as.character(High_Confidence_Limit)),
    total_population = parse_number(as.character(TotalPopulation)),
    total_adult_population = parse_number(as.character(TotalPop18plus)),
    measure_key = case_when(
      MeasureId == "ACCESS2" ~ "lack_health_insurance",
      MeasureId == "BPHIGH" ~ "high_blood_pressure",
      MeasureId == "CSMOKING" ~ "current_smoking",
      MeasureId == "DIABETES" ~ "diabetes",
      MeasureId == "LPA" ~ "physical_inactivity",
      MeasureId == "MHLTH" ~ "frequent_mental_distress",
      MeasureId == "OBESITY" ~ "obesity",
      TRUE ~ str_to_lower(MeasureId)
    ),
    measure = unname(measure_labels[MeasureId]),
    weight = if_else(
      !is.na(total_adult_population) & total_adult_population > 0,
      total_adult_population,
      total_population
    ),
    geolocation_clean = str_remove_all(Geolocation, "^POINT \\(|\\)$"),
    longitude = as.numeric(str_split_fixed(geolocation_clean, " ", 2)[, 1]),
    latitude = as.numeric(str_split_fixed(geolocation_clean, " ", 2)[, 2])
  ) |>
  transmute(
    year = Year,
    state = StateAbbr,
    state_name = StateDesc,
    county_name = CountyName,
    county_fips = CountyFIPS,
    tract_fips = LocationName,
    location_id = LocationID,
    category = Category,
    measure_id = MeasureId,
    measure_key,
    measure,
    estimate = data_value,
    ci_lower = low_confidence_limit,
    ci_upper = high_confidence_limit,
    total_population,
    total_adult_population,
    weight,
    longitude,
    latitude
  )

tract_meta <- places_selected |>
  distinct(
    year,
    state,
    state_name,
    county_name,
    county_fips,
    tract_fips,
    total_population,
    total_adult_population,
    longitude,
    latitude
  )

county_meta <- tract_meta |>
  group_by(year, state, state_name, county_fips, county_name) |>
  summarise(
    tract_count = n_distinct(tract_fips),
    total_population = sum(total_population, na.rm = TRUE),
    total_adult_population = sum(total_adult_population, na.rm = TRUE),
    .groups = "drop"
  )

places_county_core_measures_long <- places_selected |>
  group_by(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    measure_id,
    measure_key,
    measure
  ) |>
  summarise(
    estimate = wtd_mean(estimate, weight),
    ci_lower = wtd_mean(ci_lower, weight),
    ci_upper = wtd_mean(ci_upper, weight),
    .groups = "drop"
  ) |>
  left_join(
    county_meta,
    by = c("year", "state", "state_name", "county_fips", "county_name")
  ) |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    tract_count,
    total_population,
    total_adult_population,
    measure_id,
    measure_key,
    measure,
    estimate,
    ci_lower,
    ci_upper
  ) |>
  arrange(state, county_name, measure_key)

places_county_core_measures_wide <- places_county_core_measures_long |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    measure_key,
    estimate
  ) |>
  pivot_wider(
    names_from = measure_key,
    values_from = estimate
  ) |>
  left_join(
    county_meta,
    by = c("year", "state", "state_name", "county_fips", "county_name")
  ) |>
  select(
    year,
    state,
    state_name,
    county_fips,
    county_name,
    tract_count,
    total_population,
    total_adult_population,
    current_smoking,
    diabetes,
    frequent_mental_distress,
    high_blood_pressure,
    lack_health_insurance,
    obesity,
    physical_inactivity
  ) |>
  arrange(state, county_name)

places_tract_dc_md_va_core_measures_long <- places_selected |>
  filter(state %in% c("DC", "MD", "VA")) |>
  select(
    year,
    state,
    state_name,
    county_name,
    county_fips,
    tract_fips,
    location_id,
    measure_id,
    measure_key,
    measure,
    estimate,
    ci_lower,
    ci_upper,
    total_population,
    total_adult_population,
    longitude,
    latitude
  ) |>
  arrange(state, county_name, tract_fips, measure_key)

write_course_csv(places_county_core_measures_long, "places_county_core_measures_long.csv")
write_course_csv(places_county_core_measures_wide, "places_county_core_measures_wide.csv")
write_course_csv(places_tract_dc_md_va_core_measures_long, "places_tract_dc_md_va_core_measures_long.csv")

write_codebook(
  "places_county_core_measures_long.md",
  c(
    "# PLACES County Core Measures Long",
    "",
    "Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.",
    "",
    "Unit of observation: one county-measure row for selected 2023 PLACES tract measures aggregated to county level.",
    "",
    "Important caution: this file is derived by population-weighting census tract estimates within each county. It is designed for teaching and exploratory visualization. It should not be described as the official county PLACES release.",
    "",
    "Kentucky and Pennsylvania are absent from the source tract file for the selected 2023 measures used here.",
    "",
    "## Variables",
    "",
    "- `year`: source data year.",
    "- `state`: state abbreviation.",
    "- `state_name`: state name.",
    "- `county_fips`: county FIPS code.",
    "- `county_name`: county name.",
    "- `tract_count`: number of census tracts contributing to the county summary.",
    "- `total_population`: sum of tract total population values within the county.",
    "- `total_adult_population`: sum of tract adult population values within the county.",
    "- `measure_id`: CDC PLACES measure identifier.",
    "- `measure_key`: short analysis-friendly measure name.",
    "- `measure`: readable measure label.",
    "- `estimate`: population-weighted county estimate, in percent.",
    "- `ci_lower`: population-weighted lower confidence limit, in percent.",
    "- `ci_upper`: population-weighted upper confidence limit, in percent.",
    "",
    "## Included Measures",
    "",
    "- `current_smoking`: current cigarette smoking among adults.",
    "- `diabetes`: diagnosed diabetes among adults.",
    "- `frequent_mental_distress`: frequent mental distress among adults.",
    "- `high_blood_pressure`: high blood pressure among adults.",
    "- `lack_health_insurance`: current lack of health insurance among adults aged 18-64 years.",
    "- `obesity`: obesity among adults.",
    "- `physical_inactivity`: no leisure-time physical activity among adults."
  )
)

write_codebook(
  "places_county_core_measures_wide.md",
  c(
    "# PLACES County Core Measures Wide",
    "",
    "Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.",
    "",
    "Unit of observation: one county row with selected 2023 PLACES measures in separate columns.",
    "",
    "Important caution: this file is derived by population-weighting census tract estimates within each county. It is designed for teaching and exploratory visualization. It should not be described as the official county PLACES release.",
    "",
    "Kentucky and Pennsylvania are absent from the source tract file for the selected 2023 measures used here.",
    "",
    "## Variables",
    "",
    "- `year`: source data year.",
    "- `state`: state abbreviation.",
    "- `state_name`: state name.",
    "- `county_fips`: county FIPS code.",
    "- `county_name`: county name.",
    "- `tract_count`: number of census tracts contributing to the county summary.",
    "- `total_population`: sum of tract total population values within the county.",
    "- `total_adult_population`: sum of tract adult population values within the county.",
    "- `current_smoking`: percent of adults who currently smoke cigarettes.",
    "- `diabetes`: percent of adults with diagnosed diabetes.",
    "- `frequent_mental_distress`: percent of adults reporting frequent mental distress.",
    "- `high_blood_pressure`: percent of adults with high blood pressure.",
    "- `lack_health_insurance`: percent of adults aged 18-64 years who currently lack health insurance.",
    "- `obesity`: percent of adults with obesity.",
    "- `physical_inactivity`: percent of adults reporting no leisure-time physical activity."
  )
)

write_codebook(
  "places_tract_dc_md_va_core_measures_long.md",
  c(
    "# PLACES Tract DC/MD/VA Core Measures Long",
    "",
    "Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.",
    "",
    "Unit of observation: one census tract-measure row for selected 2023 PLACES measures in DC, Maryland, and Virginia.",
    "",
    "This file is a small regional subset of the original tract-level source. It is intended for teaching tract-level spatial comparison, rank, and local variation without bundling the 828 MB raw file.",
    "",
    "## Variables",
    "",
    "- `year`: source data year.",
    "- `state`: state abbreviation.",
    "- `state_name`: state name.",
    "- `county_name`: county name.",
    "- `county_fips`: county FIPS code.",
    "- `tract_fips`: census tract FIPS code.",
    "- `location_id`: PLACES location identifier.",
    "- `measure_id`: CDC PLACES measure identifier.",
    "- `measure_key`: short analysis-friendly measure name.",
    "- `measure`: readable measure label.",
    "- `estimate`: tract-level estimate, in percent.",
    "- `ci_lower`: lower confidence limit, in percent.",
    "- `ci_upper`: upper confidence limit, in percent.",
    "- `total_population`: tract total population.",
    "- `total_adult_population`: tract adult population.",
    "- `longitude`: tract longitude from source geolocation.",
    "- `latitude`: tract latitude from source geolocation."
  )
)

message("Done preparing PLACES data files.")
