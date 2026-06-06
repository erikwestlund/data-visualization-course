# PRAMS 2011 Selected Data Codebook

File: `data/real/prams_2011_selected.csv`

Source: CDC PRAMStat 2011 public data, processed from the previous course materials.

Rows: 1,222

Columns: 8

## Unit Of Observation

Each row is a pre-aggregated percentage for one location, subgroup category, and subgroup.

This is not person-level data. Values are percentages reported by PRAMS for specific state/subgroup combinations.

## Variables

- `location_abbr`: State or location abbreviation.
- `location`: Full state or location name.
- `subgroup_cat`: Subgroup category, such as maternal age, marital status, income, or number of previous live births.
- `subgroup`: Specific subgroup within `subgroup_cat`.
- `depression_within_3_months_birth`: Percent reporting depression in the 3 months before birth.
- `anxiety_within_3_months_birth`: Percent reporting anxiety in the 3 months before birth.
- `binge_drinking_within_3_months_birth`: Percent reporting binge drinking in the 3 months before birth.
- `alcohol_use_within_3_months_birth`: Percent reporting any alcohol use in the 3 months before birth.

## Teaching Notes

- This dataset is good for grouped bar charts, facets, rank, missingness, and interpretation of pre-aggregated data.
- Depression and anxiety measures have substantial missingness.
- Students should always state the subgroup and location structure when interpreting a plot.
