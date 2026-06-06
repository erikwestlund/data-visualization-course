# Census State Race Ethnicity Wide

Unit of observation: one state row with separate race/ethnicity population and share columns

## Variables

- `state`: state abbreviation
- `state_name`: state name
- `rank`: state population rank from the Census population file
- `total_population`: total state population
- `state_population_weight`: state population divided by total population across included states
- `share_white`: share of race/ethnicity population total categorized as White
- `share_black`: share of race/ethnicity population total categorized as Black
- `share_hispanic_or_latino`: share of race/ethnicity population total categorized as Hispanic or Latino
- `share_asian`: share of race/ethnicity population total categorized as Asian

## Notes

- Derived from public 2020 Census race/ethnicity and state population files.
- Population and share columns are wide versions of census_state_race_ethnicity_long.csv.
- The race/ethnicity categories follow the source file and should not be treated as exhaustive person-level classifications.
