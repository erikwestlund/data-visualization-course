# Flu Vaccination Age-Time Data Codebook

File: `data/real/flu_vaccination_age_time_clean.csv`

Source: CDC Influenza Vaccination Coverage for All Ages 6+ Months public data.

Rows: 9,811

Columns: 11

## Unit Of Observation

Each row is a flu vaccination coverage estimate for one season, month, geography, and mutually exclusive age group.

The data are filtered to seasonal influenza, HHS regions/national geography, and age groups that are easier to compare.

## Variables

- `season`: Season or survey year label from the CDC data.
- `season_start_year`: First year in the season label, parsed as an integer.
- `month`: Month number.
- `geography_type`: Geography type. This cleaned file keeps HHS regions/national rows.
- `geography`: HHS region or United States.
- `fips`: Geographic identifier when available.
- `age_group`: Mutually exclusive age group.
- `estimate`: Vaccination coverage estimate, in percent.
- `ci_lower`: Lower bound of the 95% confidence interval, in percent.
- `ci_upper`: Upper bound of the 95% confidence interval, in percent.
- `sample_size`: Sample size for the estimate when available.

## Teaching Notes

- This dataset is good for line charts, small multiples, change over time, uncertainty, and age-group comparisons.
- The original CDC file contains many overlapping age and dimension categories. This cleaned file keeps a smaller set of mutually exclusive age groups.
- Students should be careful about comparing months, seasons, and geographies.
