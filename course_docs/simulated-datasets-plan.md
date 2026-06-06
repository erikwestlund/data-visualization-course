# Simulated Dataset Plan

Working design spec for public-health-ish simulated datasets used across lessons and homework. The goal is to have reusable datasets that support many figure types, with each lesson dataset paired with a similarly shaped homework "cousin" dataset.

See also `course_docs/real-data-integration-plan.md` for the assessment of real public datasets from the old course. The current preferred strategy is to use real public datasets for student assignments where feasible and use simulated lookalikes for lessons or low-friction practice.

## Generated Swappable Cousin Files

`scripts/simulate-teaching-data.R` now generates simulated cousin files in `data/simulated/`. The simulated files have analog names and the same column names as their real counterparts in `data/real/` and `data/real/wide/`.

Use `data/simulated/simulated_dataset_crosswalk.csv` to look up the matching real and simulated files. Because the columns match, most downstream plotting code can swap between the real and simulated versions after changing the input path:

```r
readr::read_csv(here::here("data", "real", "nhanes_2021_2023_analysis.csv"))
readr::read_csv(here::here("data", "simulated", "neighborhood_health_survey_analysis.csv"))
```

Generated John Fox-style cousins:

- `data/simulated/measured_vs_self_reported_exercise_minutes.csv`
- `data/simulated/toothache_diary.csv`
- `data/simulated/boaty_mcboatface_passengers.csv`
- `data/simulated/rural_health_indicators.csv`
- `data/simulated/stress_beliefs_survey.csv`
- `data/simulated/physical_therapy_activity.csv`
- `data/simulated/injury_recovery_followup.csv`

Generated NHANES-style cousins:

- `data/simulated/neighborhood_health_survey_demographics.csv`
- `data/simulated/neighborhood_health_survey_blood_pressure_screening.csv`
- `data/simulated/neighborhood_health_survey_hepatitis_a.csv`
- `data/simulated/neighborhood_health_survey_dietary_foods.csv`
- `data/simulated/neighborhood_health_survey_dietary_daily_summary.csv`
- `data/simulated/neighborhood_health_survey_dietary_person_summary.csv`
- `data/simulated/neighborhood_health_survey_analysis.csv`

Generated analogs for the earlier course datasets:

- `data/simulated/new_parent_wellness_survey.csv`
- `data/simulated/new_parent_wellness_state_overall_wide.csv`
- `data/simulated/new_parent_previous_births_wide.csv`
- `data/simulated/respiratory_booster_coverage.csv`
- `data/simulated/respiratory_booster_age_month_wide.csv`
- `data/simulated/respiratory_booster_us_age_season_wide.csv`
- `data/simulated/state_school_enrollment_groups_long.csv`
- `data/simulated/state_school_enrollment_groups_wide.csv`
- `data/simulated/state_enrollment_ranks.csv`
- `data/simulated/state_enrollment_group_summary.csv`
- `data/simulated/county_wellness_indicators_long.csv`
- `data/simulated/county_wellness_indicators_wide.csv`
- `data/simulated/metro_neighborhood_wellness_indicators_long.csv`
- `data/simulated/county_noise_exposure_2025_long.csv`
- `data/simulated/county_noise_exposure_2025_wide.csv`

Matching simulated codebooks are written to `data/codebooks/` with `simulated_` prefixes.

Current validation: all generated simulated files have the same column names as the real files they mirror in `simulated_dataset_crosswalk.csv`.

## Design Principles

- Use simulated data only, with public-health-ish contexts.
- Every lesson dataset should have a homework cousin with similar structure but different topic and variable names.
- Datasets should be reusable across multiple graph types rather than one-off examples.
- Keep the data small enough for students to inspect quickly.
- Use plain CSV files and plain tidyverse code in teaching notebooks.
- Include enough variables for EDA: categorical, continuous, grouped, time, space, association, outliers, and missingness.
- Build in realistic imperfections: skew, missing values, outliers, uneven groups, and correlated variables.

## Proposed Dataset Families

### 1. Individual Survey Dataset

Primary use: Day 1 basics, continuous data, grouping, association, interaction, critique.

Lesson dataset: `lesson_maternal_health_survey.csv`

Homework cousin: `homework_adolescent_wellness_survey.csv`

Shape: one row per person.

Approximate size: 1,000 to 2,000 rows.

Lesson topic: postpartum health, care access, depression screening, social support.

Homework topic: adolescent wellness, sleep, physical activity, anxiety screening, school support.

Core variables:

- `person_id`
- `age`
- `region`
- `urbanicity`
- `race_ethnicity`
- `insurance_type` or `coverage_type`
- `income_group` or `household_resources`
- `education` or `grade_level`
- `bmi` or `body_mass_index`
- `visits_last_year` or `clinic_visits`
- `support_score`
- `stress_score`
- `screen_positive`
- `primary_outcome_score`
- `received_service`

Built-in patterns:

- skewed visit counts
- continuous scores with different centers by group
- association between stress/support and outcome
- interaction-like pattern where association differs by group
- a few outliers in BMI or score variables
- some missingness in income/resource variables

Figures supported:

- histogram
- density plot
- box plot
- violin plot
- grouped summaries
- ordered bar chart
- scatterplot
- color/facet by group
- interaction-style grouped association
- missingness check

### 2. Categorical Program Dataset

Primary use: counts, composition, rank, bar charts, proportional bars, ordered dot plots.

Lesson dataset: `lesson_vaccine_clinic_log.csv`

Homework cousin: `homework_screening_outreach_log.csv`

Shape: one row per encounter or outreach contact.

Approximate size: 2,000 to 5,000 rows.

Lesson topic: vaccination clinics.

Homework topic: community screening outreach.

Core variables:

- `encounter_id`
- `site`
- `week`
- `region`
- `age_group`
- `race_ethnicity`
- `insurance_type`
- `appointment_type` or `referral_source`
- `service_completed`
- `same_day_service`
- `language_preference`
- `travel_time_group`

Built-in patterns:

- uneven category frequencies
- one or two dominant sites
- completion differs by appointment/referral type
- composition differs by region
- some rare categories for rank/order discussion

Figures supported:

- bar chart of counts
- ordered bar chart
- lollipop/dot plot for rank
- proportional bar chart
- stacked bar chart critique
- grouped/faceted bar chart
- composition by region or site

### 3. Continuous Measurement Dataset

Primary use: center, spread, shape, outliers, distribution comparisons.

Lesson dataset: `lesson_blood_pressure_screening.csv`

Homework cousin: `homework_air_quality_symptoms.csv`

Shape: one row per measurement event.

Approximate size: 1,500 to 3,000 rows.

Lesson topic: blood pressure screening events.

Homework topic: air quality exposure and symptom scores.

Core variables:

- `measurement_id`
- `person_id`
- `site`
- `region`
- `age_group`
- `measurement_date`
- `systolic_bp` or `exposure_pm25`
- `diastolic_bp` or `symptom_score`
- `risk_group`
- `follow_up_recommended`
- `measurement_context`

Built-in patterns:

- right-skewed or mildly bimodal continuous variable
- different centers by age/risk group
- different spreads by site
- a small number of implausible/extreme values
- repeated measures for some people if we want to discuss dependence lightly

Figures supported:

- histogram
- density plot
- box plot
- violin plot
- ridgeline-style extension if desired
- outlier labeling
- grouped distribution plots
- faceted histograms

### 4. Area Indicators Dataset

Primary use: space, rank, composition by place, small multiples, map alternatives.

Lesson dataset: `lesson_county_asthma_indicators.csv`

Homework cousin: `homework_county_heat_illness_indicators.csv`

Shape: one row per area per year.

Approximate size: 500 to 2,000 rows depending on number of areas and years.

Lesson topic: county asthma burden and environmental risk.

Homework topic: county heat illness burden and heat vulnerability.

Core variables:

- `area_id`
- `area_name`
- `state`
- `region`
- `year`
- `population`
- `case_count`
- `rate_per_100k`
- `poverty_rate`
- `uninsured_rate`
- `rurality`
- `risk_index`
- `longitude`
- `latitude`

Built-in patterns:

- spatial clustering by region
- rates with unstable small-population areas
- top/bottom ranked counties
- association between vulnerability index and outcome rate
- year-to-year change

Figures supported:

- ranked dot plot
- choropleth-style map if joined to shapes or plotted with coordinates
- point map using longitude/latitude
- small multiples by year
- map alternative: ordered dot plot by region
- scatterplot of risk index vs rate
- uncertainty/instability discussion using population size

### 5. Surveillance Time Series Dataset

Primary use: change, anomalies, trajectories, before/after, faceting.

Lesson dataset: `lesson_respiratory_surveillance_weekly.csv`

Homework cousin: `homework_gastro_surveillance_weekly.csv`

Shape: one row per site per week.

Approximate size: 1,000 to 3,000 rows.

Lesson topic: respiratory illness surveillance.

Homework topic: gastrointestinal illness surveillance.

Core variables:

- `week_start`
- `week_number`
- `year`
- `site`
- `region`
- `visits`
- `positive_tests`
- `test_positivity`
- `admissions`
- `population_served`
- `rate_per_100k`
- `event_period`
- `alert_flag`

Built-in patterns:

- seasonal wave
- regional differences in timing
- one anomaly/outbreak period
- before/after intervention period
- missing weeks at one site

Figures supported:

- line chart
- faceted line chart
- before/after plot
- slope chart for pre/post summaries
- anomaly highlighting
- rolling average
- small multiples

### 6. Care Cascade / Flow Dataset

Primary use: flow, process diagrams, composition through stages, attrition.

Lesson dataset: `lesson_diabetes_care_cascade.csv`

Homework cousin: `homework_hiv_testing_cascade.csv`

Shape option A: one row per person with stage indicators.

Shape option B: one row per transition with counts.

Recommendation: include both a person-level file and a summarized transition file.

Approximate size: 1,000 to 3,000 people plus 10 to 30 transition rows.

Lesson topic: diabetes screening to treatment cascade.

Homework topic: HIV testing to linkage-to-care cascade.

Person-level variables:

- `person_id`
- `region`
- `age_group`
- `risk_group`
- `screened`
- `positive_screen`
- `confirmatory_test`
- `diagnosed`
- `linked_to_care`
- `treatment_started`
- `retained_90_days`

Transition-level variables:

- `from_stage`
- `to_stage`
- `count`
- `region`
- `group`

Built-in patterns:

- attrition at each cascade stage
- stage drop-off differs by region or group
- one bottleneck stage
- clear opportunity for intervention

Figures supported:

- cascade bar chart
- proportional attrition chart
- alluvial/Sankey extension
- Mermaid process diagram
- faceted cascade by group
- composition by stage

### 7. Model / Prediction Dataset

Primary use: association, grouped association, interaction, model visualization.

Lesson dataset: `lesson_chronic_disease_risk_model.csv`

Homework cousin: `homework_missed_visit_risk_model.csv`

Shape: one row per person.

Approximate size: 1,500 to 5,000 rows.

Lesson topic: chronic disease risk score and outcome.

Homework topic: risk of missed follow-up visit.

Core variables:

- `person_id`
- `age`
- `risk_score`
- `exposure_score`
- `protective_score`
- `group`
- `region`
- `outcome_binary`
- `outcome_continuous`
- `predicted_probability`

Built-in patterns:

- nonlinear or threshold relationship
- group-specific slopes
- confounding-like structure with group and exposure
- generated model prediction column for plotting without requiring students to fit models

Figures supported:

- scatterplot with smoother
- logistic-style probability curve
- grouped trend lines
- faceted association
- interaction visualization
- predicted probability dot/line plot

## Module Coverage Matrix

| Module | Main Lesson Dataset | Homework Cousin | Main Figures |
|---|---|---|---|
| `01-workflow-and-basics` | maternal health survey, vaccine clinic log | adolescent wellness survey, screening outreach log | first histogram, bar chart, scatterplot, grammar of graphics |
| `02_categorical-data` | vaccine clinic log | screening outreach log | counts, composition, rank, ordered bars, proportional bars |
| `03_continuous-data` | blood pressure screening | air quality symptoms | histogram, density, box plot, violin, outliers |
| `04_group-comparison` | maternal health survey, blood pressure screening | adolescent wellness survey, air quality symptoms | grouped distributions, grouped summaries, facets |
| `05_association` | chronic disease risk model, maternal health survey | missed visit risk model, adolescent wellness survey | scatterplot, smoother, grouped association, interaction |
| `06_change` | respiratory surveillance weekly | gastro surveillance weekly | line chart, small multiples, pre/post, anomalies |
| `07_space` | county asthma indicators | county heat illness indicators | maps, point maps, ranked spatial alternatives, small multiples |
| `08_flow` | diabetes care cascade | HIV testing cascade | cascade chart, attrition, process diagram, Mermaid, Sankey extension |
| `09_communication-polish` | any lesson dataset | any homework cousin | critique, redesign, annotation, accessibility, export |

## Recommended Minimal Build Set

If we want to avoid overbuilding, create these first:

1. `lesson_maternal_health_survey.csv` and `homework_adolescent_wellness_survey.csv`
2. `lesson_vaccine_clinic_log.csv` and `homework_screening_outreach_log.csv`
3. `lesson_county_asthma_indicators.csv` and `homework_county_heat_illness_indicators.csv`
4. `lesson_respiratory_surveillance_weekly.csv` and `homework_gastro_surveillance_weekly.csv`
5. `lesson_diabetes_care_cascade.csv` and `homework_hiv_testing_cascade.csv`

The model/prediction dataset can be generated later if Day 5 or association/model visualization needs more depth.

## File Organization Proposal

```text
data/
  simulated/
    lesson_maternal_health_survey.csv
    homework_adolescent_wellness_survey.csv
    lesson_vaccine_clinic_log.csv
    homework_screening_outreach_log.csv
    lesson_blood_pressure_screening.csv
    homework_air_quality_symptoms.csv
    lesson_county_asthma_indicators.csv
    homework_county_heat_illness_indicators.csv
    lesson_respiratory_surveillance_weekly.csv
    homework_gastro_surveillance_weekly.csv
    lesson_diabetes_care_cascade.csv
    homework_hiv_testing_cascade.csv
    lesson_diabetes_care_transitions.csv
    homework_hiv_testing_transitions.csv
    lesson_chronic_disease_risk_model.csv
    homework_missed_visit_risk_model.csv
  codebooks/
    lesson_maternal_health_survey.md
    homework_adolescent_wellness_survey.md
    ...
scripts/
  simulate-data.R
```

## Open Decisions

- Whether to include actual geometry files or use longitude/latitude point maps for the space module.
- Whether homework cousins should be fully parallel variable-by-variable or only structurally similar.
- Whether to make one large course-long dataset and several smaller specialty datasets, or keep each module's dataset separate.
- Whether to include intentional missingness and data-quality problems in all datasets or only later datasets.
- Whether model/prediction datasets should include precomputed predictions or require students to fit simple models.
