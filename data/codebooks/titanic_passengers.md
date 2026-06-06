# Titanic Passengers

Source: John Fox Applied Regression data archive, `Titanic.txt`.

Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>

Source description: survival of passengers on the Titanic. The archive notes that this version includes passengers, not crew, and has exact age for about half of the passengers.

Unit of observation: one Titanic passenger.

Teaching use: categorical comparisons, missing age, composition, proportions, and grouped survival summaries.

## Variables

- `passenger_name`: passenger name from the source row label.
- `survived`: whether the passenger survived, `yes` or `no`.
- `age_years`: age in years; missing when exact age is unavailable.
- `passenger_class`: passenger class, `1st`, `2nd`, or `3rd`.
- `sex`: passenger sex, `female` or `male`.
- `survived_logical`: logical version of `survived`, useful for calculating proportions.
- `missing_age`: whether `age_years` is missing.
