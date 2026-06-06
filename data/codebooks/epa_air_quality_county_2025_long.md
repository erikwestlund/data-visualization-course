# EPA Air Quality County 2025 Long

Source: EPA Air Quality Statistics by County, 2025 workbook. The source notes that values are based on EPA AQS monitoring data as of June 5, 2025.

Unit of observation: one county-pollutant-statistic row for counties with monitoring data in the EPA workbook.

Important caution: counties without monitoring data for a pollutant/statistic are marked as `no_data`; counties with insufficient data are marked as `insufficient_data`. This dataset describes monitored county summaries, not all possible air quality exposure variation within counties.

## Variables

- `year`: factbook year, set to 2025.
- `state`: state abbreviation, including `DC` and `PR` where present.
- `state_name`: state or territory name.
- `county_fips`: county FIPS code.
- `county_name`: county name from the EPA workbook.
- `population_2020`: county population from the 2020 Census column in the workbook.
- `pollutant`: pollutant name, such as `Ozone`, `PM2.5`, or `NO2`.
- `statistic`: statistic used for the pollutant, such as `8-hour`, `24-hour`, or `weighted annual mean`.
- `unit`: measurement unit.
- `metric_key`: analysis-friendly metric name.
- `value`: numeric reported value; missing when status is not `reported`.
- `status`: `reported`, `no_data`, `insufficient_data`, or `missing`.
- `naaqs_standard`: applicable National Ambient Air Quality Standards value listed in the source workbook notes.
- `value_as_fraction_of_standard`: value divided by `naaqs_standard`.
- `exceeds_standard`: whether the reported value exceeds the listed standard.
