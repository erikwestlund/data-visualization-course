# EPA Air Quality County 2025 Wide

Source: EPA Air Quality Statistics by County, 2025 workbook. The source notes that values are based on EPA AQS monitoring data as of June 5, 2025.

Unit of observation: one county row for counties with monitoring data in the EPA workbook.

Important caution: numeric pollutant columns are missing when the source value was `ND` (no data) or `IN` (insufficient data). Use the matching `_status` columns to distinguish these cases.

## Identifier Variables

- `year`: factbook year, set to 2025.
- `state`: state abbreviation, including `DC` and `PR` where present.
- `state_name`: state or territory name.
- `county_fips`: county FIPS code.
- `county_name`: county name from the EPA workbook.
- `population_2020`: county population from the 2020 Census column in the workbook.

## Numeric Metric Variables

- `co_8hr_ppm`: CO second maximum non-overlapping 8-hour concentration, ppm.
- `lead_3mo_ug_m3`: lead maximum rolling 3-month average concentration, ug/m3.
- `no2_annual_mean_ppb`: NO2 annual arithmetic mean concentration, ppb.
- `no2_1hr_ppb`: NO2 98th percentile daily maximum 1-hour concentration, ppb.
- `ozone_8hr_ppb`: ozone fourth highest daily maximum 8-hour concentration, ppb.
- `pm10_24hr_ug_m3`: PM10 second maximum 24-hour concentration, ug/m3.
- `pm25_annual_mean_ug_m3`: PM2.5 weighted annual mean concentration, ug/m3.
- `pm25_24hr_ug_m3`: PM2.5 98th percentile 24-hour concentration, ug/m3.
- `so2_1hr_ppb`: SO2 99th percentile daily maximum 1-hour concentration, ppb.
- `so2_annual_mean_ppb`: SO2 weighted annual mean concentration, ppb.

## Status Variables

Each numeric metric has a matching `_status` column with values `reported`, `no_data`, `insufficient_data`, or `missing`.
