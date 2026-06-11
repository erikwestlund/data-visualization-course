---
title: "Course Data"
format:
  html:
    toc: true
    embed-resources: true
---

This page links to the datasets, rendered codebooks, and simulated analogs used in the course.

> **Teaching-use warning:** These datasets have been modified or generated for teaching. They should never be used for research, publication, clinical decisions, policy decisions, or official reporting. Use the original source data and documentation for any research purpose.

Open this file from the course project at `data/data.html`.

# Quick Links

- [Dataset manifest with paired dataset paths](manifest.csv)
- [Simulated dataset crosswalk for real/simulated pairs](simulated/simulated_dataset_crosswalk.csv)
- [Codebook folder](codebooks/)

# Real Datasets

| Dataset | Rows | Measures | Codebook | Topic & Key measures |
|---|---:|---:|---|---|
| [davis_height_weight.csv](real/davis_height_weight.csv) | 200 | 13 | [Codebook](codebooks/davis_height_weight.html) | measured vs self-reported exercise minutes; measured and reported values; BMI or totals; reporting errors and missing-report flags |
| [migraine_headache_diary.csv](real/migraine_headache_diary.csv) | 4152 | 5 | [Codebook](codebooks/migraine_headache_diary.html) | toothache diary; person-day, day, treatment/medication condition, reported symptom outcome |
| [titanic_passengers.csv](real/titanic_passengers.csv) | 1313 | 7 | [Codebook](codebooks/titanic_passengers.html) | fictional boat passenger survival; survival, age, class, sex, and missing-age flag |
| [infant_mortality_countries.csv](real/infant_mortality_countries.csv) | 105 | 6 | [Codebook](codebooks/infant_mortality_countries.html) | rural health indicators; income, mortality rate, region, and oil-exporter status |
| [ginzberg_depression.csv](real/ginzberg_depression.csv) | 82 | 7 | [Codebook](codebooks/ginzberg_depression.html) | stress beliefs survey; simplicity, fatalism, depression, and adjusted scale scores |
| [blackmore_davis_exercise_eating_disorders.csv](real/blackmore_davis_exercise_eating_disorders.csv) | 945 | 4 | [Codebook](codebooks/blackmore_davis_exercise_eating_disorders.html) | physical therapy activity; age, activity hours, subject/group, and repeated observations |
| [post_coma_recovery.csv](real/post_coma_recovery.csv) | 331 | 7 | [Codebook](codebooks/post_coma_recovery.html) | injury recovery follow-up; days since injury, injury duration, age, sex, and performance/verbal scores |
| [nhanes_2021_2023_demographics.csv](real/nhanes_2021_2023_demographics.csv) | 11933 | 20 | [Codebook](codebooks/nhanes_2021_2023_demographics.html) | neighborhood health survey demographics; age, age group, gender, race/ethnicity, income-to-poverty, and survey design variables |
| [nhanes_2021_2023_blood_pressure.csv](real/nhanes_2021_2023_blood_pressure.csv) | 7801 | 17 | [Codebook](codebooks/nhanes_2021_2023_blood_pressure.html) | neighborhood blood pressure screening; systolic, diastolic, pulse readings, reading means, arm, and cuff size |
| [nhanes_2021_2023_hepatitis_a.csv](real/nhanes_2021_2023_hepatitis_a.csv) | 8611 | 4 | [Codebook](codebooks/nhanes_2021_2023_hepatitis_a.html) | neighborhood hepatitis A antibody status; participant ID and hepatitis A antibody result/status |
| [nhanes_2021_2023_dietary_foods.csv](real/nhanes_2021_2023_dietary_foods.csv) | 188148 | 33 | [Codebook](codebooks/nhanes_2021_2023_dietary_foods.html) | neighborhood dietary food records; food-level recalls, eating occasion, food source, energy, nutrients, and recall day |
| [nhanes_2021_2023_dietary_daily_summary.csv](real/nhanes_2021_2023_dietary_daily_summary.csv) | 12630 | 25 | [Codebook](codebooks/nhanes_2021_2023_dietary_daily_summary.html) | neighborhood dietary daily summary; daily energy, sugars, sodium, nutrients, recall day, and recall quality fields |
| [nhanes_2021_2023_dietary_person_summary.csv](real/nhanes_2021_2023_dietary_person_summary.csv) | 6752 | 17 | [Codebook](codebooks/nhanes_2021_2023_dietary_person_summary.html) | neighborhood dietary person summary; person-level mean daily energy, sugars, sodium, recall-day totals, and number of recall days |
| [nhanes_2021_2023_analysis.csv](real/nhanes_2021_2023_analysis.csv) | 11933 | 57 | [Codebook](codebooks/nhanes_2021_2023_analysis.html) | joined neighborhood health survey; demographics, dietary summaries, blood pressure means/categories, and hepatitis A status |
| [prams_2011_selected.csv](real/prams_2011_selected.csv) | 1222 | 8 | [Codebook](codebooks/prams_2011_selected.html) | new-parent wellness subgroup estimates; state/subgroup percentages for depression, anxiety, binge drinking, and alcohol use |
| [prams_state_overall_wide.csv](real/wide/prams_state_overall_wide.csv) | 26 | 6 | [Codebook](codebooks/prams_state_overall_wide.html) | new-parent wellness state overall wide; state-level overall percentages for depression, anxiety, binge drinking, and alcohol use |
| [prams_previous_live_births_wide.csv](real/wide/prams_previous_live_births_wide.csv) | 26 | 12 | [Codebook](codebooks/prams_previous_live_births_wide.html) | new-parent wellness previous births wide; state percentages by previous-live-birth categories and wellness indicators |
| [flu_vaccination_age_time_clean.csv](real/flu_vaccination_age_time_clean.csv) | 9811 | 11 | [Codebook](codebooks/flu_vaccination_age_time_clean.html) | respiratory booster coverage; season, month, geography, age group, coverage estimate, confidence interval, and sample size |
| [flu_vaccination_age_month_wide.csv](real/wide/flu_vaccination_age_month_wide.csv) | 1782 | 28 | [Codebook](codebooks/flu_vaccination_age_month_wide.html) | respiratory booster age-month wide; age group by month coverage estimates in wide format |
| [flu_vaccination_us_age_season_wide.csv](real/wide/flu_vaccination_us_age_season_wide.csv) | 16 | 27 | [Codebook](codebooks/flu_vaccination_us_age_season_wide.html) | respiratory booster national age-season wide; national age-group coverage estimates by flu season in wide format |
| [census_state_race_ethnicity_long.csv](real/census_state_race_ethnicity_long.csv) | 357 | 8 | [Codebook](codebooks/census_state_race_ethnicity_long.html) | state school enrollment groups long; state, rank, total population, race/ethnicity group count, and share |
| [census_state_race_ethnicity_wide.csv](real/wide/census_state_race_ethnicity_wide.csv) | 51 | 19 | [Codebook](codebooks/census_state_race_ethnicity_wide.html) | state school enrollment groups wide; state-level race/ethnicity group counts and shares in wide format |
| [state_population_ranks.csv](real/state_population_ranks.csv) | 51 | 4 | [Codebook](codebooks/state_population_ranks.html) | state enrollment ranks; state, state name, population rank, and total population |
| [state_race_population_summary.csv](real/state_race_population_summary.csv) | 51 | 11 | [Codebook](codebooks/state_race_population_summary.html) | state enrollment group summary; state population totals and race/ethnicity group summaries |
| [places_county_core_measures_long.csv](real/places_county_core_measures_long.csv) | 20692 | 14 | [Codebook](codebooks/places_county_core_measures_long.html) | county wellness indicators long; county, population, PLACES measure, estimate, and confidence interval |
| [places_county_core_measures_wide.csv](real/places_county_core_measures_wide.csv) | 2956 | 15 | [Codebook](codebooks/places_county_core_measures_wide.html) | county wellness indicators wide; county population plus PLACES measure estimates in wide format |
| [places_tract_dc_md_va_core_measures_long.csv](real/places_tract_dc_md_va_core_measures_long.csv) | 26810 | 17 | [Codebook](codebooks/places_tract_dc_md_va_core_measures_long.html) | metro neighborhood wellness indicators long; tract/county geography, PLACES measure, estimate, confidence interval, and coordinates |
| [epa_air_quality_county_2025_long.csv](real/epa_air_quality_county_2025_long.csv) | 9610 | 15 | [Codebook](codebooks/epa_air_quality_county_2025_long.html) | county noise exposure long; county, pollutant, statistic, unit, value, status, standard, and exceedance flag |
| [epa_air_quality_county_2025_wide.csv](real/epa_air_quality_county_2025_wide.csv) | 961 | 26 | [Codebook](codebooks/epa_air_quality_county_2025_wide.html) | county noise exposure wide; county-level pollutant metric values and reporting-status fields in wide format |

# Simulated Analog Datasets

| Dataset | Rows | Measures | Codebook | Topic & Key measures |
|---|---:|---:|---|---|
| [measured_vs_self_reported_exercise_minutes.csv](simulated/measured_vs_self_reported_exercise_minutes.csv) | 220 | 13 | [Codebook](codebooks/simulated_measured_vs_self_reported_exercise_minutes.html) | measured vs self-reported exercise minutes; measured and reported values; BMI or totals; reporting errors and missing-report flags |
| [toothache_diary.csv](simulated/toothache_diary.csv) | 6695 | 5 | [Codebook](codebooks/simulated_toothache_diary.html) | toothache diary; person-day, day, treatment/medication condition, reported symptom outcome |
| [boaty_mcboatface_passengers.csv](simulated/boaty_mcboatface_passengers.csv) | 1250 | 7 | [Codebook](codebooks/simulated_boaty_mcboatface_passengers.html) | fictional boat passenger survival; survival, age, class, sex, and missing-age flag |
| [rural_health_indicators.csv](simulated/rural_health_indicators.csv) | 110 | 6 | [Codebook](codebooks/simulated_rural_health_indicators.html) | rural health indicators; income, mortality rate, region, and oil-exporter status |
| [stress_beliefs_survey.csv](simulated/stress_beliefs_survey.csv) | 95 | 7 | [Codebook](codebooks/simulated_stress_beliefs_survey.html) | stress beliefs survey; simplicity, fatalism, depression, and adjusted scale scores |
| [physical_therapy_activity.csv](simulated/physical_therapy_activity.csv) | 839 | 4 | [Codebook](codebooks/simulated_physical_therapy_activity.html) | physical therapy activity; age, activity hours, subject/group, and repeated observations |
| [injury_recovery_followup.csv](simulated/injury_recovery_followup.csv) | 330 | 7 | [Codebook](codebooks/simulated_injury_recovery_followup.html) | injury recovery follow-up; days since injury, injury duration, age, sex, and performance/verbal scores |
| [neighborhood_health_survey_demographics.csv](simulated/neighborhood_health_survey_demographics.csv) | 6000 | 20 | [Codebook](codebooks/simulated_neighborhood_health_survey_demographics.html) | neighborhood health survey demographics; age, age group, gender, race/ethnicity, income-to-poverty, and survey design variables |
| [neighborhood_health_survey_blood_pressure_screening.csv](simulated/neighborhood_health_survey_blood_pressure_screening.csv) | 3900 | 17 | [Codebook](codebooks/simulated_neighborhood_health_survey_blood_pressure_screening.html) | neighborhood blood pressure screening; systolic, diastolic, pulse readings, reading means, arm, and cuff size |
| [neighborhood_health_survey_hepatitis_a.csv](simulated/neighborhood_health_survey_hepatitis_a.csv) | 4300 | 4 | [Codebook](codebooks/simulated_neighborhood_health_survey_hepatitis_a.html) | neighborhood hepatitis A antibody status; participant ID and hepatitis A antibody result/status |
| [neighborhood_health_survey_dietary_foods.csv](simulated/neighborhood_health_survey_dietary_foods.csv) | 85225 | 33 | [Codebook](codebooks/simulated_neighborhood_health_survey_dietary_foods.html) | neighborhood dietary food records; food-level recalls, eating occasion, food source, energy, nutrients, and recall day |
| [neighborhood_health_survey_dietary_daily_summary.csv](simulated/neighborhood_health_survey_dietary_daily_summary.csv) | 6309 | 25 | [Codebook](codebooks/simulated_neighborhood_health_survey_dietary_daily_summary.html) | neighborhood dietary daily summary; daily energy, sugars, sodium, nutrients, recall day, and recall quality fields |
| [neighborhood_health_survey_dietary_person_summary.csv](simulated/neighborhood_health_survey_dietary_person_summary.csv) | 3400 | 17 | [Codebook](codebooks/simulated_neighborhood_health_survey_dietary_person_summary.html) | neighborhood dietary person summary; person-level mean daily energy, sugars, sodium, recall-day totals, and number of recall days |
| [neighborhood_health_survey_analysis.csv](simulated/neighborhood_health_survey_analysis.csv) | 6000 | 57 | [Codebook](codebooks/simulated_neighborhood_health_survey_analysis.html) | joined neighborhood health survey; demographics, dietary summaries, blood pressure means/categories, and hepatitis A status |
| [new_parent_wellness_survey.csv](simulated/new_parent_wellness_survey.csv) | 510 | 8 | [Codebook](codebooks/simulated_new_parent_wellness_survey.html) | new-parent wellness subgroup estimates; state/subgroup percentages for depression, anxiety, binge drinking, and alcohol use |
| [new_parent_wellness_state_overall_wide.csv](simulated/new_parent_wellness_state_overall_wide.csv) | 51 | 6 | [Codebook](codebooks/simulated_new_parent_wellness_state_overall_wide.html) | new-parent wellness state overall wide; state-level overall percentages for depression, anxiety, binge drinking, and alcohol use |
| [new_parent_previous_births_wide.csv](simulated/new_parent_previous_births_wide.csv) | 51 | 12 | [Codebook](codebooks/simulated_new_parent_previous_births_wide.html) | new-parent wellness previous births wide; state percentages by previous-live-birth categories and wellness indicators |
| [respiratory_booster_coverage.csv](simulated/respiratory_booster_coverage.csv) | 7920 | 11 | [Codebook](codebooks/simulated_respiratory_booster_coverage.html) | respiratory booster coverage; season, month, geography, age group, coverage estimate, confidence interval, and sample size |
| [respiratory_booster_age_month_wide.csv](simulated/respiratory_booster_age_month_wide.csv) | 1320 | 28 | [Codebook](codebooks/simulated_respiratory_booster_age_month_wide.html) | respiratory booster age-month wide; age group by month coverage estimates in wide format |
| [respiratory_booster_us_age_season_wide.csv](simulated/respiratory_booster_us_age_season_wide.csv) | 10 | 27 | [Codebook](codebooks/simulated_respiratory_booster_us_age_season_wide.html) | respiratory booster national age-season wide; national age-group coverage estimates by flu season in wide format |
| [state_school_enrollment_groups_long.csv](simulated/state_school_enrollment_groups_long.csv) | 357 | 8 | [Codebook](codebooks/simulated_state_school_enrollment_groups_long.html) | state school enrollment groups long; state, rank, total population, race/ethnicity group count, and share |
| [state_school_enrollment_groups_wide.csv](simulated/state_school_enrollment_groups_wide.csv) | 51 | 19 | [Codebook](codebooks/simulated_state_school_enrollment_groups_wide.html) | state school enrollment groups wide; state-level race/ethnicity group counts and shares in wide format |
| [state_enrollment_ranks.csv](simulated/state_enrollment_ranks.csv) | 51 | 4 | [Codebook](codebooks/simulated_state_enrollment_ranks.html) | state enrollment ranks; state, state name, population rank, and total population |
| [state_enrollment_group_summary.csv](simulated/state_enrollment_group_summary.csv) | 51 | 11 | [Codebook](codebooks/simulated_state_enrollment_group_summary.html) | state enrollment group summary; state population totals and race/ethnicity group summaries |
| [county_wellness_indicators_long.csv](simulated/county_wellness_indicators_long.csv) | 3640 | 14 | [Codebook](codebooks/simulated_county_wellness_indicators_long.html) | county wellness indicators long; county, population, PLACES measure, estimate, and confidence interval |
| [county_wellness_indicators_wide.csv](simulated/county_wellness_indicators_wide.csv) | 520 | 15 | [Codebook](codebooks/simulated_county_wellness_indicators_wide.html) | county wellness indicators wide; county population plus PLACES measure estimates in wide format |
| [metro_neighborhood_wellness_indicators_long.csv](simulated/metro_neighborhood_wellness_indicators_long.csv) | 4900 | 17 | [Codebook](codebooks/simulated_metro_neighborhood_wellness_indicators_long.html) | metro neighborhood wellness indicators long; tract/county geography, PLACES measure, estimate, confidence interval, and coordinates |
| [county_noise_exposure_2025_long.csv](simulated/county_noise_exposure_2025_long.csv) | 3200 | 15 | [Codebook](codebooks/simulated_county_noise_exposure_2025_long.html) | county noise exposure long; county, pollutant, statistic, unit, value, status, standard, and exceedance flag |
| [county_noise_exposure_2025_wide.csv](simulated/county_noise_exposure_2025_wide.csv) | 320 | 26 | [Codebook](codebooks/simulated_county_noise_exposure_2025_wide.html) | county noise exposure wide; county-level pollutant metric values and reporting-status fields in wide format |

# Metadata Files

| Dataset | Rows | Measures | Codebook | Topic & Key measures |
|---|---:|---:|---|---|
| [manifest.csv](manifest.csv) | 60 | 9 | [Codebook](codebooks/data_manifest.html) | data directory manifest; dataset paths, rows, measures, codebooks, dataset kind, pairing ID, and simulated analog links |
| [simulated_dataset_crosswalk.csv](simulated/simulated_dataset_crosswalk.csv) | 29 | 3 | [Codebook](codebooks/simulated_dataset_crosswalk.html) | real-to-simulated dataset crosswalk; real dataset path, simulated analog path, and pairing topic |

# Dataset Notes

- [PRAMS selected data](real/prams_2011_selected.csv) are pre-aggregated state/subgroup estimates, not person-level records. Original source/context: [CDC PRAMS](https://www.cdc.gov/prams/index.html). Start with the [PRAMS codebook](codebooks/prams_2011_selected.html).
- [Census race/ethnicity data](real/census_state_race_ethnicity_long.csv) are state-level counts and shares. The `share` denominator is the sum of the included race/ethnicity categories in the file; see the [Census long codebook](codebooks/census_state_race_ethnicity_long.html).
- [Flu vaccination data](real/flu_vaccination_age_time_clean.csv) are useful for change over time and age-group comparisons. Check the [flu vaccination codebook](codebooks/flu_vaccination_age_time_clean.html) before interpreting time trends.
- [NHANES analysis data](real/nhanes_2021_2023_analysis.csv) are simplified teaching files from a complex survey. Original source/context: [CDC/NCHS NHANES](https://www.cdc.gov/nchs/nhanes/index.html). Treat plots as exploratory sample visualizations, not national estimates; see the [NHANES analysis codebook](codebooks/nhanes_2021_2023_analysis.html).
- [NHANES dietary data](real/nhanes_2021_2023_dietary_foods.csv) are long food-record data, while [NHANES dietary person summaries](real/nhanes_2021_2023_dietary_person_summary.csv) are derived summaries. Original source/context: [CDC/NCHS NHANES](https://www.cdc.gov/nchs/nhanes/index.html). See the [dietary foods codebook](codebooks/nhanes_2021_2023_dietary_foods.html) and [dietary person summary codebook](codebooks/nhanes_2021_2023_dietary_person_summary.html).
- [PLACES county data](real/places_county_core_measures_long.csv) and [PLACES tract data](real/places_tract_dc_md_va_core_measures_long.csv) are area-level estimates, not person-level observations. See the [PLACES county codebook](codebooks/places_county_core_measures_long.html) and [PLACES tract codebook](codebooks/places_tract_dc_md_va_core_measures_long.html).
- [EPA air quality data](real/epa_air_quality_county_2025_long.csv) summarize monitored county pollutant information. Original source/context: [EPA Air Quality in Cities and Counties](https://www.epa.gov/air-trends/air-quality-cities-and-counties). Missing numeric values can reflect no data or insufficient data; see the [EPA air quality codebook](codebooks/epa_air_quality_county_2025_long.html).
- John Fox teaching datasets, including Titanic, migraine, depression, Blackmore and Davis eating-disorder exercise, and recovery examples, are useful small teaching datasets. Original source/context: [John Fox Applied Regression data archive](https://www.john-fox.ca/AppliedRegression/datasets/index.html). Some topics are sensitive; use respectful language and check the linked codebooks before plotting.
- Real and simulated paired datasets have matching column names. Use the [dataset manifest](manifest.csv) or [simulated dataset crosswalk](simulated/simulated_dataset_crosswalk.csv) to find pairs.
