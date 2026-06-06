# Agent Instructions

## Teaching Materials

- Teaching notebooks and scripts should use plain R/tidyverse code and should not require the Framework package.
- Do not use relative path tricks such as `../`, `../../`, or fallback path logic in teaching materials.
- Teach students to work from the RStudio/Positron project root. The root `_quarto.yml` uses `execute-dir: project`, so rendered notebooks should also execute from the course root.
- Prefer direct project-root paths such as `readr::read_csv("data/real/file.csv")` in teaching notebooks.
- Do not use `here::here()` or `here::i_am()` in student-facing teaching notebooks unless there is a specific reason that direct project-root paths cannot handle.

## Course Workflow

- The instructor's normal class flow is: start with slides for concepts and transitions, then switch to module notebooks for live screen-share walkthroughs.
- Modules should be written so the instructor can make the notebook large in RStudio/Positron, talk through the text, run chunks live, and show rendered output when useful.
- The first workflow module should support a live RStudio walkthrough of getting the course materials, opening the project, running `source("updater.R")`, copying practice templates into `practice/work/`, and rendering a notebook.
- When adding screenshots to workflow modules, store them beside the relevant module under a local `images/` directory and keep filenames descriptive.

## Practice Notebooks

- Practice notebooks should be templates for students to complete, not worked solutions.
- Prefer instructions, prompts, and empty code blocks over filled-in analysis code.
- It is acceptable in early workflow practice to provide the data-ingest code so students can focus on setup and first exploration.
- After the earliest workflow practice, expect students to write their own data-ingest code using direct project-root paths.
