# NHANES 2021-2023 Dietary Person Summary

Source: derived from `nhanes_2021_2023_dietary_daily_summary.csv`.

Unit of observation: one participant with at least one dietary food record.

Teaching use: person-level dietary features for joining to demographics, blood pressure, or hepatitis A results.

Important caution: these are simple averages over available recall days and are intended for exploratory teaching examples, not formal usual-intake estimation.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `dietary_days`: number of recall days represented in the individual foods files.
- `mean_daily_*`: simple mean of selected daily totals over available recall days.
- `day1_energy_kcal`, `day2_energy_kcal`: recall-day-specific energy totals.
- `day1_total_sugars_g`, `day2_total_sugars_g`: recall-day-specific sugar totals.
- `day1_sodium_mg`, `day2_sodium_mg`: recall-day-specific sodium totals.
