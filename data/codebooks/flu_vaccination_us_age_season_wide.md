# Flu Vaccination US Age Season Wide

Unit of observation: one United States flu-season row with separate age-group columns

## Variables

- `season`: CDC flu season label
- `season_start_year`: first year of the flu season
- `mean_estimate_6_months_4_years`: mean monthly vaccination coverage estimate for ages 6 months to 4 years
- `mean_estimate_5_12_years`: mean monthly vaccination coverage estimate for ages 5 to 12 years
- `mean_estimate_13_17_years`: mean monthly vaccination coverage estimate for ages 13 to 17 years
- `mean_estimate_18_49_years`: mean monthly vaccination coverage estimate for ages 18 to 49 years
- `mean_estimate_50_64_years`: mean monthly vaccination coverage estimate for ages 50 to 64 years
- `mean_estimate_ge_65_years`: mean monthly vaccination coverage estimate for ages 65 years and older

## Notes

- Derived from CDC public influenza vaccination coverage data.
- Mean estimate columns average the available monthly estimates within each season.
- This file is designed for simple time-trend plots by age group.
