# NHANES 2021-2023 Joined Analysis File

Source: joined teaching file derived from selected NHANES demographics, blood pressure, hepatitis A, and dietary summaries.

Unit of observation: one NHANES participant from the demographics file.

Teaching use: low-friction person-level exploratory visualization across demographics, dietary summaries, blood pressure, and hepatitis A antibody status.

Important caution: this file is simplified for teaching. NHANES is a complex survey; use appropriate survey methods and weights for national estimates. The generated blood-pressure category is a simplified adult teaching variable and should not be used as a clinical diagnosis.

## Variables

This file includes the variables from:

- `nhanes_2021_2023_demographics.csv`
- `nhanes_2021_2023_blood_pressure.csv`
- `nhanes_2021_2023_hepatitis_a.csv`
- `nhanes_2021_2023_dietary_person_summary.csv`

Additional generated variables:

- `adult_high_bp_range`: for adults age 18+, whether mean systolic is at least 130 or mean diastolic is at least 80; missing for children and missing BP readings.
- `adult_bp_category_simplified`: simplified adult BP range category for teaching: `normal_range`, `elevated_range`, `stage_1_range`, or `stage_2_range`.
