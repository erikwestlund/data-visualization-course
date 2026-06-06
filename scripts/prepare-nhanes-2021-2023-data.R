# Prepare selected NHANES August 2021-August 2023 teaching datasets.
#
# Source files are CDC/NCHS NHANES XPT files. Defaults point to the local files
# downloaded in /Users/erik/Downloads; override with environment variables if
# needed.

required_packages <- c("dplyr", "haven", "readr", "stringr", "tidyr")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing_packages) > 0) {
  stop(
    "Install required packages before running this script: ",
    paste(missing_packages, collapse = ", "),
    call. = FALSE
  )
}

library(dplyr)
library(haven)
library(readr)
library(stringr)
library(tidyr)

demo_path <- Sys.getenv("NHANES_DEMO_XPT", unset = "/Users/erik/Downloads/DEMO_L.xpt")
diet_day1_path <- Sys.getenv("NHANES_DR1IFF_XPT", unset = "/Users/erik/Downloads/DR1IFF_L.xpt")
diet_day2_path <- Sys.getenv("NHANES_DR2IFF_XPT", unset = "/Users/erik/Downloads/DR2IFF_L.xpt")
bp_path <- Sys.getenv("NHANES_BPXO_XPT", unset = "/Users/erik/Downloads/BPXO_L.xpt")
hepa_path <- Sys.getenv("NHANES_HEPA_XPT", unset = "/Users/erik/Downloads/HEPA_L.xpt")

input_paths <- c(
  DEMO_L = demo_path,
  DR1IFF_L = diet_day1_path,
  DR2IFF_L = diet_day2_path,
  BPXO_L = bp_path,
  HEPA_L = hepa_path
)

missing_files <- input_paths[!file.exists(input_paths)]

if (length(missing_files) > 0) {
  stop(
    "Could not find required NHANES XPT files: ",
    paste(names(missing_files), missing_files, sep = "=", collapse = "; "),
    call. = FALSE
  )
}

output_dir <- "data/real"
codebook_dir <- "data/codebooks"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(codebook_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading NHANES XPT files from:")
for (path_name in names(input_paths)) {
  message("- ", path_name, ": ", input_paths[[path_name]])
}
message("Writing cleaned NHANES data to: ", normalizePath(output_dir, mustWork = FALSE))

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

read_nhanes_xpt <- function(path) {
  read_xpt(path) |>
    zap_labels()
}

na_if_codes <- function(x, codes) {
  if_else(x %in% codes, NA_real_, as.numeric(x))
}

row_mean_or_na <- function(data, vars) {
  values <- rowMeans(select(data, all_of(vars)), na.rm = TRUE)
  values[is.nan(values)] <- NA_real_
  values
}

weekday_label <- function(x) {
  case_when(
    x == 1 ~ "Sunday",
    x == 2 ~ "Monday",
    x == 3 ~ "Tuesday",
    x == 4 ~ "Wednesday",
    x == 5 ~ "Thursday",
    x == 6 ~ "Friday",
    x == 7 ~ "Saturday",
    TRUE ~ NA_character_
  )
}

language_label <- function(x) {
  case_when(
    x == 1 ~ "English",
    x == 2 ~ "Spanish",
    x == 3 ~ "English and Spanish",
    x == 4 ~ "Other",
    TRUE ~ NA_character_
  )
}

recall_status_label <- function(x) {
  case_when(
    x == 1 ~ "reliable",
    x == 2 ~ "not_reliable",
    x == 4 ~ "reported_breast_milk",
    x == 5 ~ "not_done",
    TRUE ~ NA_character_
  )
}

yes_no_label <- function(x) {
  case_when(
    x == 1 ~ "yes",
    x == 2 ~ "no",
    TRUE ~ NA_character_
  )
}

eating_occasion_label <- function(x) {
  case_when(
    x == 1 ~ "Breakfast",
    x == 2 ~ "Lunch",
    x == 3 ~ "Dinner",
    x == 4 ~ "Supper",
    x == 5 ~ "Brunch",
    x == 6 ~ "Snack",
    x == 7 ~ "Beverage/Drink",
    x == 8 ~ "Feeding-infant only",
    x == 9 ~ "Extended consumption",
    x == 10 ~ "Desayuno",
    x == 11 ~ "Almuerzo",
    x == 12 ~ "Comida",
    x == 13 ~ "Merienda",
    x == 14 ~ "Cena",
    x == 15 ~ "Entre comida",
    x == 16 ~ "Botana",
    x == 17 ~ "Bocadillo",
    x == 18 ~ "Tentempie",
    x == 19 ~ "Bebida",
    x == 91 ~ "Other",
    TRUE ~ NA_character_
  )
}

combination_type_label <- function(x) {
  case_when(
    x == 0 ~ "Not in combination",
    x == 1 ~ "Beverage with additions",
    x == 2 ~ "Cereal with additions",
    x == 3 ~ "Bread/baked product with additions",
    x == 4 ~ "Salad",
    x == 5 ~ "Sandwiches",
    x == 6 ~ "Soup",
    x == 7 ~ "Frozen meals",
    x == 8 ~ "Ice cream/frozen yogurt with additions",
    x == 9 ~ "Dried beans or vegetable with additions",
    x == 10 ~ "Fruit with additions",
    x == 11 ~ "Tortilla products",
    x == 12 ~ "Meat, poultry, fish",
    x == 13 ~ "Lunchables",
    x == 14 ~ "Chips with additions",
    x == 15 ~ "Baby toddler food and infant formula",
    x == 90 ~ "Other mixtures",
    TRUE ~ NA_character_
  )
}

food_source_label <- function(x) {
  case_when(
    x == 1 ~ "Store grocery/supermarket",
    x == 2 ~ "Restaurant with waiter/waitress",
    x == 3 ~ "Restaurant fast food/Pizza",
    x == 4 ~ "Bar/Tavern/Lounge",
    x == 5 ~ "Restaurant, no additional information",
    x == 6 ~ "Cafeteria not in a K-12 school",
    x == 7 ~ "Cafeteria in a K-12 school",
    x == 8 ~ "Child/Adult care center",
    x == 9 ~ "Child/Adult home care",
    x == 10 ~ "Soup kitchen/shelter/food pantry facility",
    x == 11 ~ "Meals on Wheels Program",
    x == 12 ~ "Community food program - other",
    x == 13 ~ "Community program, no additional info",
    x == 14 ~ "Vending machine",
    x == 15 ~ "Common coffee pot or snack tray",
    x == 16 ~ "From someone else/gift",
    x == 17 ~ "Mail order purchase",
    x == 18 ~ "Residential dining facility",
    x == 19 ~ "Grown or caught by you or someone you know",
    x == 20 ~ "Fish caught by you or someone you know",
    x == 24 ~ "Sport, recreation, or entertainment",
    x == 25 ~ "Street vendor, vending truck",
    x == 26 ~ "Fundraiser sales",
    x == 27 ~ "Store - convenience type",
    x == 28 ~ "Store - no additional information",
    x == 91 ~ "Other",
    TRUE ~ NA_character_
  )
}

food_source_group <- function(x) {
  case_when(
    x %in% c(1, 27, 28) ~ "store",
    x %in% c(2, 3, 4, 5, 25) ~ "restaurant_or_vendor",
    x %in% c(6, 7, 8, 9, 18) ~ "institutional_or_care_setting",
    x %in% c(10, 11, 12, 13) ~ "community_food_program",
    x %in% c(14, 15, 17, 24, 26, 91) ~ "other_purchased_or_other",
    x %in% c(16, 19, 20) ~ "gift_or_homegrown",
    TRUE ~ NA_character_
  )
}

at_home_label <- function(x) {
  case_when(
    x == 1 ~ "yes",
    x == 2 ~ "no",
    x %in% c(7, 9) ~ NA_character_,
    TRUE ~ NA_character_
  )
}

# Demographics -----------------------------------------------------------------

nhanes_demographics <- read_nhanes_xpt(demo_path) |>
  transmute(
    respondent_id = SEQN,
    release_cycle = SDDSRVYR,
    interview_exam_status = case_when(
      RIDSTATR == 1 ~ "interviewed_only",
      RIDSTATR == 2 ~ "interviewed_and_examined",
      TRUE ~ NA_character_
    ),
    gender = case_when(
      RIAGENDR == 1 ~ "male",
      RIAGENDR == 2 ~ "female",
      TRUE ~ NA_character_
    ),
    age_years = RIDAGEYR,
    age_months_screening_0_to_24 = RIDAGEMN,
    age_group = case_when(
      age_years < 18 ~ "0-17",
      age_years < 30 ~ "18-29",
      age_years < 45 ~ "30-44",
      age_years < 65 ~ "45-64",
      age_years < 80 ~ "65-79",
      age_years >= 80 ~ "80+",
      TRUE ~ NA_character_
    ),
    race_ethnicity = case_when(
      RIDRETH3 == 1 ~ "Mexican American",
      RIDRETH3 == 2 ~ "Other Hispanic",
      RIDRETH3 == 3 ~ "Non-Hispanic White",
      RIDRETH3 == 4 ~ "Non-Hispanic Black",
      RIDRETH3 == 6 ~ "Non-Hispanic Asian",
      RIDRETH3 == 7 ~ "Other race including multiracial",
      TRUE ~ NA_character_
    ),
    exam_period = case_when(
      RIDEXMON == 1 ~ "November-April",
      RIDEXMON == 2 ~ "May-October",
      TRUE ~ NA_character_
    ),
    born_in_us = case_when(
      DMDBORN4 == 1 ~ "yes",
      DMDBORN4 == 2 ~ "no",
      DMDBORN4 %in% c(77, 99) ~ NA_character_,
      TRUE ~ NA_character_
    ),
    years_in_us_category = case_when(
      DMDYRUSR == 1 ~ "Less than 1 year",
      DMDYRUSR == 2 ~ "1-4 years",
      DMDYRUSR == 3 ~ "5-9 years",
      DMDYRUSR == 4 ~ "10-14 years",
      DMDYRUSR == 5 ~ "15-19 years",
      DMDYRUSR == 6 ~ "20 years or more",
      DMDYRUSR %in% c(77, 99) ~ NA_character_,
      TRUE ~ NA_character_
    ),
    education_adults_20_plus = case_when(
      DMDEDUC2 == 1 ~ "Less than 9th grade",
      DMDEDUC2 == 2 ~ "9-11th grade",
      DMDEDUC2 == 3 ~ "High school/GED",
      DMDEDUC2 == 4 ~ "Some college/AA",
      DMDEDUC2 == 5 ~ "College graduate or above",
      DMDEDUC2 %in% c(7, 9) ~ NA_character_,
      TRUE ~ NA_character_
    ),
    marital_status_adults_20_plus = case_when(
      DMDMARTZ == 1 ~ "Married/living with partner",
      DMDMARTZ == 2 ~ "Widowed/divorced/separated",
      DMDMARTZ == 3 ~ "Never married",
      DMDMARTZ %in% c(77, 99) ~ NA_character_,
      TRUE ~ NA_character_
    ),
    pregnancy_status_exam = case_when(
      RIDEXPRG == 1 ~ "pregnant",
      RIDEXPRG == 2 ~ "not_pregnant",
      RIDEXPRG == 3 ~ "cannot_ascertain",
      TRUE ~ NA_character_
    ),
    household_size = DMDHHSIZ,
    family_income_to_poverty = INDFMPIR,
    interview_weight = WTINT2YR,
    mec_exam_weight = WTMEC2YR,
    masked_variance_stratum = SDMVSTRA,
    masked_variance_psu = SDMVPSU
  ) |>
  arrange(respondent_id)

write_course_csv(nhanes_demographics, "nhanes_2021_2023_demographics.csv")

# Blood pressure ---------------------------------------------------------------

bp_raw <- read_nhanes_xpt(bp_path)

nhanes_blood_pressure <- bp_raw |>
  mutate(
    systolic_mean = row_mean_or_na(pick(BPXOSY1, BPXOSY2, BPXOSY3), c("BPXOSY1", "BPXOSY2", "BPXOSY3")),
    diastolic_mean = row_mean_or_na(pick(BPXODI1, BPXODI2, BPXODI3), c("BPXODI1", "BPXODI2", "BPXODI3")),
    pulse_mean = row_mean_or_na(pick(BPXOPLS1, BPXOPLS2, BPXOPLS3), c("BPXOPLS1", "BPXOPLS2", "BPXOPLS3")),
    systolic_n_readings = rowSums(!is.na(pick(BPXOSY1, BPXOSY2, BPXOSY3))),
    diastolic_n_readings = rowSums(!is.na(pick(BPXODI1, BPXODI2, BPXODI3)))
  ) |>
  transmute(
    respondent_id = SEQN,
    bp_arm = case_when(
      BPAOARM == "R" ~ "right",
      BPAOARM == "L" ~ "left",
      TRUE ~ NA_character_
    ),
    cuff_size = case_when(
      BPAOCSZ == 2 ~ "17-21.9 cm",
      BPAOCSZ == 3 ~ "22-31.9 cm",
      BPAOCSZ == 4 ~ "32-41.9 cm",
      BPAOCSZ == 5 ~ "42-50 cm",
      TRUE ~ NA_character_
    ),
    systolic_1 = BPXOSY1,
    diastolic_1 = BPXODI1,
    systolic_2 = BPXOSY2,
    diastolic_2 = BPXODI2,
    systolic_3 = BPXOSY3,
    diastolic_3 = BPXODI3,
    pulse_1 = BPXOPLS1,
    pulse_2 = BPXOPLS2,
    pulse_3 = BPXOPLS3,
    systolic_mean,
    diastolic_mean,
    pulse_mean,
    systolic_n_readings,
    diastolic_n_readings
  ) |>
  arrange(respondent_id)

write_course_csv(nhanes_blood_pressure, "nhanes_2021_2023_blood_pressure.csv")

# Hepatitis A ------------------------------------------------------------------

nhanes_hepatitis_a <- read_nhanes_xpt(hepa_path) |>
  transmute(
    respondent_id = SEQN,
    phlebotomy_weight = WTPH2YR,
    hepatitis_a_antibody = case_when(
      LBXHA == 1 ~ "positive",
      LBXHA == 2 ~ "negative",
      LBXHA == 3 ~ "indeterminate",
      TRUE ~ NA_character_
    ),
    hepatitis_a_antibody_positive = case_when(
      LBXHA == 1 ~ TRUE,
      LBXHA == 2 ~ FALSE,
      TRUE ~ NA
    )
  ) |>
  arrange(respondent_id)

write_course_csv(nhanes_hepatitis_a, "nhanes_2021_2023_hepatitis_a.csv")

# Dietary individual food records ---------------------------------------------

standardize_dietary_foods <- function(data, day) {
  prefix <- paste0("DR", day)
  data |>
    transmute(
      respondent_id = SEQN,
      dietary_day = day,
      dietary_day1_weight = WTDRD1,
      dietary_2day_weight = WTDR2D,
      food_line = .data[[paste0(prefix, "ILINE")]],
      recall_status = recall_status_label(.data[[paste0(prefix, "DRSTZ")]]),
      breastfed_infant_either_day = yes_no_label(DRABF),
      intake_days_available = DRDINT,
      days_between_intake_and_household_interview = .data[[paste0(prefix, "DBIH")]],
      intake_weekday = weekday_label(.data[[paste0(prefix, "DAY")]]),
      interview_language = language_label(.data[[paste0(prefix, "LANG")]]),
      combination_food_number = .data[[paste0(prefix, "CCMNM")]],
      combination_food_type = combination_type_label(.data[[paste0(prefix, "CCMTX")]]),
      eating_time = as.character(.data[[paste0(prefix, "_020")]]),
      eating_occasion = eating_occasion_label(.data[[paste0(prefix, "_030Z")]]),
      food_source_code = .data[[paste0(prefix, "FS")]],
      food_source = food_source_label(food_source_code),
      food_source_group = food_source_group(food_source_code),
      eaten_at_home = at_home_label(.data[[paste0(prefix, "_040Z")]]),
      usda_food_code = .data[[paste0(prefix, "IFDCD")]],
      grams = .data[[paste0(prefix, "IGRMS")]],
      energy_kcal = .data[[paste0(prefix, "IKCAL")]],
      protein_g = .data[[paste0(prefix, "IPROT")]],
      carbohydrate_g = .data[[paste0(prefix, "ICARB")]],
      total_sugars_g = .data[[paste0(prefix, "ISUGR")]],
      dietary_fiber_g = .data[[paste0(prefix, "IFIBE")]],
      total_fat_g = .data[[paste0(prefix, "ITFAT")]],
      saturated_fat_g = .data[[paste0(prefix, "ISFAT")]],
      cholesterol_mg = .data[[paste0(prefix, "ICHOL")]],
      sodium_mg = .data[[paste0(prefix, "ISODI")]],
      potassium_mg = .data[[paste0(prefix, "IPOTA")]],
      caffeine_mg = .data[[paste0(prefix, "ICAFF")]],
      alcohol_g = .data[[paste0(prefix, "IALCO")]]
    )
}

diet_day1 <- read_nhanes_xpt(diet_day1_path)
diet_day2 <- read_nhanes_xpt(diet_day2_path)

nhanes_dietary_foods <- bind_rows(
  standardize_dietary_foods(diet_day1, 1),
  standardize_dietary_foods(diet_day2, 2)
) |>
  arrange(respondent_id, dietary_day, food_line)

write_course_csv(nhanes_dietary_foods, "nhanes_2021_2023_dietary_foods.csv")

nhanes_dietary_daily_summary <- nhanes_dietary_foods |>
  group_by(
    respondent_id,
    dietary_day,
    dietary_day1_weight,
    dietary_2day_weight,
    recall_status,
    breastfed_infant_either_day,
    intake_days_available,
    intake_weekday
  ) |>
  summarise(
    n_food_records = n(),
    n_eating_occasions = n_distinct(eating_occasion, na.rm = TRUE),
    total_grams = sum(grams, na.rm = TRUE),
    energy_kcal = sum(energy_kcal, na.rm = TRUE),
    protein_g = sum(protein_g, na.rm = TRUE),
    carbohydrate_g = sum(carbohydrate_g, na.rm = TRUE),
    total_sugars_g = sum(total_sugars_g, na.rm = TRUE),
    dietary_fiber_g = sum(dietary_fiber_g, na.rm = TRUE),
    total_fat_g = sum(total_fat_g, na.rm = TRUE),
    saturated_fat_g = sum(saturated_fat_g, na.rm = TRUE),
    cholesterol_mg = sum(cholesterol_mg, na.rm = TRUE),
    sodium_mg = sum(sodium_mg, na.rm = TRUE),
    potassium_mg = sum(potassium_mg, na.rm = TRUE),
    caffeine_mg = sum(caffeine_mg, na.rm = TRUE),
    alcohol_g = sum(alcohol_g, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    sugars_g_per_1000_kcal = if_else(energy_kcal > 0, total_sugars_g / energy_kcal * 1000, NA_real_),
    sodium_mg_per_1000_kcal = if_else(energy_kcal > 0, sodium_mg / energy_kcal * 1000, NA_real_)
  ) |>
  arrange(respondent_id, dietary_day)

write_course_csv(nhanes_dietary_daily_summary, "nhanes_2021_2023_dietary_daily_summary.csv")

nhanes_dietary_person_summary <- nhanes_dietary_daily_summary |>
  group_by(respondent_id) |>
  summarise(
    dietary_days = n_distinct(dietary_day),
    mean_daily_energy_kcal = mean(energy_kcal, na.rm = TRUE),
    mean_daily_total_sugars_g = mean(total_sugars_g, na.rm = TRUE),
    mean_daily_dietary_fiber_g = mean(dietary_fiber_g, na.rm = TRUE),
    mean_daily_total_fat_g = mean(total_fat_g, na.rm = TRUE),
    mean_daily_saturated_fat_g = mean(saturated_fat_g, na.rm = TRUE),
    mean_daily_sodium_mg = mean(sodium_mg, na.rm = TRUE),
    mean_daily_potassium_mg = mean(potassium_mg, na.rm = TRUE),
    mean_daily_caffeine_mg = mean(caffeine_mg, na.rm = TRUE),
    mean_daily_alcohol_g = mean(alcohol_g, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    across(starts_with("mean_daily_"), ~ if_else(is.nan(.x), NA_real_, .x))
  ) |>
  left_join(
    nhanes_dietary_daily_summary |>
      select(respondent_id, dietary_day, energy_kcal, total_sugars_g, sodium_mg) |>
      pivot_wider(
        names_from = dietary_day,
        values_from = c(energy_kcal, total_sugars_g, sodium_mg),
        names_glue = "day{dietary_day}_{.value}"
      ),
    by = "respondent_id"
  ) |>
  arrange(respondent_id)

write_course_csv(nhanes_dietary_person_summary, "nhanes_2021_2023_dietary_person_summary.csv")

# Joined teaching analysis file ------------------------------------------------

nhanes_analytic <- nhanes_demographics |>
  left_join(nhanes_blood_pressure, by = "respondent_id") |>
  left_join(nhanes_hepatitis_a, by = "respondent_id") |>
  left_join(nhanes_dietary_person_summary, by = "respondent_id") |>
  mutate(
    adult_high_bp_range = case_when(
      age_years < 18 ~ NA,
      is.na(systolic_mean) | is.na(diastolic_mean) ~ NA,
      systolic_mean >= 130 | diastolic_mean >= 80 ~ TRUE,
      TRUE ~ FALSE
    ),
    adult_bp_category_simplified = case_when(
      age_years < 18 ~ NA_character_,
      is.na(systolic_mean) | is.na(diastolic_mean) ~ NA_character_,
      systolic_mean >= 140 | diastolic_mean >= 90 ~ "stage_2_range",
      systolic_mean >= 130 | diastolic_mean >= 80 ~ "stage_1_range",
      systolic_mean >= 120 & diastolic_mean < 80 ~ "elevated_range",
      systolic_mean < 120 & diastolic_mean < 80 ~ "normal_range",
      TRUE ~ NA_character_
    )
  ) |>
  arrange(respondent_id)

write_course_csv(nhanes_analytic, "nhanes_2021_2023_analysis.csv")

# Codebooks --------------------------------------------------------------------

write_codebook(
  "nhanes_2021_2023_demographics.md",
  c(
    "# NHANES 2021-2023 Demographics",
    "",
    "Source: CDC/NCHS NHANES August 2021-August 2023 `DEMO_L.xpt`.",
    "",
    "Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm>",
    "",
    "Unit of observation: one NHANES participant.",
    "",
    "Teaching use: demographic grouping, missingness, age distributions, race/ethnicity composition, education, income-to-poverty, and joins to examination/laboratory/dietary files.",
    "",
    "Important caution: NHANES is a complex survey. The cleaned files include weights and design variables, but simple unweighted classroom graphics should be described as exploratory sample visualizations, not national estimates.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `release_cycle`: data release cycle; `12` is August 2021-August 2023.",
    "- `interview_exam_status`: interviewed only or interviewed and MEC examined.",
    "- `gender`: `male` or `female`, following the public NHANES variable label.",
    "- `age_years`: age in years at screening; people age 80 or older are top-coded as `80`.",
    "- `age_months_screening_0_to_24`: age in months for young children when available.",
    "- `age_group`: generated age group for teaching graphics.",
    "- `race_ethnicity`: NHANES race/Hispanic origin with Non-Hispanic Asian category.",
    "- `exam_period`: six-month exam period when available.",
    "- `born_in_us`: whether the participant was born in the 50 states or Washington, DC.",
    "- `years_in_us_category`: years in the U.S. for participants born elsewhere.",
    "- `education_adults_20_plus`: highest education level for adults age 20+.",
    "- `marital_status_adults_20_plus`: marital status for adults age 20+.",
    "- `pregnancy_status_exam`: pregnancy status for eligible examined females age 20-44.",
    "- `household_size`: household size; `7` means seven or more people.",
    "- `family_income_to_poverty`: family income-to-poverty ratio; values at or above 5 are top-coded as 5.",
    "- `interview_weight`: full sample 2-year interview weight.",
    "- `mec_exam_weight`: full sample 2-year MEC exam weight.",
    "- `masked_variance_stratum`: masked variance pseudo-stratum.",
    "- `masked_variance_psu`: masked variance pseudo-PSU."
  )
)

write_codebook(
  "nhanes_2021_2023_blood_pressure.md",
  c(
    "# NHANES 2021-2023 Blood Pressure",
    "",
    "Source: CDC/NCHS NHANES August 2021-August 2023 `BPXO_L.xpt`.",
    "",
    "Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BPXO_L.htm>",
    "",
    "Unit of observation: one NHANES participant eligible for oscillometric blood pressure measurement, age 8+.",
    "",
    "Teaching use: repeated measurements, averages, missing readings, distributions, and joins to demographics.",
    "",
    "Important caution: readings were collected with a standardized oscillometric protocol. Use exam weights for formal NHANES estimates; unweighted classroom plots are exploratory.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `bp_arm`: arm selected for measurement, `right` or `left`.",
    "- `cuff_size`: cuff size category based on mid-arm circumference.",
    "- `systolic_1`, `systolic_2`, `systolic_3`: systolic readings in mmHg.",
    "- `diastolic_1`, `diastolic_2`, `diastolic_3`: diastolic readings in mmHg.",
    "- `pulse_1`, `pulse_2`, `pulse_3`: pulse readings.",
    "- `systolic_mean`: mean of available systolic readings.",
    "- `diastolic_mean`: mean of available diastolic readings.",
    "- `pulse_mean`: mean of available pulse readings.",
    "- `systolic_n_readings`: number of non-missing systolic readings.",
    "- `diastolic_n_readings`: number of non-missing diastolic readings."
  )
)

write_codebook(
  "nhanes_2021_2023_hepatitis_a.md",
  c(
    "# NHANES 2021-2023 Hepatitis A",
    "",
    "Source: CDC/NCHS NHANES August 2021-August 2023 `HEPA_L.xpt`.",
    "",
    "Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/HEPA_L.htm>",
    "",
    "Unit of observation: one NHANES participant eligible for hepatitis A antibody testing, age 2+.",
    "",
    "Teaching use: categorical laboratory outcome, proportions, age gradients, and joins to demographics.",
    "",
    "Important caution: total anti-HAV positivity indicates past or present infection or vaccination; this test cannot distinguish natural infection from vaccination.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `phlebotomy_weight`: phlebotomy 2-year weight.",
    "- `hepatitis_a_antibody`: `positive`, `negative`, or `indeterminate`.",
    "- `hepatitis_a_antibody_positive`: logical positive/negative version; indeterminate and missing results are missing."
  )
)

write_codebook(
  "nhanes_2021_2023_dietary_foods.md",
  c(
    "# NHANES 2021-2023 Dietary Foods",
    "",
    "Source: CDC/NCHS NHANES August 2021-August 2023 `DR1IFF_L.xpt` and `DR2IFF_L.xpt`.",
    "",
    "Documentation Day 1: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR1IFF_L.htm>",
    "",
    "Documentation Day 2: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR2IFF_L.htm>",
    "",
    "Unit of observation: one reported food or beverage item for one participant on one dietary recall day.",
    "",
    "Teaching use: long data, grouping, aggregation, food sources, eating occasions, nutrients, and repeated day comparisons.",
    "",
    "Important caution: this file does not include food descriptions because the separate FNDDS food-code description file was not provided in this processing step. Use `usda_food_code` as an identifier unless descriptions are added later.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `dietary_day`: recall day, `1` or `2`.",
    "- `dietary_day1_weight`: Day 1 dietary sample weight.",
    "- `dietary_2day_weight`: two-day dietary sample weight.",
    "- `food_line`: food/individual component number within respondent and day.",
    "- `recall_status`: dietary recall status, simplified from NHANES codes.",
    "- `breastfed_infant_either_day`: whether the participant was a breast-fed infant on either recall day.",
    "- `intake_days_available`: number of dietary recall days available.",
    "- `days_between_intake_and_household_interview`: days between intake day and household interview.",
    "- `intake_weekday`: weekday for the dietary intake day.",
    "- `interview_language`: language used mostly in the interview.",
    "- `combination_food_number`: identifier for foods eaten as part of a combination.",
    "- `combination_food_type`: combination-food type label.",
    "- `eating_time`: reported eating occasion time.",
    "- `eating_occasion`: reported eating occasion label.",
    "- `food_source_code`: original NHANES food source code.",
    "- `food_source`: detailed food source label.",
    "- `food_source_group`: generated broader food source group.",
    "- `eaten_at_home`: whether the meal/snack was eaten at home.",
    "- `usda_food_code`: USDA FNDDS food code.",
    "- `grams`: amount consumed in grams.",
    "- `energy_kcal`: energy in kilocalories.",
    "- `protein_g`, `carbohydrate_g`, `total_sugars_g`, `dietary_fiber_g`, `total_fat_g`, `saturated_fat_g`: selected nutrients in grams.",
    "- `cholesterol_mg`, `sodium_mg`, `potassium_mg`, `caffeine_mg`: selected nutrients/components in milligrams.",
    "- `alcohol_g`: alcohol in grams."
  )
)

write_codebook(
  "nhanes_2021_2023_dietary_daily_summary.md",
  c(
    "# NHANES 2021-2023 Dietary Daily Summary",
    "",
    "Source: derived from `DR1IFF_L.xpt` and `DR2IFF_L.xpt` by summing selected individual food records.",
    "",
    "Unit of observation: one participant dietary recall day.",
    "",
    "Teaching use: aggregation from item-level data, daily nutrient totals, day-to-day comparisons, and joins to demographics or health outcomes.",
    "",
    "Important caution: these totals are derived from the individual foods files, not from the official NHANES Total Nutrient Intakes files. They are intended for teaching aggregation and exploratory visualization.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `dietary_day`: recall day, `1` or `2`.",
    "- `dietary_day1_weight`, `dietary_2day_weight`: dietary sample weights.",
    "- `recall_status`: dietary recall status.",
    "- `breastfed_infant_either_day`: whether the participant was a breast-fed infant on either recall day.",
    "- `intake_days_available`: number of dietary recall days available.",
    "- `intake_weekday`: weekday for the dietary intake day.",
    "- `n_food_records`: number of reported food/beverage records for that day.",
    "- `n_eating_occasions`: number of distinct eating occasion labels that day.",
    "- `total_grams`: total grams summed across food records.",
    "- `energy_kcal`, `protein_g`, `carbohydrate_g`, `total_sugars_g`, `dietary_fiber_g`, `total_fat_g`, `saturated_fat_g`, `cholesterol_mg`, `sodium_mg`, `potassium_mg`, `caffeine_mg`, `alcohol_g`: selected daily totals.",
    "- `sugars_g_per_1000_kcal`: total sugars per 1,000 kcal when energy is greater than zero.",
    "- `sodium_mg_per_1000_kcal`: sodium per 1,000 kcal when energy is greater than zero."
  )
)

write_codebook(
  "nhanes_2021_2023_dietary_person_summary.md",
  c(
    "# NHANES 2021-2023 Dietary Person Summary",
    "",
    "Source: derived from `nhanes_2021_2023_dietary_daily_summary.csv`.",
    "",
    "Unit of observation: one participant with at least one dietary food record.",
    "",
    "Teaching use: person-level dietary features for joining to demographics, blood pressure, or hepatitis A results.",
    "",
    "Important caution: these are simple averages over available recall days and are intended for exploratory teaching examples, not formal usual-intake estimation.",
    "",
    "## Variables",
    "",
    "- `respondent_id`: NHANES respondent sequence number (`SEQN`).",
    "- `dietary_days`: number of recall days represented in the individual foods files.",
    "- `mean_daily_*`: simple mean of selected daily totals over available recall days.",
    "- `day1_energy_kcal`, `day2_energy_kcal`: recall-day-specific energy totals.",
    "- `day1_total_sugars_g`, `day2_total_sugars_g`: recall-day-specific sugar totals.",
    "- `day1_sodium_mg`, `day2_sodium_mg`: recall-day-specific sodium totals."
  )
)

write_codebook(
  "nhanes_2021_2023_analysis.md",
  c(
    "# NHANES 2021-2023 Joined Analysis File",
    "",
    "Source: joined teaching file derived from selected NHANES demographics, blood pressure, hepatitis A, and dietary summaries.",
    "",
    "Unit of observation: one NHANES participant from the demographics file.",
    "",
    "Teaching use: low-friction person-level exploratory visualization across demographics, dietary summaries, blood pressure, and hepatitis A antibody status.",
    "",
    "Important caution: this file is simplified for teaching. NHANES is a complex survey; use appropriate survey methods and weights for national estimates. The generated blood-pressure category is a simplified adult teaching variable and should not be used as a clinical diagnosis.",
    "",
    "## Variables",
    "",
    "This file includes the variables from:",
    "",
    "- `nhanes_2021_2023_demographics.csv`",
    "- `nhanes_2021_2023_blood_pressure.csv`",
    "- `nhanes_2021_2023_hepatitis_a.csv`",
    "- `nhanes_2021_2023_dietary_person_summary.csv`",
    "",
    "Additional generated variables:",
    "",
    "- `adult_high_bp_range`: for adults age 18+, whether mean systolic is at least 130 or mean diastolic is at least 80; missing for children and missing BP readings.",
    "- `adult_bp_category_simplified`: simplified adult BP range category for teaching: `normal_range`, `elevated_range`, `stage_1_range`, or `stage_2_range`."
  )
)

message("Done preparing NHANES August 2021-August 2023 teaching data files.")
