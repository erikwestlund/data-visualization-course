# Census State Race/Ethnicity Long Data Codebook

File: `data/real/census_state_race_ethnicity_long.csv`

Source: Census 2020 state race/ethnicity counts from previous course materials, joined with corrected Census 2020 state population ranks.

Rows: 357

Columns: 8

## Unit Of Observation

Each row is one race/ethnicity category within one state.

## Variables

- `state`: State abbreviation.
- `state_name`: Full state name.
- `rank`: State population rank from the state population file.
- `total_population`: Total state population from the state population file.
- `race_ethnicity`: Race/ethnicity category.
- `race_ethnicity_population`: Count for the race/ethnicity category in the state.
- `total_race_ethnicity_population`: Sum of included race/ethnicity counts for the state.
- `share`: Race/ethnicity category share of `total_race_ethnicity_population`.

## Teaching Notes

- This dataset is good for composition, proportions, rank, and state comparisons.
- The `share` denominator is the sum of the included race/ethnicity categories in this file.
- This is useful for showing how denominator choices affect interpretation.
