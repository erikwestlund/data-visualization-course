# Data Visualization Course Plan

Working planning document for the one-week, two-credit data visualization course. This is intentionally a sketchpad for decisions, improvements, and pre-execution tasks before building slides, assignments, examples, and course docs.

## Raw Notes

- The course should focus on exploratory data analysis in addition to making visualizations.
- General framing: all data visualization is fundamentally statistical in nature.
- Visualizations should be tied to an analytic or communicative goal, not treated as decorative outputs.
- Possible teaching approach: start from different types of analytic problems, then show how visualization helps address them.
- Emerging core themes for visualization and EDA:
  - Center
  - Spread
  - Shape
  - Grouping
  - Association
  - Change
  - Composition
  - Rank
  - Outliers and anomalies
  - Flow
  - Space
- These may be core things visualization tries to help us do, whether the immediate goal is exploratory analysis or communication.
- Notes on terms:
  - Shape covers distributional features beyond spread, such as skew, modality, tails, gaps, heaping, and zero inflation.
  - Association is preferred over relationship/correlation because it is broader and more statistical.
  - Interaction can be treated as association plus grouping rather than as its own core theme.
  - Composition asks what the whole is made of; it is related to grouping but not identical.
  - Outliers and anomalies should be treated as their own theme.
  - Flow can include flow diagrams and Mermaid plots.
  - Space is preferred over location.
  - Trajectory may be covered by flow or change rather than treated separately.
  - Structure is probably too broad as a core term.
  - Missingness is important statistically, but placement is undecided; it may be handled through other graph types rather than as a core theme.
- Possible sequencing principle: move from the most elementary statistical questions to more complex visual reasoning.
  - Start with one variable: center, spread, shape, outliers/anomalies.
  - Move to one variable plus categories: grouping, rank, composition.
  - Move to two variables: association.
  - Add time/order: change and trajectory-like problems.
  - Add space: spatial patterning and spatial comparison.
  - Add process: flow, transitions, and diagrams.
  - Add layered reasoning: interaction as association plus grouping; uncertainty/missingness as recurring complications.
  - End with communication: choosing, justifying, polishing, and explaining graphics for a real analytic goal.

## Draft Schedule Sketch

### Day 1: Workflow, First Visualization, And ggplot2 Basics

- Big question: can every student get from data to a rendered notebook and understand the basic mechanics of `ggplot2`?
- Statistical/visual focus: first plots, basic description, transformations, and aggregation.
- Concepts: project workflow, Quarto notebooks, vanilla tidyverse package setup, rendering, self-contained HTML outputs, functions, pipes, transformations, aggregations, and `ggplot2` layers.
- Core themes introduced lightly: counts, center, spread, shape, grouping, association.
- Class flow:
  - Course orientation and goals.
  - RStudio/Positron setup and project opening.
  - Open a workflow notebook, run the setup chunk, check that Quarto/R/project paths work.
  - Open a first visualization notebook, load data, make a few basic visualizations.
  - Work through the basic guts of `ggplot2`: data, aesthetics, geoms, layers, labels, themes, transformations, and aggregations.
  - Render notebook and troubleshoot.
  - Supported work time with individual help.
- End state: students have a working local project, a rendered self-contained HTML notebook, several simple visualizations, and a first mental model for how `ggplot2` works.
- Homework/practice: submit or render a notebook with several simple plots, at least one transformation, at least one aggregation, and short interpretation.

### Day 2: One Variable, Distributions, And Grouping

- Big question: what does this variable look like, and how does it differ across groups?
- Statistical/visual focus: distribution first, then grouped distribution.
- Core themes: center, spread, shape, outliers/anomalies, grouping, rank.
- Class flow:
  - Review Day 1 technical issues and common fixes.
  - Histograms, density plots, dot plots, box plots, violin plots.
  - Compare center/spread/shape across groups.
  - Rank groups thoughtfully without losing distributional nuance.
  - Introduce manual summaries: counts, means, medians, proportions.
  - Lab: make a grouped distribution plot and a ranked summary plot from the same data.
- End state: students can describe and visualize one variable overall and across groups.
- Homework/practice: exploratory memo with at least one distribution plot, one grouped comparison, and interpretation.

### Day 3: Association, Interaction, And Composition

- Big question: how do variables relate, and how does that relationship change across groups?
- Statistical/visual focus: two variables, then two variables plus grouping.
- Core themes: association, grouping, composition, interaction as association plus grouping.
- Class flow:
  - Scatterplots, smoothing, faceting, color/group aesthetics.
  - Association versus causation; visualizing without overclaiming.
  - Interaction as grouped association rather than a separate mystery concept.
  - Composition: what is the whole made of, and how is that different from group comparison?
  - Lab: build from simple scatterplot to grouped/faceted association plot; then create one composition plot.
- End state: students can visualize association, recognize grouped association/interaction, and distinguish grouping from composition.
- Homework/practice: create and justify one association plot and one composition or interaction plot.

### Day 4: Change, Space, Flow, And Choosing The Right Form

- Big question: how do patterns move over time, across space, or through a process?
- Statistical/visual focus: ordered data, spatial data, and process data.
- Core themes: change, space, flow, rank, anomalies.
- Class flow:
  - Time series, before/after plots, slope charts, and trajectories.
  - Spatial patterning: maps, small-multiple maps, and non-map alternatives.
  - Flow/process diagrams, including Mermaid as a lightweight tool.
  - Choosing the visualization from the analytic task rather than from a chart menu.
  - Lab: students choose from change/space/flow tasks and explain why their plot fits the problem.
- End state: students can choose visualization forms for temporal, spatial, and process questions.
- Homework/practice: short visualization choice exercise with a written justification.

### Day 5: Communication, Critique, Polish, And Grab Bag

- Big question: how do we turn analysis into an honest, useful visual explanation?
- Statistical/visual focus: synthesis, critique, redesign, and communication.
- Core themes: all themes revisited through analytic and communicative goals.
- Class flow:
  - Critique weak or misleading graphics.
  - Redesign for clarity, honesty, accessibility, and audience.
  - Annotation, labels, legends, color, scales, captions, and export choices.
  - Responsible LLM use for visualization workflows: privacy, prompts, verification, and code review.
  - Optional dashboard/Shiny demo if time allows.
  - Grab bag previews and final project discussion.
- End state: students have a project direction, at least one revised visualization, and a framework for justifying design choices.
- Homework/final: rendered final project notebook/report with polished visualizations and written justifications.

## Materials Architecture Notes

- Each day should have slides that guide the class session.
- Slides should provide the conceptual thread, motivation, examples to discuss, and transitions between activities.
- For every type of figure taught in the course, create a single focused example Quarto document.
- Example Quarto documents should live under `modules/`, organized into directories for the major top-level concepts.
- Proposed `modules/` organization should follow the core conceptual spine rather than chart types alone:
  - `01-workflow-and-basics/`
  - `02_data-preparation/`
  - `03_categorical-data/`
  - `04_continuous-data/`
  - `05_group-comparison/`
  - `06_association/`
  - `07_change/`
  - `08_space/`
  - `09_flow/`
  - `10_communication-polish/`
- Each module example should be complete enough to serve as an instructor/reference version.
- Each module example should focus on one figure type or one tightly related visualization pattern.
- There should also be a `practice/` directory for student-facing notebooks.
- Practice notebooks should map roughly one-to-one to the example notebooks.
- Practice notebooks should include enough scaffold for students to start without staring at a blank page.
- Practice notebooks can include a few tips or reminders at the top.
- Practice notebooks should default to a dataset that works out of the box.
- Practice notebooks should be designed so students can swap in their own data when appropriate.
- Practice notebooks should leave meaningful gaps for students to fill in themselves.
- Teaching notebooks should not require the Framework package.
- Teaching notebooks should use plain R and explicit tidyverse package calls such as `library(dplyr)`, `library(ggplot2)`, and `library(stringr)` so students can run them outside this project infrastructure.
- Day 1 `ggplot2` teaching should build plot objects step by step: create `p1`, print it, add one layer or change to create `p2`, print it, and repeat so students see what each grammar component does.
- The intended pattern is: slides guide the lesson, module examples demonstrate the figure, practice notebooks let students reproduce/adapt the idea.

## Planning Goals

- Expand the prior short version of the course into a fuller one-week, two-credit experience.
- Learn from the 2025 summer course rather than simply porting it forward.
- Separate conceptual learning, tooling, live coding, practice, and project work more deliberately.
- Make course logistics and technical support materials available before the first class.
- Build materials in this repository using a plain Quarto course structure.

## Starting Assumptions

- Course length: one week.
- Credit load: two credits.
- Primary language/tooling: R, Quarto, tidyverse/`ggplot2`, and reproducible notebook workflows.
- Git/GitHub can be optional or instructor-facing rather than a required student workflow.
- Primary student output: rendered Quarto documents with visualizations and written justification.
- Old course reference: `/Users/erik/Code/Courses/data-viz-summer-25`.
- New course repository: `/Users/erik/Projects/data-visualization-course`.

## Lessons From The Old Course

### What To Preserve

- Strong emphasis on scientific questions driving visualization choices.
- Iterative `ggplot2` workflow: start simple, add layers, revise for clarity.
- Practical examples with public health and maternal health data.
- Discussion of truthful scales, accessibility, color, small multiples, annotations, and model visualization.
- Daily postmortems as a way to clarify skipped material and support students asynchronously.
- Final project structure requiring students to justify visualization choices.

### What To Improve

- Day 1 in the old course was too tooling-heavy and visualization-light.
- GitHub setup and troubleshooting were reactive; students needed clearer support earlier.
- Quarto rendering, `.gitignore`, and repository hygiene should be prebuilt into starter materials.
- Course website publishing should be ready before class starts, not introduced mid-course.
- Assignment expectations should be clearer, especially what counts as multivariable visualization.
- PRAMS and other large data dependencies need a cleaner data plan.
- LLM use needs more deliberate framing around privacy, codebooks, prompt quality, and verification.
- Advanced examples like Shiny and interaction effects were valuable but squeezed by time.
- Some examples were too dense to discuss line by line; they need lab versions, instructor versions, and reading notes.

## Course Design Principles

- Day 1 workflow foundation: students need real time to get RStudio or Positron, Quarto, and the course project working.
- Tooling in service of work: Quarto, files, and project structure should be taught through the concrete goal of rendering a self-contained HTML notebook with a basic visualization.
- First plot on Day 1: the day can still be workflow-heavy, but students should leave with a rendered notebook containing at least one basic visualization.
- Built-in troubleshooting time: schedule instructor-supported work time rather than treating setup problems as interruptions.
- One repeated dataset arc: use one or two datasets across multiple days so students can build fluency instead of constantly relearning context.
- Build in layers: every major visualization should move from rough first plot to polished final plot.
- Critique and redesign: include examples of bad, misleading, or merely adequate charts and ask students to improve them.
- More lab time: two-credit expansion should add structured practice, not only more lecture.
- Reproducibility by default for teaching materials should come from simple project structure, Quarto rendering, and plain tidyverse code rather than the Framework package.
- Keep a daily postmortem habit: publish a short post-class note with links, skipped material, common problems, and next steps.

## Proposed One-Week Arc

### Day 1: Workflow, Setup, And First Plot

- Course goals, expectations, deliverables, and support channels.
- Get students working in RStudio or Positron.
- Explain the course project structure and where student work should go.
- Live exercise: create or open a Quarto notebook, run a plain tidyverse setup chunk, make one basic visualization, and render the notebook.
- Minimal `ggplot2`: data, aesthetics, one geom, labels, and a theme.
- Build in substantial supported work time for setup, rendering, paths, package, and first-plot troubleshooting.
- End state: every student has a working local project and one rendered self-contained HTML notebook with a basic visualization.

### Day 2: Data Preparation And Grammar Of Graphics

- Tidy data for visualization.
- Data cleaning and variable naming as visualization work.
- `ggplot2` grammar: aesthetics, geoms, stats, scales, facets, grouping.
- Aggregation: when to let `ggplot2` summarize and when to summarize manually.
- Lab: build a two-variable plot into a three-variable plot using color, facets, or small multiples.

### Day 3: Design, Accessibility, And Iteration

- Color, contrast, accessibility, and perceptual palettes.
- Annotation, visual hierarchy, labels, legends, and typography.
- Scales, axes, coordinate systems, and avoiding misleading choices.
- Critique workshop: improve weak charts.
- Lab: take a rough plot through multiple revisions to a polished figure.

### Day 4: Choosing The Right Visualization For The Question

- Distributions, comparisons, time trends, spatial data, relationships, and model outputs.
- Scientific question to variables to plot type.
- DAGs or conceptual diagrams as a way to reason about what matters.
- Small multiples and alternatives to maps.
- Lab: students choose from a menu of visualization tasks and justify their choices.

### Day 5: Communication, Dashboards, And Grab Bag

- Communicating findings in notebooks, slides, reports, and dashboards.
- Optional Shiny/demo dashboard as a stretch topic, not a core requirement.
- Responsible LLM use for visualization workflows: prompts, code review, privacy, verification.
- Grab bag previews and peer discussion.
- Wrap-up: reproducible handoff, exporting figures, and next steps.

## Assignment Sketch

### Before Class

- Install or verify R, RStudio or Positron, and Quarto.
- Git/GitHub is optional unless we later decide to require repository submission.
- Complete a short setup check form.
- Tell students that Day 1 will include supported setup time, so they should arrive with software attempted but do not need everything perfect.
- Optional: read selected chapters from Kieran Healy's *Data Visualization*.

### Daily Practice

- Short, focused exercises due nightly or by the next morning.
- Each practice task should produce one rendered Quarto document.
- Practice should emphasize one concept at a time: first plot, grammar, aggregation, accessibility, critique, or communication.

### Final Project

- Students submit a rendered Quarto notebook or report.
- Project should include a small set of polished visualizations, not an exhaustive gallery.
- Each visualization needs a short justification: question, variables, design choices, and limitations.
- Require at least one multivariable visualization and one revised/redesigned visualization.
- Consider reducing the old requirement of 10 visualizations if the goal is depth and polish.

## Materials To Build

### Course Docs

- Syllabus.
- Schedule.
- Setup guide.
- Optional GitHub troubleshooting guide if repository submission becomes part of the course.
- Quarto rendering and `.gitignore` guide.
- Assignment submission guide.
- Responsible LLM use guide.
- Data guide describing included datasets, codebooks, and privacy constraints.

### Slides And Modules

- Day 1 orientation and first plots.
- Day 2 data prep and grammar of graphics.
- Day 3 design, accessibility, and iteration.
- Day 4 plot choice by question type.
- Day 5 communication, dashboards, and grab bag.

### Examples

- Minimal first Quarto plot.
- Data prep example using direct, teachable `readr` and `dplyr` code.
- Grammar of graphics example.
- Iteration and aggregation example.
- Colors and accessibility example.
- Effective and honest scales example.
- Spatial data: choropleth plus non-map alternative.
- Distribution plots.
- Time trends.
- Correlations and model outputs.
- Saving/exporting figures.
- Optional Shiny dashboard.
- Optional LLM-assisted workflow example with prompts and verification notes.

### Assignments

- Setup check.
- Problem set 1: first plots and Quarto rendering.
- Problem set 2: grammar of graphics and multivariable visualization.
- Problem set 3: redesign, accessibility, and interpretation.
- Final project prompt and rubric.

## Reuse From Old Course

- `lectures/day_1/day_1_lecture.qmd`: reuse intro concepts, Tufte framing, and course goals, but reduce Day 1 tooling load.
- `lectures/day_2/day_2_lecture.qmd`: reuse data preparation, grammar of graphics, aggregation, and color sections.
- `lectures/day_3/day_3_lecture.qmd`: break into multiple days or modules; it contains too much for one day.
- `examples/prams_1_data_prep.qmd`: adapt to plain R/tidyverse data conventions.
- `examples/prams_2_ggplot_concepts.qmd`: adapt as a grammar/layering lab.
- `examples/prams_3_iteration_aggregation.qmd`: adapt as a multivariable visualization and aggregation lab.
- `examples/colors_and_accessibility.qmd`: reuse for Day 3.
- `examples/applications_*`: convert into modular Day 4 examples.
- `examples/saving_visualizations.qmd`: use near the end of the course.
- `examples/shiny_example.R`: keep optional or demo-only unless there is enough time.
- `postmortems/day_*_postmortem.qmd`: mine for recurring support issues and convert those into up-front docs.

## Data Plan

- Prefer real public datasets for student assignments when feasible.
- Use public-health-ish simulated datasets for lessons, low-friction practice, and parallel "lookalike" examples.
- Pair simulated lesson datasets with real or simulated homework "cousin" datasets that have similar shape but different topics and variable names.
- See `course_docs/real-data-integration-plan.md` for the old-course data assessment and integration plan.
- See `course_docs/simulated-datasets-plan.md` for the working simulated dataset design spec.
- Decide which datasets are bundled directly in `data/` and which are downloaded or generated.
- Avoid depending on large external files during class unless the download path is robust.
- Include small, reliable teaching datasets for live coding.
- Include codebooks or variable dictionaries for every dataset students touch.
- Teaching notebooks should use plain R/tidyverse data operations, usually `readr::read_csv()` with `here::here()` paths.
- If simulated data is used, provide the simulation script and a pre-generated CSV.
- Consider one main public health dataset for the course-long arc plus a few small specialty datasets.
- Current small specialty datasets include `data/real/davis_height_weight.csv`, `data/real/migraine_headache_diary.csv`, `data/real/titanic_passengers.csv`, `data/real/infant_mortality_countries.csv`, `data/real/ginzberg_depression.csv`, `data/real/blackmore_davis_exercise_eating_disorders.csv`, and `data/real/post_coma_recovery.csv` from John Fox's Applied Regression data archive.
- Current larger individual-level public health teaching datasets include NHANES August 2021-August 2023 extracts in `data/real/nhanes_2021_2023_*.csv`, especially `data/real/nhanes_2021_2023_analysis.csv` for joined person-level examples and `data/real/nhanes_2021_2023_dietary_foods.csv` for long-data aggregation practice.
- Simulated analogs for all top-level real teaching datasets are generated by `scripts/simulate-teaching-data.R`; see `data/simulated/simulated_dataset_crosswalk.csv` for real-to-simulated pairings.

## Technical And Repository Plan

- Configure the course website before Day 1.
- Pre-create `slides/`, `assignments/`, `modules/`, `course_docs/`, `readings/`, and `data/` materials.
- Add starter files students can copy or modify.
- Add a student `work/` guidance document if students will fork or clone the repo.
- Add `.gitignore` entries for Quarto artifacts and scratch work.
- Ensure teaching notebooks do not depend on the Framework package.
- Use explicit `library()` calls for packages used in each teaching notebook, such as `dplyr`, `ggplot2`, `tidyr`, `stringr`, and `readr`.
- Use direct, teachable data-reading code in notebooks instead of Framework helpers.
- Test render all course materials before publishing.

## Pre-Execution Checklist

### Course Decisions

- Confirm exact dates, daily schedule, and contact hours.
- Confirm grading scheme and final project due date.
- Decide whether GitHub is required or optional.
- Decide whether students submit through CoursePlus, GitHub, email, or a mix.
- Decide required versus optional readings.
- Decide whether Shiny/dashboard material is core, optional, or removed.
- Decide explicit policy for LLM use.

### Content Work

- Map old three-day material into five daily modules.
- Reserve Day 1 time explicitly for RStudio/Positron setup, opening the project, rendering Quarto notebooks, and individual troubleshooting.
- Split dense examples into teaching notebooks and completed reference notebooks.
- Write daily learning objectives.
- Write daily in-class exercises.
- Write daily homework prompts.
- Build final project rubric.
- Build critique/redesign examples.
- Build instructor notes for likely stumbling blocks.

### Technical Work

- Populate `data/` with final teaching datasets.
- Add or update codebooks for each cleaned teaching dataset.
- Create setup check notebook.
- Create starter notebook template.
- Create optional GitHub troubleshooting page only if GitHub becomes part of submission.
- Configure Quarto site navigation.
- Render and inspect all pages.
- Test on a clean machine or fresh R environment if possible.

### Student Support Work

- Prepare Day 0 setup email.
- Prepare Day 1 quick-start handout.
- Prepare a Day 1 setup checklist that can be used while helping students one-on-one.
- Prepare FAQ for rendering, working directories, package installation, missing files, and optional GitHub use.
- Prepare postmortem template for daily follow-up notes.
- Prepare extension/submission policy language.

## Open Questions

- Is this course still aimed primarily at JHSPH/public health students?
- How many hours per day are scheduled?
- How much prior R experience should be assumed?
- Should the course require GitHub, or should GitHub be recommended but not central?
- Should the final project use student-selected data, provided datasets, or either?
- How many visualizations should the final project require for a two-credit one-week course?
- Should dashboards be a required topic or an optional final-day demonstration?
- Should AI/LLM workflow be a full module, a short demo, or a policy/sidebar?

## Parking Lot

- Build a gallery of before/after plot redesigns.
- Create a one-page `ggplot2` grammar cheat sheet tailored to this course.
- Create a visual checklist students can use before submitting figures.
- Add a recurring "what changed and why" slide to every redesign example.
- Add peer review forms for final project discussion.
- Consider a small final presentation instead of only a written submission.
- Consider using more health equity examples if aligned with student interests.
