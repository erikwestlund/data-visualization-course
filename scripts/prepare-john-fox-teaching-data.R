# Prepare small row-level teaching datasets from John Fox's Applied Regression data archive.
#
# Source page:
# https://www.john-fox.ca/AppliedRegression/datasets/index.html

required_packages <- c("dplyr", "readr", "stringr")
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

source_base_url <- "https://www.john-fox.ca/AppliedRegression/datasets"
output_dir <- "data/real"
codebook_dir <- "data/codebooks"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(codebook_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading John Fox Applied Regression data from: ", source_base_url)
message("Writing cleaned data to: ", normalizePath(output_dir, mustWork = FALSE))

source_url <- function(filename) {
  paste0(source_base_url, "/", filename)
}

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

# Davis height and weight data -------------------------------------------------

davis_raw <- read.table(
  source_url("Davis.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
)

davis_height_weight <- davis_raw |>
  mutate(participant_id = as.integer(rownames(davis_raw)), .before = 1) |>
  rename(
    weight_kg = weight,
    height_cm = height,
    reported_weight_kg = reportedWeight,
    reported_height_cm = reportedHeight
  ) |>
  mutate(
    sex = recode(sex, M = "male", F = "female"),
    measured_bmi = weight_kg / (height_cm / 100)^2,
    reported_bmi = reported_weight_kg / (reported_height_cm / 100)^2,
    weight_reporting_error_kg = reported_weight_kg - weight_kg,
    height_reporting_error_cm = reported_height_cm - height_cm,
    missing_reported_weight = is.na(reported_weight_kg),
    missing_reported_height = is.na(reported_height_cm),
    likely_swapped_measured_values = weight_kg > 120 & height_cm < 100
  ) |>
  select(
    participant_id,
    sex,
    weight_kg,
    height_cm,
    reported_weight_kg,
    reported_height_cm,
    measured_bmi,
    reported_bmi,
    weight_reporting_error_kg,
    height_reporting_error_cm,
    missing_reported_weight,
    missing_reported_height,
    likely_swapped_measured_values
  ) |>
  arrange(participant_id)

write_course_csv(davis_height_weight, "davis_height_weight.csv")

write_codebook(
  "davis_height_weight.md",
  c(
    "# Davis Height Weight",
    "",
    "Source: John Fox Applied Regression data archive, `Davis.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: Davis's data on height and weight of exercisers.",
    "",
    "Unit of observation: one person.",
    "",
    "Teaching use: simple individual-level data for scatterplots, distributions, missing reported values, outliers, and self-reporting error.",
    "",
    "Important caution: one row has implausible measured height and weight values that appear to be swapped in the source data. The row is preserved and flagged instead of corrected so it can be used for teaching outlier checks.",
    "",
    "## Variables",
    "",
    "- `participant_id`: row identifier from the source file.",
    "- `sex`: `female` or `male`.",
    "- `weight_kg`: measured body weight in kilograms.",
    "- `height_cm`: measured height in centimeters.",
    "- `reported_weight_kg`: self-reported body weight in kilograms; missing when not reported.",
    "- `reported_height_cm`: self-reported height in centimeters; missing when not reported.",
    "- `measured_bmi`: BMI computed from measured weight and height.",
    "- `reported_bmi`: BMI computed from reported weight and height; missing if reported weight or height is missing.",
    "- `weight_reporting_error_kg`: reported weight minus measured weight.",
    "- `height_reporting_error_cm`: reported height minus measured height.",
    "- `missing_reported_weight`: whether reported weight is missing.",
    "- `missing_reported_height`: whether reported height is missing.",
    "- `likely_swapped_measured_values`: whether measured weight is above 120 kg and measured height is below 100 cm, flagging the implausible source row."
  )
)

# Migraine headache diary data -------------------------------------------------

migraine_headache_diary <- read_table(
  source_url("Migraines.txt"),
  col_names = TRUE,
  na = "NA",
  col_types = cols(
    id = col_integer(),
    headache = col_character(),
    time = col_integer(),
    medication = col_character()
  )
) |>
  transmute(
    participant_id = id,
    day = time,
    medication = str_to_lower(medication),
    headache = str_to_lower(headache),
    headache_reported = headache == "yes"
  ) |>
  mutate(
    medication = case_when(
      medication == "continuing" ~ "continuing",
      medication == "reduced" ~ "reduced",
      medication == "none" ~ "none",
      TRUE ~ medication
    ),
    headache = case_when(
      headache == "yes" ~ "yes",
      headache == "no" ~ "no",
      TRUE ~ headache
    )
  ) |>
  arrange(participant_id, day)

write_course_csv(migraine_headache_diary, "migraine_headache_diary.csv")

write_codebook(
  "migraine_headache_diary.md",
  c(
    "# Migraine Headache Diary",
    "",
    "Source: John Fox Applied Regression data archive, `Migraines.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: data on migraine headaches from Kostecki-Dillon, Monette, and Wong.",
    "",
    "Unit of observation: one person-day headache diary record.",
    "",
    "Teaching use: repeated observations, categorical outcomes, time trends, grouped summaries, and individual trajectories.",
    "",
    "Important caution: people contribute different numbers of diary days, and some day values are negative because the source time scale includes observations before the reference day used in the study.",
    "",
    "## Variables",
    "",
    "- `participant_id`: person identifier from the source file.",
    "- `day`: study day on the source time scale.",
    "- `medication`: medication condition recorded in the source data: `continuing`, `reduced`, or `none`.",
    "- `headache`: whether a headache was reported on that diary day: `yes` or `no`.",
    "- `headache_reported`: logical version of `headache`, useful for calculating proportions."
  )
)

# Titanic passenger survival data ---------------------------------------------

titanic_raw <- read.table(
  source_url("Titanic.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
)

titanic_passengers <- titanic_raw |>
  mutate(passenger_name = rownames(titanic_raw), .before = 1) |>
  transmute(
    passenger_name,
    survived = str_to_lower(survived),
    age_years = age,
    passenger_class = passengerClass,
    sex = str_to_lower(sex),
    survived_logical = survived == "yes",
    missing_age = is.na(age_years)
  ) |>
  arrange(passenger_class, sex, passenger_name)

write_course_csv(titanic_passengers, "titanic_passengers.csv")

write_codebook(
  "titanic_passengers.md",
  c(
    "# Titanic Passengers",
    "",
    "Source: John Fox Applied Regression data archive, `Titanic.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: survival of passengers on the Titanic. The archive notes that this version includes passengers, not crew, and has exact age for about half of the passengers.",
    "",
    "Unit of observation: one Titanic passenger.",
    "",
    "Teaching use: categorical comparisons, missing age, composition, proportions, and grouped survival summaries.",
    "",
    "## Variables",
    "",
    "- `passenger_name`: passenger name from the source row label.",
    "- `survived`: whether the passenger survived, `yes` or `no`.",
    "- `age_years`: age in years; missing when exact age is unavailable.",
    "- `passenger_class`: passenger class, `1st`, `2nd`, or `3rd`.",
    "- `sex`: passenger sex, `female` or `male`.",
    "- `survived_logical`: logical version of `survived`, useful for calculating proportions.",
    "- `missing_age`: whether `age_years` is missing."
  )
)

# Leinhardt infant mortality data ---------------------------------------------

leinhardt_raw <- read.table(
  source_url("Leinhardt.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
)

infant_mortality_countries <- leinhardt_raw |>
  mutate(country_name = rownames(leinhardt_raw), .before = 1) |>
  transmute(
    country_name,
    income_usd_per_capita = income,
    infant_mortality_per_1000 = infant,
    region,
    oil_exporting_country = oil,
    oil_exporter = oil == "yes"
  ) |>
  arrange(region, country_name)

write_course_csv(infant_mortality_countries, "infant_mortality_countries.csv")

write_codebook(
  "infant_mortality_countries.md",
  c(
    "# Infant Mortality Countries",
    "",
    "Source: John Fox Applied Regression data archive, `Leinhardt.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: Leinhardt and Wasserman's data on infant mortality.",
    "",
    "Original sources listed by the archive: Leinhardt and Wasserman (1979), and The New York Times, 28 September 1975, p. E-3, Table 3.",
    "",
    "Unit of observation: one country.",
    "",
    "Teaching use: association between income and infant mortality, grouped comparisons by region, outliers, transformations, and label-aware scatterplots.",
    "",
    "## Variables",
    "",
    "- `country_name`: country name from the source row label.",
    "- `income_usd_per_capita`: per-capita income in U.S. dollars.",
    "- `infant_mortality_per_1000`: infant mortality rate per 1,000 live births.",
    "- `region`: world region: `Africa`, `Americas`, `Asia`, or `Europe`.",
    "- `oil_exporting_country`: source oil-exporting indicator, `yes` or `no`.",
    "- `oil_exporter`: logical version of `oil_exporting_country`."
  )
)

# Ginzberg depression data -----------------------------------------------------

ginzberg_depression <- read.table(
  source_url("Ginzberg.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
) |>
  mutate(participant_id = row_number(), .before = 1) |>
  arrange(participant_id)

write_course_csv(ginzberg_depression, "ginzberg_depression.csv")

write_codebook(
  "ginzberg_depression.md",
  c(
    "# Ginzberg Depression",
    "",
    "Source: John Fox Applied Regression data archive, `Ginzberg.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: Ginzberg's data on depression, supplied to the archive by Georges Monette with permission of the original investigator.",
    "",
    "Unit of observation: one subject.",
    "",
    "Teaching use: scatterplots, association, variable adjustment, pairs of raw and adjusted measures, and interpretation caution.",
    "",
    "## Variables",
    "",
    "- `participant_id`: generated row identifier.",
    "- `simplicity`: measure of the subject's need to see the world in black and white.",
    "- `fatalism`: fatalism scale.",
    "- `depression`: Beck self-report depression scale.",
    "- `adjsimplicity`: simplicity adjusted by regression for other variables thought to influence depression.",
    "- `adjfatalism`: adjusted fatalism scale.",
    "- `adjdepression`: adjusted depression scale."
  )
)

# Blackmore and Davis exercise and eating-disorder data -----------------------

blackmore_davis_exercise_eating_disorders <- read.table(
  source_url("Blackmore.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
) |>
  transmute(
    subject_id = as.character(subject),
    age_years = age,
    exercise_hours_per_week = exercise,
    group
  ) |>
  arrange(group, subject_id, age_years)

write_course_csv(blackmore_davis_exercise_eating_disorders, "blackmore_davis_exercise_eating_disorders.csv")

write_codebook(
  "blackmore_davis_exercise_eating_disorders.md",
  c(
    "# Blackmore Davis Exercise Eating Disorders",
    "",
    "Source: John Fox Applied Regression data archive, `Blackmore.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: Blackmore and Davis's longitudinal data on eating disorders and exercise.",
    "",
    "Unit of observation: one subject-age observation.",
    "",
    "Teaching use: repeated observations, grouped trajectories, distribution of exercise, outliers, and grouped summaries over age.",
    "",
    "## Variables",
    "",
    "- `subject_id`: subject identifier from the source file.",
    "- `age_years`: age in years at the time of observation.",
    "- `exercise_hours_per_week`: exercise time in hours per week.",
    "- `group`: `control` for control subjects or `patient` for eating-disordered patients."
  )
)

# Wong post-coma IQ recovery data ---------------------------------------------

post_coma_recovery <- read.table(
  source_url("Wong.txt"),
  header = TRUE,
  na.strings = "NA",
  stringsAsFactors = FALSE
) |>
  transmute(
    patient_id = id,
    days_post_coma = days,
    coma_duration_days = duration,
    sex = str_to_lower(sex),
    age_at_injury_years = age,
    performance_iq = piq,
    verbal_iq = viq
  ) |>
  arrange(patient_id, days_post_coma)

write_course_csv(post_coma_recovery, "post_coma_recovery.csv")

write_codebook(
  "post_coma_recovery.md",
  c(
    "# Post Coma Recovery",
    "",
    "Source: John Fox Applied Regression data archive, `Wong.txt`.",
    "",
    "Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>",
    "",
    "Source description: Wong, Monette, and Weiner's data on post-coma recovery of IQ.",
    "",
    "Unit of observation: one patient IQ measurement after coma.",
    "",
    "Teaching use: association, grouped scatterplots, recovery timing, sex/group comparisons, and outcome comparisons between performance and verbal IQ.",
    "",
    "## Variables",
    "",
    "- `patient_id`: patient identifier from the source file.",
    "- `days_post_coma`: number of days post-coma at which IQs were measured.",
    "- `coma_duration_days`: duration of the coma in days.",
    "- `sex`: `female` or `male`.",
    "- `age_at_injury_years`: age in years at the time of injury.",
    "- `performance_iq`: performance IQ.",
    "- `verbal_iq`: verbal IQ."
  )
)

message("Done preparing John Fox teaching data files.")
