# PLACES County Core Measures Long

Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.

Unit of observation: one county-measure row for selected 2023 PLACES tract measures aggregated to county level.

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
- `measure_id`: CDC PLACES measure identifier.
- `measure_key`: short analysis-friendly measure name.
- `measure`: readable measure label.
- `estimate`: population-weighted county estimate, in percent.
- `ci_lower`: population-weighted lower confidence limit, in percent.
- `ci_upper`: population-weighted upper confidence limit, in percent.

## Included Measures

- `current_smoking`: current cigarette smoking among adults.
- `diabetes`: diagnosed diabetes among adults.
- `frequent_mental_distress`: frequent mental distress among adults.
- `high_blood_pressure`: high blood pressure among adults.
- `lack_health_insurance`: current lack of health insurance among adults aged 18-64 years.
- `obesity`: obesity among adults.
- `physical_inactivity`: no leisure-time physical activity among adults.
