# Additional Public Dataset Candidates

Candidate public, non-simulated datasets to add after the current PRAMS, CDC flu vaccination, and Census state datasets. The goal is to add datasets that support different visualization tasks without relying on private data.

## Added John Fox Teaching Data

Seven small John Fox Applied Regression datasets have been added through `scripts/prepare-john-fox-teaching-data.R`. They are useful because they are public, small, varied, and do not require API keys or large raw downloads.

| Dataset | Clean File | Why Add It | Main Visualization Tasks |
|---|---|---|---|
| Davis height and weight of exercisers | `data/real/davis_height_weight.csv` | Simple individual-level data with measured versus self-reported height/weight, missing reported values, and one preserved implausible source row flagged for outlier teaching. | distribution, association, missingness, outliers, grouped comparison |
| Migraine headache diary | `data/real/migraine_headache_diary.csv` | Repeated person-day health observations with headache status, study day, and medication condition. | change, grouping, proportions, repeated observations, individual trajectories |
| Titanic passenger survival | `data/real/titanic_passengers.csv` | Passenger-level survival data with class, sex, and missing age. | categorical comparison, composition, proportions, missingness |
| Leinhardt infant mortality | `data/real/infant_mortality_countries.csv` | Country-level infant mortality, income, region, and oil-exporting status. | association, grouping, transformations, outliers, labels |
| Ginzberg depression | `data/real/ginzberg_depression.csv` | Subject-level depression, fatalism, simplicity, and adjusted versions of those measures. | association, scatterplots, adjusted measures, interpretation caution |
| Blackmore exercise and eating disorders | `data/real/exercise_eating_disorders.csv` | Repeated observations of exercise hours by age for eating-disordered patients and controls. | grouped trajectories, distributions, change, outliers |
| Wong post-coma IQ recovery | `data/real/post_coma_recovery.csv` | Patient-level post-coma IQ measurements with days post-coma, coma duration, age, and sex. | association, grouping, recovery timing, outcome comparison |

Likely course placement:

- Use `davis_height_weight.csv` for Day 2 distributions, missingness, outliers, and measured-versus-reported scatterplots.
- Use `migraine_headache_diary.csv` for Day 4 change/repeated-observation examples or optional project practice.
- Use `titanic_passengers.csv` for early categorical comparisons and proportions.
- Use `infant_mortality_countries.csv`, `ginzberg_depression.csv`, and `post_coma_recovery.csv` for association examples.
- Use `exercise_eating_disorders.csv` for repeated/grouped trajectories.
- Use the NHANES section below for larger person-level public-health examples.

## Added NHANES Teaching Data

NHANES August 2021-August 2023 public-use data have been added through `scripts/prepare-nhanes-2021-2023-data.R`, using local XPT files downloaded from CDC/NCHS.

Cleaned files:

- `data/real/nhanes_2021_2023_demographics.csv`: selected demographics, weights, and survey design variables; one row per participant.
- `data/real/nhanes_2021_2023_blood_pressure.csv`: oscillometric blood pressure readings and row means; one row per eligible participant age 8+.
- `data/real/nhanes_2021_2023_hepatitis_a.csv`: hepatitis A antibody status; one row per eligible participant age 2+.
- `data/real/nhanes_2021_2023_dietary_foods.csv`: selected Day 1 and Day 2 individual food records; one row per reported food/beverage item.
- `data/real/nhanes_2021_2023_dietary_daily_summary.csv`: derived daily nutrient totals from the individual food records; one row per participant-day.
- `data/real/nhanes_2021_2023_dietary_person_summary.csv`: simple person-level dietary means over available recall days.
- `data/real/nhanes_2021_2023_analysis.csv`: joined person-level teaching file combining demographics, blood pressure, hepatitis A, and dietary person summaries.

Likely course placement:

- Use `nhanes_2021_2023_analysis.csv` for low-friction association/grouping examples, such as diet summaries by age group or blood pressure by demographics.
- Use `nhanes_2021_2023_dietary_foods.csv` for long-data aggregation practice and examples of item-level records becoming daily summaries.
- Use `nhanes_2021_2023_blood_pressure.csv` for repeated-measurement and distribution examples.
- Use `nhanes_2021_2023_hepatitis_a.csv` for categorical outcome and age-gradient examples.

Teaching cautions:

- NHANES is a complex survey. The cleaned files include weights/design variables where relevant, but simple classroom plots should be framed as exploratory sample visualizations, not national estimates.
- The dietary daily summaries are derived by summing selected individual food records because the total nutrient files were not part of this processing step.
- The dietary food file does not include food descriptions yet because the separate FNDDS food-code description file was not provided.
- The joined analysis file is simplified for teaching and includes a generated adult blood-pressure range category that should not be treated as a clinical diagnosis.

## Larger Public Data Sources

Added or candidate larger public data sources. CDC PLACES has now been partially added through `scripts/prepare-places-data.R`, which creates small county-level and DC/MD/VA tract-level teaching extracts from the large census tract source file.

## PLACES Course Use Possibility

PLACES is a strong candidate for Day 4 material on space, rank, association, and alternatives to maps.

Best uses:

- county rank plots using `data/real/places_county_core_measures_wide.csv`
- county association plots, such as obesity versus physical inactivity or diabetes versus obesity
- grouped state or regional comparisons using `data/real/places_county_core_measures_long.csv`
- small multiples by measure
- map alternatives, especially ranked dot plots and faceted county comparisons
- local tract-level variation using `data/real/places_tract_dc_md_va_core_measures_long.csv`
- final project dataset option for students who want a real public health dataset

Teaching cautions:

- The county files are derived from tract-level estimates and should be treated as teaching/exploratory files, not official county PLACES releases.
- The data are area-level estimates, not person-level observations.
- Kentucky and Pennsylvania are absent from the selected 2023 tract measures used here.
- The current cleaned version is not ideal for change-over-time assignments because it only keeps 2023 core measures.

Likely course placement:

- Do not use on Day 1.
- Use for Day 4 spatial comparison, map alternatives, rank, and association.
- Consider as an optional final project dataset.

| Candidate | Source | Proposed Clean File | Why Add It | Main Visualization Tasks |
|---|---|---|---|---|
| CDC PLACES county health indicators | <https://chronicdata.cdc.gov/browse?category=500+Cities+%26+Places> | `data/real/places_county_core_measures_wide.csv`; `data/real/places_county_core_measures_long.csv`; `data/real/places_tract_dc_md_va_core_measures_long.csv` | County-level public health estimates are useful for spatial comparison, rank, association, and small multiples. | space, rank, grouping, association, outliers |
| Census ACS state social/economic indicators | <https://www.census.gov/programs-surveys/acs/data.html> | `data/real/acs_state_social_economic_indicators.csv` | Adds yearly Census estimates such as poverty, insurance, education, and income; useful to join to state health outcomes. | rank, composition, association, space |
| EPA county air quality statistics | <https://www.epa.gov/outdoor-air-quality-data> | `data/real/epa_air_quality_county_2025_wide.csv`; `data/real/epa_air_quality_county_2025_long.csv` | Adds monitored county air quality summaries, pollutant comparisons, standards, and missing-monitoring-data examples. | space, rank, anomalies, missingness, threshold comparison |
| John Fox Applied Regression teaching datasets | <https://www.john-fox.ca/AppliedRegression/datasets/index.html> | `data/real/davis_height_weight.csv`; `data/real/migraine_headache_diary.csv`; `data/real/titanic_passengers.csv`; `data/real/infant_mortality_countries.csv`; `data/real/ginzberg_depression.csv`; `data/real/exercise_eating_disorders.csv`; `data/real/post_coma_recovery.csv` | Adds small teaching data for individual measurements, repeated health observations, passenger survival, country health indicators, depression scales, exercise histories, and post-coma recovery. | distribution, association, missingness, outliers, change, grouping, composition |
| NHANES 2021-2023 selected public-use files | <https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023> | `data/real/nhanes_2021_2023_analysis.csv`; `data/real/nhanes_2021_2023_dietary_foods.csv`; plus component extracts | Adds individual-level national health, diet, blood pressure, and hepatitis A teaching data. | distribution, association, grouping, aggregation, missingness, repeated measures |
| World Bank health/development indicators | <https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation> | `data/real/world_bank_health_development_indicators.csv` | Adds international country-year data with long time series and multiple indicators. | change, association, grouping, rank |
| NOAA Storm Events | <https://www.ncei.noaa.gov/products/storm-events> | `data/real/noaa_storm_events_selected.csv` | Adds event-level data with time, place, event type, damage, injuries, and fatalities. | change, space, rank, outliers, composition |

## Suggested Cleaned Shapes

### CDC PLACES County Health Indicators

Proposed unit: one county by measure by year.

Key variables:

- `year`
- `state`
- `state_name`
- `county_name`
- `county_fips`
- `measure`
- `estimate`
- `low_confidence_limit`
- `high_confidence_limit`
- `population`

Possible filtered measures:

- current smoking
- obesity
- diabetes
- high blood pressure
- physical inactivity
- mental health not good for 14+ days

### Census ACS State Social/Economic Indicators

Proposed unit: one state by year.

Key variables:

- `year`
- `state`
- `state_name`
- `total_population`
- `median_household_income`
- `poverty_percent`
- `uninsured_percent`
- `bachelors_or_higher_percent`
- `unemployment_percent`

This should be downloaded through the Census API and kept small.

### EPA AirData Annual AQI By County

Proposed unit: one county by year.

Key variables:

- `year`
- `state`
- `county`
- `county_fips`
- `days_with_aqi`
- `good_days`
- `moderate_days`
- `unhealthy_for_sensitive_groups_days`
- `unhealthy_days`
- `very_unhealthy_days`
- `hazardous_days`
- `median_aqi`
- `max_aqi`

This is useful for county-level rank plots and environmental health examples.

### World Bank Health/Development Indicators

Proposed unit: one country by year.

Possible indicators:

- life expectancy
- infant mortality
- GDP per capita
- population
- current health expenditure per capita
- urban population percent
- CO2 emissions per capita

This can be cleaned into both long and wide versions.

### NOAA Storm Events

Proposed unit: one weather event.

Key variables:

- `year`
- `month`
- `state`
- `event_type`
- `begin_date_time`
- `end_date_time`
- `injuries_direct`
- `deaths_direct`
- `damage_property`
- `damage_crops`
- `begin_lat`
- `begin_lon`

This is useful for event-type composition, extreme values, and spatial/event mapping.

## Build Plan

Add a new script after choosing final sources:

```text
scripts/download-additional-public-data.R
```

The script should:

- download only the columns and years needed for teaching
- write small cleaned CSVs to `data/real/`
- write matching codebooks to `data/codebooks/`
- avoid requiring API keys when possible
- keep raw large downloads out of the repository unless necessary
