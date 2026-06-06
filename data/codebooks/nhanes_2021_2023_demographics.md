# NHANES 2021-2023 Demographics

Source: CDC/NCHS NHANES August 2021-August 2023 `DEMO_L.xpt`.

Documentation: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm>

Unit of observation: one NHANES participant.

Teaching use: demographic grouping, missingness, age distributions, race/ethnicity composition, education, income-to-poverty, and joins to examination/laboratory/dietary files.

Important caution: NHANES is a complex survey. The cleaned files include weights and design variables, but simple unweighted classroom graphics should be described as exploratory sample visualizations, not national estimates.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `release_cycle`: data release cycle; `12` is August 2021-August 2023.
- `interview_exam_status`: interviewed only or interviewed and MEC examined.
- `gender`: `male` or `female`, following the public NHANES variable label.
- `age_years`: age in years at screening; people age 80 or older are top-coded as `80`.
- `age_months_screening_0_to_24`: age in months for young children when available.
- `age_group`: generated age group for teaching graphics.
- `race_ethnicity`: NHANES race/Hispanic origin with Non-Hispanic Asian category.
- `exam_period`: six-month exam period when available.
- `born_in_us`: whether the participant was born in the 50 states or Washington, DC.
- `years_in_us_category`: years in the U.S. for participants born elsewhere.
- `education_adults_20_plus`: highest education level for adults age 20+.
- `marital_status_adults_20_plus`: marital status for adults age 20+.
- `pregnancy_status_exam`: pregnancy status for eligible examined females age 20-44.
- `household_size`: household size; `7` means seven or more people.
- `family_income_to_poverty`: family income-to-poverty ratio; values at or above 5 are top-coded as 5.
- `interview_weight`: full sample 2-year interview weight.
- `mec_exam_weight`: full sample 2-year MEC exam weight.
- `masked_variance_stratum`: masked variance pseudo-stratum.
- `masked_variance_psu`: masked variance pseudo-PSU.
