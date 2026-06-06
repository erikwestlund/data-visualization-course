# Real Data Integration Plan

Assessment of datasets from the old course directory: `/Users/erik/Code/Courses/data-viz-summer-25/data`.

The main recommendation is to use real public datasets for student assignments whenever possible, while creating simulated lesson datasets or cleaned derivatives with similar shape when we need lower-friction teaching examples.

## Inventory Of Existing Old-Course Data

### 1. PRAMS Processed Data

File: `data/processed/cdc_prams_df_final.rds`

Source: CDC PRAMStat 2011 public data.

Rows: 1,222

Columns: 8

Unit: location by subgroup category by subgroup.

Variables:

- `location_abbr`
- `subgroup_cat`
- `subgroup`
- `depression_within_3_months_birth`
- `anxiety_within_3_months_birth`
- `binge_drinking_within_3_months_birth`
- `alcohol_use_within_3_months_birth`
- `location`

Important data features:

- Real public health data.
- Already cleaned into a compact analysis shape.
- Substantial missingness for depression/anxiety measures.
- Pre-aggregated percentages, not person-level observations.
- Strong teaching value for explaining row meaning, subgroup structure, missingness, and `geom_col()` / `stat = "identity"`.

Existing course materials built around it:

- `examples/prams_1_data_prep.qmd`: raw PRAMS cleaning workflow, filtering, renaming, pivoting, missingness diagnostics, and RDS export.
- `examples/prams_2_ggplot_concepts.qmd`: explicit `ggplot2` workflow using PRAMS, including data, aesthetics, geoms, coordinates, scales, labels, themes, and annotation.
- `examples/prams_3_iteration_aggregation.qmd`: iteration, faceting, aggregation, transformation, and small multiples.

Best use in new course:

- Strong lesson/reference dataset for grammar of graphics and grouped categorical/continuous summaries.
- Strong assignment dataset if we provide the processed RDS as CSV or convert it to a student-friendly CSV.
- Good for real-data homework focused on interpreting pre-aggregated data and missingness.

Limitations:

- Not person-level.
- Missingness is real and useful but can overwhelm beginners.
- Raw source file referenced in old prep notebook is not present in the old repo data folder; only the processed RDS is present.

Recommended action:

- Convert `cdc_prams_df_final.rds` to `data/real/prams_2011_selected.csv` for student use.
- Keep a codebook note explaining that rows are pre-aggregated percentages by state/subgroup.
- Create a simulated lookalike for lessons if we want a cleaner first pass before using real PRAMS.

### 2. CDC Influenza Vaccination Coverage Data

File: `data/raw/cdc_Influenza_Vaccination_Coverage_for_All_Ages__6__Months__20250610.csv`

Source: CDC flu vaccination coverage public data.

Rows: 220,729

Columns: 11

Unit: geography by season/year/month by dimension/dimension type.

Variables:

- `Vaccine`
- `Geography Type`
- `Geography`
- `FIPS`
- `Season/Survey Year`
- `Month`
- `Dimension Type`
- `Dimension`
- `Estimate (%)`
- `95% CI (%)`
- `Sample Size`

Important data features:

- Real public data.
- Large enough to require filtering and thoughtful data preparation.
- Has time, geography, categorical dimensions, estimates, confidence intervals, and sample sizes.
- Estimate and confidence interval fields need parsing.
- Age groups and dimension types are not all mutually exclusive.

Existing course materials built around it:

- `examples/ai_llm_illustration.qmd`: uses an LLM-assisted workflow to inspect, clean, parse confidence intervals, select age groups, summarize estimates, and create a time-series plot.

Best use in new course:

- Excellent real-data assignment dataset for change/time-series, categorical filtering, and communication.
- Good for a responsible LLM/data-wrangling sidebar if we still want one.
- Good for assignments because students can answer many questions without private data.

Limitations:

- Too large and irregular for Day 1.
- Needs a cleaned assignment-ready version or a notebook scaffold.
- The overlapping age/dimension categories can confuse students without guidance.

Recommended action:

- Create a cleaned assignment file such as `data/real/flu_vaccination_age_time_clean.csv`.
- Include parsed variables: `estimate`, `ci_lower`, `ci_upper`, `season`, `age_group`, `geography`, `geography_type`, `sample_size`.
- Provide a homework prompt asking students to visualize change over time by age group or geography.
- Create a simulated time-series cousin for lesson use if the real data feels too messy for first exposure.

### 3. Census Race By State Data

File: `data/raw/race_by_state_census2020.csv`

Source: Census 2020 race/ethnicity by state.

Rows: 7

Columns: 53

Unit: race/ethnicity category by state, in wide format.

Variables:

- `Label`
- one column per state plus Puerto Rico

Important data features:

- Real public data.
- Starts in a very wide format, which is useful for teaching pivoting.
- Supports composition, rank, and spatial/state comparisons after cleaning.

Existing course materials built around it:
- `examples/dag_sim_data.qmd`: pivots it longer/wider, converts counts, calculates race/ethnicity shares, and joins state population/rank data.
- Output derivative: `data/processed/state_data.csv`.

Best use in new course:

- Useful for categorical composition and rank.
- Useful as a real-data homework source if cleaned into long format.
- Useful support data for simulated state-level datasets.

Limitations:

- Too small by itself for many EDA tasks.
- Wide source format is a feature for data prep but a distraction for early visualization.

Recommended action:

- Create `data/real/census_state_race_ethnicity_long.csv` with columns like `state`, `state_name`, `race_ethnicity`, `population`, `share`.
- Use for composition/rank homework or as support data for space examples.

### 4. Census State Population Ranks

File: `data/raw/states_census2020_ranks.csv`

Rows: 51

Columns: 4

Unit: state.

Variables:

- `state`
- `state_name`
- `population`
- `rank`

Important data features:

- Real public data.
- Clean and small.
- Supports rank and state-level joins.

Existing course materials built around it:

- `examples/dag_sim_data.qmd`: creates `state_weight` and a synthetic `pec` score.
- Output derivative: `data/processed/state_data.csv`.

Best use in new course:

- Support file for assignments with state-level data.
- Good for rank examples.
- Good for explaining joins and denominators.

Limitations:

- Too simple alone for a full assignment.

Recommended action:

- Bundle with Census race/ethnicity or state health indicators.

### 5. Processed State Data

File: `data/processed/state_data.csv`

Rows: 51

Columns: 11

Unit: state.

Variables:

- `state_name`
- `hispanic`
- `white`
- `black`
- `aian`
- `asian`
- `nhpi`
- `other`
- `state`
- `state_weight`
- `pec`

Important data features:

- Derived from real Census/state rank data.
- Contains racial/ethnic composition shares and a synthetic state condition score.
- Useful as a support file for simulations and spatial examples.

Existing course materials built around it:

- Used by `dag_sim_data.qmd` to simulate individual-level maternal health data.
- Used by `applications_2_choropleths_for_spatial_data.qmd` and `applications_3_dot_plot_for_spatial_data.qmd` with `simulated_data.csv`.

Best use in new course:

- Keep as support data, not primary assignment data.
- Use for composition, rank, and map alternatives.

Limitations:

- Includes a synthetic `pec` field, so it is not purely real.

Recommended action:

- Treat as a derived teaching file and document provenance clearly.

### 6. Simulated Maternal Health / DAG Data

Files:

- `data/processed/simulated_data.csv`
- `data/processed/simulated_maternal_health_data.csv`

Rows: 50,000 each

Columns: 20 each

Unit: person.

Variables:

- `id`
- `provider_id`
- `state`
- `received_comprehensive_postnatal_care`
- `self_report_income`
- `age`
- `edu`
- `race_ethnicity`
- `insurance`
- `job_type`
- `dependents`
- `distance_to_provider`
- pregnancy/health risk indicators such as `obesity`, `diabetes`, `hypertension`, `preeclampsia`

Important data features:

- Public-health-ish simulated person-level data.
- Generated from a causal/DAG-inspired structure.
- Large and rich enough for categorical, continuous, association, grouped association, spatial aggregation, and dashboard examples.

Existing course materials built around it:

- `examples/dag_sim_data.qmd`: simulation source workflow.
- `examples/applications_2_choropleths_for_spatial_data.qmd`: choropleth maps.
- `examples/applications_3_dot_plot_for_spatial_data.qmd`: non-map spatial alternatives.
- `examples/applications_6_visualizing_correlations_and_models.qmd`: correlations/model outputs.
- `examples/shiny_example.R`: Shiny dashboard.

Best use in new course:

- Excellent lesson dataset because it is rich, clean, and controllable.
- Good for instructor examples, live coding, and optional dashboard/model modules.
- Less ideal for assignments if the goal is real public data, but excellent as the simulated cousin to a real maternal/PRAMS assignment.

Limitations:

- Simulated, not real.
- 50,000 rows may be more than needed for beginner exercises.
- Variables are strongly maternal-health-specific.

Recommended action:

- Create a smaller sampled version for lessons, e.g. `data/simulated/lesson_maternal_health_survey.csv` with 2,000 to 5,000 rows.
- Keep the full file as an optional advanced/reference dataset.

## Existing Course Materials By Dataset

| Dataset | Existing examples | What is already created |
|---|---|---|
| PRAMS processed RDS | `prams_1_data_prep.qmd`, `prams_2_ggplot_concepts.qmd`, `prams_3_iteration_aggregation.qmd` | cleaning workflow, missingness diagnostics, grammar of graphics, faceting, iteration, aggregation |
| CDC influenza vaccination raw CSV | `ai_llm_illustration.qmd` | LLM-assisted exploration, cleaning, CI parsing, age/time summary, time-series plot |
| Census race/state raw files | `dag_sim_data.qmd` | pivoting, state composition shares, state weights, synthetic state condition score |
| Processed state data | `dag_sim_data.qmd`, spatial application examples | support data for simulation, choropleth, dot plot alternative |
| Simulated maternal health data | `dag_sim_data.qmd`, spatial/model/Shiny examples | DAG-based simulation, maps, dot plots, model visualization, dashboard |

## Recommended Integration Strategy

### Principle

Use real public datasets for student assignments when the task is interpretive, exploratory, or communicative. Use simulated datasets for lessons when we need cleaner structure, guaranteed patterns, or lower setup friction.

### Course-Level Mix

| Module | Lesson Dataset | Student Assignment Dataset | Rationale |
|---|---|---|---|
| `01-workflow-and-basics` | small simulated or `mtcars` initially; then small maternal-health sample | small cleaned real PRAMS or flu subset | avoid Day 1 friction, but show real data quickly |
| `02_categorical-data` | simulated clinic/outreach log | real Census race/state long file or flu categorical subset | real data works well for counts, composition, rank |
| `03_continuous-data` | simulated BP/symptom measurements | PRAMS selected percentages or flu estimates/sample sizes | real public data is mostly aggregated, so supplement with simulation for true continuous distributions |
| `04_group-comparison` | simulated maternal/person-level data | PRAMS subgroup/state data | PRAMS is ideal for grouped bars, faceting, missingness, and interpretation |
| `05_association` | simulated maternal/DAG data | flu or PRAMS derived summaries; optional real county indicators later | real association data may need careful construction; simulation helps teach relationships cleanly |
| `06_change` | simulated surveillance weekly | CDC flu vaccination time series | flu data is excellent real homework for change over time |
| `07_space` | simulated state/county indicators with real state support data | Census/state data or derived flu geography subset | use real state composition/rank; add shapes/coordinates later |
| `08_flow` | simulated cascade/process data | likely simulated unless we find a suitable public real cascade | flow usually needs custom-shaped data |
| `09_communication-polish` | any previous lesson data | real PRAMS or flu assignment output | best final polish work should use real data |

## Assignment Dataset Recommendations

### Best Real Assignment Candidates

1. CDC flu vaccination data, cleaned and subsetted.
2. PRAMS processed selected data, converted to CSV.
3. Census state race/ethnicity data, cleaned to long format.
4. State population/rank data joined to race/ethnicity data.

### Best Simulated Lesson Candidates

1. Smaller sample of existing maternal health simulated data.
2. Simulated categorical clinic/outreach logs.
3. Simulated continuous measurement data.
4. Simulated flow/cascade data.

## Concrete Files To Create In This Repo

### Real Data

```text
data/real/prams_2011_selected.csv
data/real/flu_vaccination_age_time_clean.csv
data/real/census_state_race_ethnicity_long.csv
data/real/state_population_ranks.csv
data/real/state_race_population_summary.csv
```

### Simulated Cousins / Lesson Files

```text
data/simulated/lesson_maternal_health_survey.csv
data/simulated/lesson_clinic_outreach_log.csv
data/simulated/lesson_bp_screening.csv
data/simulated/lesson_surveillance_weekly.csv
data/simulated/lesson_care_cascade.csv
```

### Codebooks

```text
data/codebooks/prams_2011_selected.md
data/codebooks/flu_vaccination_age_time_clean.md
data/codebooks/census_state_race_ethnicity_long.md
data/codebooks/lesson_maternal_health_survey.md
```

### Scripts

```text
scripts/prepare-real-data.R
scripts/simulate-lesson-data.R
```

## Recommended Next Step

Build `scripts/prepare-real-data.R` first. It should copy/derive cleaned CSVs from the old course data into this repo:

- Convert PRAMS RDS to CSV.
- Clean and subset CDC flu vaccination data for age/time assignments.
- Pivot Census race/state data into long format.
- Copy state population ranks.

Then build simulated cousins around the cleaned real datasets, so lesson examples and homework assignments have parallel structure.
