# PLACES Tract DC/MD/VA Core Measures Long

Source: CDC PLACES, Local Data for Better Health, Census Tract Data, 2025 release.

Unit of observation: one census tract-measure row for selected 2023 PLACES measures in DC, Maryland, and Virginia.

This file is a small regional subset of the original tract-level source. It is intended for teaching tract-level spatial comparison, rank, and local variation without bundling the 828 MB raw file.

## Variables

- `year`: source data year.
- `state`: state abbreviation.
- `state_name`: state name.
- `county_name`: county name.
- `county_fips`: county FIPS code.
- `tract_fips`: census tract FIPS code.
- `location_id`: PLACES location identifier.
- `measure_id`: CDC PLACES measure identifier.
- `measure_key`: short analysis-friendly measure name.
- `measure`: readable measure label.
- `estimate`: tract-level estimate, in percent.
- `ci_lower`: lower confidence limit, in percent.
- `ci_upper`: upper confidence limit, in percent.
- `total_population`: tract total population.
- `total_adult_population`: tract adult population.
- `longitude`: tract longitude from source geolocation.
- `latitude`: tract latitude from source geolocation.
