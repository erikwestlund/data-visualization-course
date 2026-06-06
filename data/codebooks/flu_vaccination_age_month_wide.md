# Flu Vaccination Age Month Wide

Unit of observation: one geography-season-month row with separate age-group estimate columns

## Variables

- `season`: CDC flu season label
- `season_start_year`: first year of the flu season
- `month`: month number
- `geography`: United States or HHS region
- `estimate_6_months_4_years`: vaccination coverage estimate for ages 6 months to 4 years
- `estimate_5_12_years`: vaccination coverage estimate for ages 5 to 12 years
- `estimate_13_17_years`: vaccination coverage estimate for ages 13 to 17 years
- `estimate_18_49_years`: vaccination coverage estimate for ages 18 to 49 years
- `estimate_50_64_years`: vaccination coverage estimate for ages 50 to 64 years
- `estimate_ge_65_years`: vaccination coverage estimate for ages 65 years and older

## Notes

- Derived from CDC public influenza vaccination coverage data.
- Confidence interval and sample-size columns use the same age-group suffixes as estimate columns.
- Rows include United States and HHS region geographies.
