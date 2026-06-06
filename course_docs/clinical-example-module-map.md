# Clinical Example Module Map

This document maps worked examples from `/Users/erik/Code/Courses/clinical-data-viz/examples` into the course schema used in this repository.

| Source example | Main teaching idea | Course placement |
|---|---|---|
| `prams_1_data_prep.qmd` | Data preparation, variable naming, filtering, reshaping | `01-workflow-and-basics` |
| `prams_2_ggplot_concepts.qmd` | Grammar of graphics, iterative bar/lollipop plots, highlighting | `01-workflow-and-basics`, `02_categorical-data`, `09_communication-polish` |
| `prams_3_iteration_aggregation.qmd` | Aggregation, group comparison, small multiples, difference plots | `04_group-comparison`, `09_communication-polish` |
| `applications_1_effective_and_honest_scales.qmd` | Honest scales, absolute vs relative comparisons, misleading time windows | `09_communication-polish`, `06_change` |
| `applications_4_distribution_plots.qmd` | Box plots, violin plots, density plots, shape and overlap | `03_continuous-data`, `04_group-comparison` |
| `applications_5_visualizing_time_trends.qmd` | Time trends, intervention markers, flow/pathway graphics | `06_change`, `08_flow` |
| `applications_6_visualizing_correlations_and_models.qmd` | Scatterplots, smoothing, model coefficients, prediction plots | `05_association`, `09_communication-polish` |
| `applications_7_cleveland_univariate_data.qmd` | Distribution diagnostics, residual thinking, mean-difference plots | `03_continuous-data`, `04_group-comparison`, `05_association` |
| `colors_and_accessibility.qmd` | Sequential/diverging/qualitative color, accessibility, highlighting | `09_communication-polish` |
| `ggplot_themes_and_staying_dry.qmd` | Reusable plot styling, themes, repeated visual language | `09_communication-polish` |
| `saving_visualizations.qmd` | Export formats, dimensions, resolution | `09_communication-polish` |
| `making_dags.qmd` | Conceptual diagrams, process/causal structure | `08_flow` |

The adapted course modules avoid the original support scripts and specialized packages where possible. They use the course datasets, explicit package calls, `here::here()` paths, and stepwise plot objects.
