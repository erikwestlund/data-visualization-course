# Clinical Example Module Map

This document maps worked examples from `/Users/erik/Code/Courses/clinical-data-viz/examples` into the course schema used in this repository.

| Source example | Main teaching idea | Course placement |
|---|---|---|
| `prams_1_data_prep.qmd` | Data preparation, variable naming, filtering, reshaping | `01-workflow-and-basics` |
| `prams_2_ggplot_concepts.qmd` | Grammar of graphics, iterative bar/lollipop plots, highlighting | `01-workflow-and-basics`, `03_categorical-data`, `10_communication-polish` |
| `prams_3_iteration_aggregation.qmd` | Aggregation, group comparison, small multiples, difference plots | `05_group-comparison`, `10_communication-polish` |
| `applications_1_effective_and_honest_scales.qmd` | Honest scales, absolute vs relative comparisons, misleading time windows | `10_communication-polish`, `07_change` |
| `applications_4_distribution_plots.qmd` | Box plots, violin plots, density plots, shape and overlap | `04_continuous-data`, `05_group-comparison` |
| `applications_5_visualizing_time_trends.qmd` | Time trends, intervention markers, flow/pathway graphics | `07_change`, `09_flow` |
| `applications_6_visualizing_correlations_and_models.qmd` | Scatterplots, smoothing, model coefficients, prediction plots | `06_association`, `10_communication-polish` |
| `applications_7_cleveland_univariate_data.qmd` | Distribution diagnostics, residual thinking, mean-difference plots | `04_continuous-data`, `05_group-comparison`, `06_association` |
| `colors_and_accessibility.qmd` | Sequential/diverging/qualitative color, accessibility, highlighting | `10_communication-polish` |
| `ggplot_themes_and_staying_dry.qmd` | Reusable plot styling, themes, repeated visual language | `10_communication-polish` |
| `saving_visualizations.qmd` | Export formats, dimensions, resolution | `10_communication-polish` |
| `making_dags.qmd` | Conceptual diagrams, process/causal structure | `09_flow` |

The adapted course modules avoid the original support scripts and specialized packages where possible. They use the course datasets, explicit package calls, `here::here()` paths, and stepwise plot objects.
