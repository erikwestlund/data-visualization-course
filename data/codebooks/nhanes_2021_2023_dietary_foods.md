# NHANES 2021-2023 Dietary Foods

Source: CDC/NCHS NHANES August 2021-August 2023 `DR1IFF_L.xpt` and `DR2IFF_L.xpt`.

Documentation Day 1: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR1IFF_L.htm>

Documentation Day 2: <https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR2IFF_L.htm>

Unit of observation: one reported food or beverage item for one participant on one dietary recall day.

Teaching use: long data, grouping, aggregation, food sources, eating occasions, nutrients, and repeated day comparisons.

Important caution: this file does not include food descriptions because the separate FNDDS food-code description file was not provided in this processing step. Use `usda_food_code` as an identifier unless descriptions are added later.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `dietary_day`: recall day, `1` or `2`.
- `dietary_day1_weight`: Day 1 dietary sample weight.
- `dietary_2day_weight`: two-day dietary sample weight.
- `food_line`: food/individual component number within respondent and day.
- `recall_status`: dietary recall status, simplified from NHANES codes.
- `breastfed_infant_either_day`: whether the participant was a breast-fed infant on either recall day.
- `intake_days_available`: number of dietary recall days available.
- `days_between_intake_and_household_interview`: days between intake day and household interview.
- `intake_weekday`: weekday for the dietary intake day.
- `interview_language`: language used mostly in the interview.
- `combination_food_number`: identifier for foods eaten as part of a combination.
- `combination_food_type`: combination-food type label.
- `eating_time`: reported eating occasion time.
- `eating_occasion`: reported eating occasion label.
- `food_source_code`: original NHANES food source code.
- `food_source`: detailed food source label.
- `food_source_group`: generated broader food source group.
- `eaten_at_home`: whether the meal/snack was eaten at home.
- `usda_food_code`: USDA FNDDS food code.
- `grams`: amount consumed in grams.
- `energy_kcal`: energy in kilocalories.
- `protein_g`, `carbohydrate_g`, `total_sugars_g`, `dietary_fiber_g`, `total_fat_g`, `saturated_fat_g`: selected nutrients in grams.
- `cholesterol_mg`, `sodium_mg`, `potassium_mg`, `caffeine_mg`: selected nutrients/components in milligrams.
- `alcohol_g`: alcohol in grams.
