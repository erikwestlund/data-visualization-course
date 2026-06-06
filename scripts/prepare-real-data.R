# Prepare real public datasets for the data visualization course.
#
# This script derives small, assignment-ready CSV files from public datasets used
# in the previous version of the course. It does not use the Framework package so
# the resulting workflow is easy to inspect and rerun with standard R packages.

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

old_course_data <- Sys.getenv(
  "OLD_DATA_VIZ_COURSE_DATA",
  unset = "/Users/erik/Code/Courses/data-viz-summer-25/data"
)

output_dir <- "data/real"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading old course data from: ", old_course_data)
message("Writing cleaned data to: ", normalizePath(output_dir, mustWork = FALSE))

write_course_csv <- function(data, filename) {
  path <- file.path(output_dir, filename)
  write_csv(data, path, na = "")
  message("Wrote ", path, " (", nrow(data), " rows, ", ncol(data), " columns)")
}

# PRAMS selected public data ---------------------------------------------------

prams_path <- file.path(old_course_data, "processed", "cdc_prams_df_final.rds")

if (!file.exists(prams_path)) {
  stop("Could not find PRAMS file: ", prams_path, call. = FALSE)
}

prams_selected <- readRDS(prams_path) |>
  mutate(
    across(where(is.factor), as.character)
  ) |>
  select(
    location_abbr,
    location,
    subgroup_cat,
    subgroup,
    depression_within_3_months_birth,
    anxiety_within_3_months_birth,
    binge_drinking_within_3_months_birth,
    alcohol_use_within_3_months_birth
  ) |>
  arrange(location_abbr, subgroup_cat, subgroup)

write_course_csv(prams_selected, "prams_2011_selected.csv")

# CDC flu vaccination coverage ------------------------------------------------

flu_path <- file.path(
  old_course_data,
  "raw",
  "cdc_Influenza_Vaccination_Coverage_for_All_Ages__6__Months__20250610.csv"
)

if (!file.exists(flu_path)) {
  stop("Could not find flu vaccination file: ", flu_path, call. = FALSE)
}

mutually_exclusive_age_groups <- c(
  "6 Months - 4 Years",
  "5-12 Years",
  "13-17 Years",
  "18-49 Years",
  "50-64 Years",
  ">=65 Years"
)

flu_raw <- read_csv(flu_path, show_col_types = FALSE)

flu_vaccination_age_time_clean <- flu_raw |>
  transmute(
    vaccine = Vaccine,
    geography_type = `Geography Type`,
    geography = Geography,
    fips = FIPS,
    season = `Season/Survey Year`,
    season_start_year = as.integer(str_extract(`Season/Survey Year`, "^[0-9]{4}")),
    month = Month,
    dimension_type = `Dimension Type`,
    age_group = Dimension,
    estimate = suppressWarnings(parse_number(`Estimate (%)`)),
    ci_text = str_remove_all(`95% CI (%)`, "[‡†]"),
    sample_size = `Sample Size`
  ) |>
  mutate(
    ci_lower = as.numeric(str_match(ci_text, "^\\s*([0-9.]+)\\s+to\\s+([0-9.]+)")[, 2]),
    ci_upper = as.numeric(str_match(ci_text, "^\\s*([0-9.]+)\\s+to\\s+([0-9.]+)")[, 3]),
    age_group = factor(age_group, levels = mutually_exclusive_age_groups)
  ) |>
  filter(
    vaccine == "Seasonal Influenza",
    geography_type == "HHS Regions/National",
    dimension_type == "Age",
    !is.na(age_group),
    !is.na(estimate)
  ) |>
  select(
    season,
    season_start_year,
    month,
    geography_type,
    geography,
    fips,
    age_group,
    estimate,
    ci_lower,
    ci_upper,
    sample_size
  ) |>
  arrange(season_start_year, month, geography, age_group)

write_course_csv(flu_vaccination_age_time_clean, "flu_vaccination_age_time_clean.csv")

# Census race/ethnicity by state ---------------------------------------------

race_path <- file.path(old_course_data, "raw", "race_by_state_census2020.csv")
state_rank_path <- file.path(old_course_data, "raw", "states_census2020_ranks.csv")

if (!file.exists(race_path)) {
  stop("Could not find Census race/ethnicity file: ", race_path, call. = FALSE)
}

if (!file.exists(state_rank_path)) {
  stop("Could not find Census state rank file: ", state_rank_path, call. = FALSE)
}

state_population_ranks <- read_csv(state_rank_path, show_col_types = FALSE) |>
  arrange(rank)

write_course_csv(state_population_ranks, "state_population_ranks.csv")

census_state_race_ethnicity_long <- read_csv(race_path, show_col_types = FALSE) |>
  pivot_longer(
    cols = -Label,
    names_to = "state_name",
    values_to = "population"
  ) |>
  transmute(
    state_name,
    race_ethnicity = Label,
    race_ethnicity_population = parse_number(as.character(population))
  ) |>
  left_join(
    state_population_ranks |>
      rename(total_population = population),
    by = "state_name"
  ) |>
  filter(!is.na(state)) |>
  group_by(state, state_name) |>
  mutate(
    total_race_ethnicity_population = sum(race_ethnicity_population, na.rm = TRUE),
    share = race_ethnicity_population / total_race_ethnicity_population
  ) |>
  ungroup() |>
  select(
    state,
    state_name,
    rank,
    total_population,
    race_ethnicity,
    race_ethnicity_population,
    total_race_ethnicity_population,
    share
  ) |>
  arrange(rank, race_ethnicity)

write_course_csv(census_state_race_ethnicity_long, "census_state_race_ethnicity_long.csv")

state_race_population_summary <- census_state_race_ethnicity_long |>
  select(state, state_name, rank, total_population, race_ethnicity, share) |>
  mutate(
    race_ethnicity = str_to_lower(race_ethnicity),
    race_ethnicity = str_replace_all(race_ethnicity, "[^a-z0-9]+", "_"),
    race_ethnicity = str_replace_all(race_ethnicity, "(^_|_$)", "")
  ) |>
  pivot_wider(
    names_from = race_ethnicity,
    values_from = share,
    names_prefix = "share_"
  ) |>
  arrange(rank)

write_course_csv(state_race_population_summary, "state_race_population_summary.csv")

message("Done preparing real data files.")
