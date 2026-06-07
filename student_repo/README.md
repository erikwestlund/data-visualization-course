# Data Visualization Course

This folder contains materials we'll be using daily in the course:

* Slides (rendered HTML files)
* Data sets referenced in class examples
* Learning modules as editable notebooks and rendered HTML files
* Practice templates

Please note that this repository will likely be updated daily. 

## Start Here

1. Open `data-visualization-course.Rproj` in RStudio, or open this folder in Positron.
2. Open `modules/00_preclass-tech-check/01_pre-class-directions.qmd`.
3. Open and render `modules/00_preclass-tech-check/02_setup-check.qmd`.
4. Open `syllabus.html` for the course syllabus.

## What Is In This Folder

- `data/`: course datasets, rendered codebooks, and `data/data.html` index.
- `slides/`: rendered course slides as HTML files.
- `modules/`: course-owned lesson notebooks and setup checks as Quarto `.qmd` files.
- `modules/rendered/`: rendered HTML versions of lesson notebooks, starting at `modules/rendered/index.html`.
- `assignments/`: rendered problem set and project instructions as HTML files.
- `practice/templates/`: practice starter notebooks that may be updated during the course.
- `practice/work/`: your copies of practice notebooks. Work here.

## Practice Work

Do not use `modules/` or `practice/templates/` for your own saved work. Those files may be added, changed, renamed, or removed during course updates.

Instead, run this from the R Console at the project root:

```r
source("updater.R")
```

That script updates course files if you are using Git, then copies new practice templates into `practice/work/`. It does not overwrite files that already exist, so your edits are left alone.

Open and edit notebooks from `practice/work/`.

## Rendering Notebooks

Module notebooks in `modules/` are course-owned Quarto `.qmd` files. Rendered versions for quick viewing are in `modules/rendered/`.

When you render your own notebooks, the included `_quarto.yml` file sets `embed-resources: true`, so rendered notebooks can be submitted or shared as single HTML files.

If rendering fails, check that R, Quarto, and the required packages are installed.

Required R packages for the first part of the course:

```r
install.packages(c("dplyr", "ggplot2", "readr", "stringr"))
```
