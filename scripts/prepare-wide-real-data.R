# Prepare wide, assignment-friendly versions of the real public datasets.
#
# The source files in data/real keep the cleaned long or selected shapes. These
# derived files focus on the variables used most often in examples and problem
# sets, while preserving the original files for more flexible analysis.

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

input_dir <- "data/real"
output_dir <- "data/real/wide"
codebook_dir <- "data/codebooks"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(codebook_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading cleaned real data from: ", normalizePath(input_dir, mustWork = FALSE))
message("Writing wide real data to: ", normalizePath(output_dir, mustWork = FALSE))

write_course_csv <- function(data, filename) {
  path <- file.path(output_dir, filename)
  write_csv(data, path, na = "")
  message("Wrote ", path, " (", nrow(data), " rows, ", ncol(data), " columns)")
}

write_codebook <- function(filename, title, unit, variables, notes) {
  path <- file.path(codebook_dir, filename)
  lines <- c(
    paste0("# ", title),
    "",
    paste0("Unit of observation: ", unit),
    "",
    "## Variables",
    "",
    paste0("- `", names(variables), "`: ", unname(variables)),
    "",
    "## Notes",
    "",
    paste0("- ", notes)
  )
  writeLines(lines, path)
  message("Wrote ", path)
}

clean_name <- function(x) {
  x |>
    str_to_lower() |>
    str_replace_all(">=", "ge_") |>
    str_replace_all("[^a-z0-9]+", "_") |>
    str_replace_all("(^_|_$)", "")
}

# PRAMS wide files -------------------------------------------------------------

prams <- read_csv(file.path(input_dir, "prams_2011_selected.csv"), show_col_types = FALSE)

prams_state_overall_wide <- prams |>
  filter(subgroup_cat == "None", subgroup == "None") |>
  transmute(
    state = location_abbr,
    state_name = location,
    depression_percent = depression_within_3_months_birth,
    anxiety_percent = anxiety_within_3_months_birth,
    binge_drinking_percent = binge_drinking_within_3_months_birth,
    alcohol_use_percent = alcohol_use_within_3_months_birth
  ) |>
  arrange(state)

write_course_csv(prams_state_overall_wide, "prams_state_overall_wide.csv")

write_codebook(
  "prams_state_overall_wide.md",
  "PRAMS State Overall Wide",
  "one state-level overall PRAMS estimate row",
  c(
    state = "state abbreviation",
    state_name = "state name",
    depression_percent = "percent reporting depression within 3 months before birth",
    anxiety_percent = "percent reporting anxiety within 3 months before birth",
    binge_drinking_percent = "percent reporting binge drinking within 3 months before birth",
    alcohol_use_percent = "percent reporting alcohol use within 3 months before birth"
  ),
  c(
    "Derived from CDC PRAMS/PRAMStat public 2011 data.",
    "Rows are pre-aggregated percentages, not person-level observations.",
    "Some mental health estimates are missing in the public source."
  )
)

prams_previous_live_births_wide <- prams |>
  filter(subgroup_cat == "Number of Previous Live Births") |>
  mutate(
    subgroup_key = case_when(
      subgroup == "0" ~ "no_previous_live_births",
      subgroup == "1 or more" ~ "one_or_more_previous_live_births",
      TRUE ~ clean_name(subgroup)
    )
  ) |>
  select(
    state = location_abbr,
    state_name = location,
    subgroup_key,
    depression_within_3_months_birth,
    anxiety_within_3_months_birth,
    binge_drinking_within_3_months_birth,
    alcohol_use_within_3_months_birth
  ) |>
  pivot_wider(
    names_from = subgroup_key,
    values_from = c(
      depression_within_3_months_birth,
      anxiety_within_3_months_birth,
      binge_drinking_within_3_months_birth,
      alcohol_use_within_3_months_birth
    )
  ) |>
  mutate(
    depression_difference_one_or_more_minus_none =
      depression_within_3_months_birth_one_or_more_previous_live_births -
      depression_within_3_months_birth_no_previous_live_births,
    binge_difference_one_or_more_minus_none =
      binge_drinking_within_3_months_birth_one_or_more_previous_live_births -
      binge_drinking_within_3_months_birth_no_previous_live_births
  ) |>
  arrange(state)

write_course_csv(prams_previous_live_births_wide, "prams_previous_live_births_wide.csv")

write_codebook(
  "prams_previous_live_births_wide.md",
  "PRAMS Previous Live Births Wide",
  "one state row with separate columns for previous-live-birth subgroups",
  c(
    state = "state abbreviation",
    state_name = "state name",
    depression_within_3_months_birth_no_previous_live_births = "percent reporting depression among respondents with no previous live births",
    depression_within_3_months_birth_one_or_more_previous_live_births = "percent reporting depression among respondents with one or more previous live births",
    depression_difference_one_or_more_minus_none = "difference in depression percentage points between one-or-more and no previous live births",
    binge_difference_one_or_more_minus_none = "difference in binge drinking percentage points between one-or-more and no previous live births"
  ),
  c(
    "Derived from CDC PRAMS/PRAMStat public 2011 data.",
    "Rows are pre-aggregated subgroup percentages by state.",
    "Difference variables are simple percentage-point differences and are not causal estimates."
  )
)

# CDC flu vaccination wide files ----------------------------------------------

flu <- read_csv(file.path(input_dir, "flu_vaccination_age_time_clean.csv"), show_col_types = FALSE) |>
  mutate(age_group_key = clean_name(age_group))

flu_vaccination_age_month_wide <- flu |>
  select(
    season,
    season_start_year,
    month,
    geography,
    age_group_key,
    estimate,
    ci_lower,
    ci_upper,
    sample_size
  ) |>
  pivot_wider(
    names_from = age_group_key,
    values_from = c(estimate, ci_lower, ci_upper, sample_size),
    names_glue = "{.value}_{age_group_key}"
  ) |>
  arrange(season_start_year, month, geography)

write_course_csv(flu_vaccination_age_month_wide, "flu_vaccination_age_month_wide.csv")

write_codebook(
  "flu_vaccination_age_month_wide.md",
  "Flu Vaccination Age Month Wide",
  "one geography-season-month row with separate age-group estimate columns",
  c(
    season = "CDC flu season label",
    season_start_year = "first year of the flu season",
    month = "month number",
    geography = "United States or HHS region",
    estimate_6_months_4_years = "vaccination coverage estimate for ages 6 months to 4 years",
    estimate_5_12_years = "vaccination coverage estimate for ages 5 to 12 years",
    estimate_13_17_years = "vaccination coverage estimate for ages 13 to 17 years",
    estimate_18_49_years = "vaccination coverage estimate for ages 18 to 49 years",
    estimate_50_64_years = "vaccination coverage estimate for ages 50 to 64 years",
    estimate_ge_65_years = "vaccination coverage estimate for ages 65 years and older"
  ),
  c(
    "Derived from CDC public influenza vaccination coverage data.",
    "Confidence interval and sample-size columns use the same age-group suffixes as estimate columns.",
    "Rows include United States and HHS region geographies."
  )
)

flu_vaccination_us_age_season_wide <- flu |>
  filter(geography == "United States") |>
  group_by(season, season_start_year, age_group_key) |>
  summarise(
    mean_estimate = mean(estimate, na.rm = TRUE),
    mean_ci_lower = mean(ci_lower, na.rm = TRUE),
    mean_ci_upper = mean(ci_upper, na.rm = TRUE),
    total_sample_size = sum(sample_size, na.rm = TRUE),
    n_months = n(),
    .groups = "drop"
  ) |>
  pivot_wider(
    names_from = age_group_key,
    values_from = c(mean_estimate, mean_ci_lower, mean_ci_upper, total_sample_size),
    names_glue = "{.value}_{age_group_key}"
  ) |>
  arrange(season_start_year)

write_course_csv(flu_vaccination_us_age_season_wide, "flu_vaccination_us_age_season_wide.csv")

write_codebook(
  "flu_vaccination_us_age_season_wide.md",
  "Flu Vaccination US Age Season Wide",
  "one United States flu-season row with separate age-group columns",
  c(
    season = "CDC flu season label",
    season_start_year = "first year of the flu season",
    mean_estimate_6_months_4_years = "mean monthly vaccination coverage estimate for ages 6 months to 4 years",
    mean_estimate_5_12_years = "mean monthly vaccination coverage estimate for ages 5 to 12 years",
    mean_estimate_13_17_years = "mean monthly vaccination coverage estimate for ages 13 to 17 years",
    mean_estimate_18_49_years = "mean monthly vaccination coverage estimate for ages 18 to 49 years",
    mean_estimate_50_64_years = "mean monthly vaccination coverage estimate for ages 50 to 64 years",
    mean_estimate_ge_65_years = "mean monthly vaccination coverage estimate for ages 65 years and older"
  ),
  c(
    "Derived from CDC public influenza vaccination coverage data.",
    "Mean estimate columns average the available monthly estimates within each season.",
    "This file is designed for simple time-trend plots by age group."
  )
)

# Census race/ethnicity wide file ---------------------------------------------

census_long <- read_csv(file.path(input_dir, "census_state_race_ethnicity_long.csv"), show_col_types = FALSE)

census_state_race_ethnicity_wide <- census_long |>
  mutate(race_key = clean_name(race_ethnicity)) |>
  select(
    state,
    state_name,
    rank,
    total_population,
    race_key,
    race_ethnicity_population,
    share
  ) |>
  pivot_wider(
    names_from = race_key,
    values_from = c(race_ethnicity_population, share),
    names_glue = "{.value}_{race_key}"
  ) |>
  mutate(state_population_weight = total_population / sum(total_population, na.rm = TRUE)) |>
  arrange(rank)

write_course_csv(census_state_race_ethnicity_wide, "census_state_race_ethnicity_wide.csv")

write_codebook(
  "census_state_race_ethnicity_wide.md",
  "Census State Race Ethnicity Wide",
  "one state row with separate race/ethnicity population and share columns",
  c(
    state = "state abbreviation",
    state_name = "state name",
    rank = "state population rank from the Census population file",
    total_population = "total state population",
    state_population_weight = "state population divided by total population across included states",
    share_white = "share of race/ethnicity population total categorized as White",
    share_black = "share of race/ethnicity population total categorized as Black",
    share_hispanic_or_latino = "share of race/ethnicity population total categorized as Hispanic or Latino",
    share_asian = "share of race/ethnicity population total categorized as Asian"
  ),
  c(
    "Derived from public 2020 Census race/ethnicity and state population files.",
    "Population and share columns are wide versions of census_state_race_ethnicity_long.csv.",
    "The race/ethnicity categories follow the source file and should not be treated as exhaustive person-level classifications."
  )
)

message("Done preparing wide real data files.")
