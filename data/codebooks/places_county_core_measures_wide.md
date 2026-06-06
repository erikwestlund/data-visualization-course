# PLACES County Core Measures Wide

Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.

Unit of observation: one county row with selected 2023 PLACES measures in separate columns.

Important caution: this file is derived by population-weighting census tract estimates within each county. It is designed for teaching and exploratory visualization. It should not be described as the official county PLACES release.

Kentucky and Pennsylvania are absent from the source tract file for the selected 2023 measures used here.

## Variables

- `year`: source data year.
- `state`: state abbreviation.
- `state_name`: state name.
- `county_fips`: county FIPS code.
- `county_name`: county name.
- `tract_count`: number of census tracts contributing to the county summary.
- `total_population`: sum of tract total population values within the county.
- `total_adult_population`: sum of tract adult population values within the county.
- `current_smoking`: percent of adults who currently smoke cigarettes.
- `diabetes`: percent of adults with diagnosed diabetes.
- `frequent_mental_distress`: percent of adults reporting frequent mental distress.
- `high_blood_pressure`: percent of adults with high blood pressure.
- `lack_health_insurance`: percent of adults aged 18-64 years who currently lack health insurance.
- `obesity`: percent of adults with obesity.
- `physical_inactivity`: percent of adults reporting no leisure-time physical activity.
