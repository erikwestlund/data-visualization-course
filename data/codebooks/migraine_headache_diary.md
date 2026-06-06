# Migraine Headache Diary

Source: John Fox Applied Regression data archive, `Migraines.txt`.

Source page: <https://www.john-fox.ca/AppliedRegression/datasets/index.html>

Source description: data on migraine headaches from Kostecki-Dillon, Monette, and Wong.

Unit of observation: one person-day headache diary record.

Teaching use: repeated observations, categorical outcomes, time trends, grouped summaries, and individual trajectories.

Important caution: people contribute different numbers of diary days, and some day values are negative because the source time scale includes observations before the reference day used in the study.

## Variables

- `participant_id`: person identifier from the source file.
- `day`: study day on the source time scale.
- `medication`: medication condition recorded in the source data: `continuing`, `reduced`, or `none`.
- `headache`: whether a headache was reported on that diary day: `yes` or `no`.
- `headache_reported`: logical version of `headache`, useful for calculating proportions.
