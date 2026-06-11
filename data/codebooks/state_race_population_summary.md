# State Race Population Summary Codebook

File: `data/real/state_race_population_summary.csv`

Source: Derived from Census state race/ethnicity long data and corrected Census 2020 state population ranks.

Rows: 51

Columns: 11

## Unit Of Observation

Each row is one state or District of Columbia.

## Variables

- `state`: State abbreviation.
- `state_name`: Full state name.
- `rank`: State population rank.
- `total_population`: Total state population.
- `share_american_indian_and_alaska_native`: Share of included race/ethnicity population.
- `share_asian`: Share of included race/ethnicity population.
- `share_black`: Share of included race/ethnicity population.
- `share_hispanic_or_latino`: Share of included race/ethnicity population.
- `share_native_hawaiian_and_other_pacific_islander`: Share of included race/ethnicity population.
- `share_other`: Share of included race/ethnicity population.
- `share_white`: Share of included race/ethnicity population.

## Teaching Notes

- This wide file is useful for quick state-level composition plots and map/dot-plot alternatives.
- For most composition teaching, the long file is easier to use.
- Shares are based on the included race/ethnicity categories from the source file.
