# Davis Height Weight

Source: John Fox Applied Regression data archive, `Davis.txt`.

Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>

Source description: Davis's data on height and weight of exercisers.

Unit of observation: one person.

Teaching use: simple individual-level data for scatterplots, distributions, missing reported values, outliers, and self-reporting error.

Important caution: one row has implausible measured height and weight values that appear to be swapped in the source data. The row is preserved and flagged instead of corrected so it can be used for teaching outlier checks.

## Variables

- `participant_id`: row identifier from the source file.
- `sex`: `female` or `male`.
- `weight_kg`: measured body weight in kilograms.
- `height_cm`: measured height in centimeters.
- `reported_weight_kg`: self-reported body weight in kilograms; missing when not reported.
- `reported_height_cm`: self-reported height in centimeters; missing when not reported.
- `measured_bmi`: BMI computed from measured weight and height.
- `reported_bmi`: BMI computed from reported weight and height; missing if reported weight or height is missing.
- `weight_reporting_error_kg`: reported weight minus measured weight.
- `height_reporting_error_cm`: reported height minus measured height.
- `missing_reported_weight`: whether reported weight is missing.
- `missing_reported_height`: whether reported height is missing.
- `likely_swapped_measured_values`: whether measured weight is above 120 kg and measured height is below 100 cm, flagging the implausible source row.
