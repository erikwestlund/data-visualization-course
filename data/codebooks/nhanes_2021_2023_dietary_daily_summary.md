# NHANES 2021-2023 Dietary Daily Summary

Source: derived from `DR1IFF_L.xpt` and `DR2IFF_L.xpt` by summing selected individual food records.

Unit of observation: one participant dietary recall day.

Teaching use: aggregation from item-level data, daily nutrient totals, day-to-day comparisons, and joins to demographics or health outcomes.

Important caution: these totals are derived from the individual foods files, not from the official NHANES Total Nutrient Intakes files. They are intended for teaching aggregation and exploratory visualization.

## Variables

- `respondent_id`: NHANES respondent sequence number (`SEQN`).
- `dietary_day`: recall day, `1` or `2`.
- `dietary_day1_weight`, `dietary_2day_weight`: dietary sample weights.
- `recall_status`: dietary recall status.
- `breastfed_infant_either_day`: whether the participant was a breast-fed infant on either recall day.
- `intake_days_available`: number of dietary recall days available.
- `intake_weekday`: weekday for the dietary intake day.
- `n_food_records`: number of reported food/beverage records for that day.
- `n_eating_occasions`: number of distinct eating occasion labels that day.
- `total_grams`: total grams summed across food records.
- `energy_kcal`, `protein_g`, `carbohydrate_g`, `total_sugars_g`, `dietary_fiber_g`, `total_fat_g`, `saturated_fat_g`, `cholesterol_mg`, `sodium_mg`, `potassium_mg`, `caffeine_mg`, `alcohol_g`: selected daily totals.
- `sugars_g_per_1000_kcal`: total sugars per 1,000 kcal when energy is greater than zero.
- `sodium_mg_per_1000_kcal`: sodium per 1,000 kcal when energy is greater than zero.
