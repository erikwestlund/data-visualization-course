# Day 2 Schedule: Data Preparation And Categorical Data

Assumed class block: 3 hours.

## Main Goal

Students can inspect a dataset, use common data-preparation functions one at a time, and make categorical plots that reveal counts, summaries, composition, rank, and proportion. The day should prioritize practice time and mechanical confidence over covering more plot types.

## Schedule

| Time | Segment | Materials | Notes |
|---:|---|---|---|
| 0:00-0:10 | Day 1 debrief and technical fixes | Verbal, `source("updater.R")` if needed | Resolve blockers before content. |
| 0:10-0:20 | Data cleaning concepts | `slides/day-02-data-preparation-and-categorical.qmd` | Observation, `glimpse()`, `head()`, object naming, and common `dplyr` functions. |
| 0:20-0:50 | Data cleaning module | `modules/02_data-preparation/01_data-preparation.qmd` | Load NHANES data and use each common data-preparation function before plotting. |
| 0:50-1:20 | Data cleaning practice | `practice/02-one-variable-and-distributions/01_data-cleaning-practice.qmd` | Students run working chunks, change one part, and explain the output. |
| 1:20-1:30 | Break |  | Buffer for questions. |
| 1:30-1:45 | Categorical concepts | `slides/day-02-data-preparation-and-categorical.qmd` | Counts versus summaries, ordering, rank, composition, and common scales. |
| 1:45-2:20 | Categorical modules | `modules/03_categorical-data/01_counts-and-ordering.qmd`, `modules/03_categorical-data/02_composition-and-proportions.qmd` | Ordered bars, raw counts versus proportions, stacked bars, and small multiples. |
| 2:20-2:50 | Categorical practice | `practice/02-one-variable-and-distributions/02_categorical-practice.qmd` | Students run working plot code, change one dial, and interpret what one bar or facet represents. |
| 2:50-3:00 | Wrap | Verbal | Preview continuous variables for Day 3. |

## If Time Runs Short

Do not rush into continuous variables. Preserve practice time and move continuous work to Day 3.

## Instructor Priorities

- Students explain what one observation represents.
- Students use `select()`, `filter()`, `mutate()`, `count()`, and `group_by()` + `summarize()` with working examples.
- Students change one part of a pipeline and explain what changed.
- Students distinguish observation counts from summarized numeric values.
- Students understand why ordering categories can improve comparison.
- Students understand why stacked bars can be hard to read and when small multiples help.
