# data-visualization-course

Guidance for AI assistants working in this course repository.

## Teaching Materials

- Teaching notebooks and scripts should use plain R/tidyverse code and should not require the Framework package.
- Do not use relative path tricks such as `../`, `../../`, or fallback path logic in teaching materials.
- Make students learn to work from an RStudio/Positron project root or use the `here` package for file paths.
- Prefer clear paths such as `here::here("data", "real", "file.csv")` when a notebook needs to read course data.
- Use explicit package calls, such as `library(dplyr)`, `library(ggplot2)`, `library(readr)`, `library(stringr)`, and `library(here)`.
- Do not use Framework helpers such as `scaffold()`, `data_read()`, or `data_save()` in student-facing notebooks.

## Course Structure

- `slides/`: lecture materials.
- `modules/`: instructor/reference notebooks.
- `practice/`: student-facing practice notebooks.
- `assignments/`: homework and project prompts.
- `course_docs/`: syllabus, setup docs, policies, and planning notes.
- `data/real/`: cleaned teaching datasets.
- `data/codebooks/`: codebooks for cleaned datasets.
- `scripts/`: reproducible data preparation scripts.

## Style

- Keep teaching code direct and inspectable.
- Build `ggplot2` examples stepwise as plot objects such as `p1`, `p2`, and `p3`.
- Prefer real public datasets for assignments and small reliable datasets for live coding.
