# Day 2 Schedule: One Variable And Distributions

Assumed class block: 3 hours.

## Main Goal

Students can inspect a dataset, use basic data verbs to prepare one-variable summaries, and make categorical or continuous plots that reveal counts, center, spread, shape, and unusual values. Close to half of the day should be spent on data preparation and aggregation habits.

## Schedule

| Time | Segment | Materials | Notes |
|---:|---|---|---|
| 0:00-0:10 | Day 1 debrief and technical fixes | Verbal, `source("updater.R")` if needed | Resolve blockers before content. |
| 0:10-0:35 | Data verbs before plots | `slides/day-02-categorical-and-continuous.qmd` | Observation, `select()`, `filter()`, `count()`, `group_by()` + `summarize()`, `mutate()`, `arrange()`. |
| 0:35-1:05 | Counts, summaries, and ordering | `modules/02_categorical-data/01_counts-and-ordering.qmd` | Focus on observation meaning, aggregation, and ordering. |
| 1:05-1:20 | Position on a common scale | `slides/day-02-categorical-and-continuous.qmd` | Explain why ordered bars, dot plots, histograms, and aligned axes work well. |
| 1:20-1:30 | Rank as ordered position | Brief excerpt from `modules/02_categorical-data/03_ranked-comparisons.qmd` | Optional teaser only; rank supports the common-scale idea. |
| 1:30-1:40 | Break |  | Buffer for questions. |
| 1:40-2:15 | Summaries, histograms, and density | `modules/03_continuous-data/01_histograms-and-density.qmd` | Emphasize mean, median, spread, bin width, shape, and smoothing cautions. |
| 2:15-2:35 | Outliers and summaries | `modules/03_continuous-data/03_outliers-and-summaries.qmd` | Use the univariate parts; inspect unusual records before judging them. |
| 2:35-2:55 | Student practice | `practice/02_categorical-data/01_counts-and-ordering-practice.qmd`, `practice/03_continuous-data/01_histograms-and-density-practice.qmd`, `practice/03_continuous-data/03_outliers-and-summaries-practice.qmd` | Require one structure/summary table and one one-variable plot. |
| 2:55-3:00 | Wrap | Verbal | Preview comparison and association. |

## If Time Runs Short

Skip the ranked-comparisons excerpt and treat it as optional practice. Preserve the data-verbs opening, counts/summaries work, common-scale idea, and histogram/bin-width work.

## Instructor Priorities

- Students explain what one observation represents.
- Students use `count()` or `group_by()` + `summarize()` before plotting.
- Students distinguish observation counts from summarized numeric values.
- Students understand why position on a common scale supports accurate comparison.
- Students describe center, spread, shape, and unusual values.
- Students know that grouped distributions and composition are Day 3 comparison topics.
