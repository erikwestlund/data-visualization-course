# NHANES 2021-2023 Hepatitis A

Source: CDC/NCHS NHANES August 2021-August 2023 `HEPA_L.xpt`.

Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/HEPA_L.htm>

Unit of observation: one NHANES participant eligible for hepatitis A antibody testing, age 2+.

Teaching use: categorical laboratory outcome, proportions, age gradients, and joins to demographics.

Important caution: total anti-HAV positivity indicates past or present infection or vaccination; this test cannot distinguish natural infection from vaccination.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `phlebotomy_weight`: phlebotomy 2-year weight.
- `hepatitis_a_antibody`: `positive`, `negative`, or `indeterminate`.
- `hepatitis_a_antibody_positive`: logical positive/negative version; indeterminate and missing results are missing.
