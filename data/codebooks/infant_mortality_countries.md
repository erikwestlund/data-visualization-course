# Infant Mortality Countries

Source: John Fox Applied Regression data archive, `Leinhardt.txt`.

Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>

Source description: Leinhardt and Wasserman's data on infant mortality.

Original sources listed by the archive: Leinhardt and Wasserman (1979), and The New York Times, 28 September 1975, p. E-3, Table 3.

Unit of observation: one country.

Teaching use: association between income and infant mortality, grouped comparisons by region, outliers, transformations, and label-aware scatterplots.

## Variables

- `country_name`: country name from the source row label.
- `income_usd_per_capita`: per-capita income in U.S. dollars.
- `infant_mortality_per_1000`: infant mortality rate per 1,000 live births.
- `region`: world region: `Africa`, `Americas`, `Asia`, or `Europe`.
- `oil_exporting_country`: source oil-exporting indicator, `yes` or `no`.
- `oil_exporter`: logical version of `oil_exporting_country`.
