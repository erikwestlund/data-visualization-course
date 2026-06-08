#!/usr/bin/env Rscript

source_root <- normalizePath(".", winslash = "/", mustWork = TRUE)

p <- function(...) {
  file.path(..., fsep = "/")
}

is_file <- function(path) {
  file.exists(path) && !dir.exists(path)
}

read_simple_manifest <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lines <- sub("[[:space:]]+#.*$", "", lines)
  lines <- lines[nzchar(trimws(lines))]

  out <- list()
  current_key <- NULL

  for (line in lines) {
    if (grepl("^[^[:space:]][^:]+:[[:space:]]*.*$", line)) {
      parts <- strsplit(line, ":", fixed = TRUE)[[1]]
      key <- trimws(parts[[1]])
      value <- trimws(paste(parts[-1], collapse = ":"))

      current_key <- key

      if (nzchar(value)) {
        out[[key]] <- value
      } else {
        out[[key]] <- character()
      }
    } else if (grepl("^[[:space:]]+-[[:space:]]+", line) && !is.null(current_key)) {
      value <- trimws(sub("^[[:space:]]+-[[:space:]]+", "", line))
      out[[current_key]] <- c(out[[current_key]], value)
    }
  }

  out
}

manifest_path <- p(source_root, "student_repo", "export-manifest.yml")

if (!is_file(manifest_path)) {
  stop("Missing student export manifest: student_repo/export-manifest.yml", call. = FALSE)
}

export_manifest <- read_simple_manifest(manifest_path)

day_definitions <- list(
  preclass = list(
    module_dirs = c("00_preclass-tech-check"),
    practice_dirs = character()
  ),
  `day-01` = list(
    module_dirs = c("01-workflow-and-basics"),
    practice_dirs = c("01-workflow-and-basics")
  ),
  `day-02` = list(
    module_dirs = c("02_categorical-data", "03_continuous-data"),
    practice_dirs = c("02_categorical-data", "03_continuous-data")
  ),
  `day-03` = list(
    module_dirs = c("04_group-comparison", "05_association"),
    practice_dirs = c("04_group-comparison", "05_association")
  ),
  `day-04` = list(
    module_dirs = c("06_change", "07_space", "08_flow"),
    practice_dirs = c("06_change", "07_space", "08_flow")
  ),
  `day-05` = list(
    module_dirs = c("09_communication-polish"),
    practice_dirs = c("09_communication-polish")
  )
)

published_days <- export_manifest$published_days

if (is.null(published_days) || length(published_days) == 0 || "all" %in% published_days) {
  published_days <- names(day_definitions)
}

unknown_days <- setdiff(published_days, names(day_definitions))

if (length(unknown_days) > 0) {
  stop(
    "Unknown published day(s) in student_repo/export-manifest.yml: ",
    paste(unknown_days, collapse = ", "),
    call. = FALSE
  )
}

published_day_definitions <- day_definitions[published_days]
published_module_dirs <- unique(unlist(lapply(published_day_definitions, `[[`, "module_dirs"), use.names = FALSE))
published_practice_dirs <- unique(unlist(lapply(published_day_definitions, `[[`, "practice_dirs"), use.names = FALSE))

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 1) {
  stop(
    "Usage: Rscript scripts/build-student-repo.R [/path/to/student-repo]",
    call. = FALSE
  )
}

target_arg <- if (length(args) == 1) {
  args[[1]]
} else {
  export_manifest$target_root_default
}

if (is.null(target_arg) || !nzchar(target_arg)) {
  stop("Missing target_root_default in student_repo/export-manifest.yml", call. = FALSE)
}

target_root <- normalizePath(path.expand(target_arg), winslash = "/", mustWork = FALSE)

dir_create <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
}

write_lines <- function(path, lines) {
  dir_create(dirname(path))
  writeLines(lines, path)
}

copy_file <- function(from, to) {
  dir_create(dirname(to))
  ok <- file.copy(from, to, overwrite = TRUE, copy.date = TRUE)

  if (!ok) {
    stop("Failed to copy ", from, " to ", to, call. = FALSE)
  }
}

is_inside <- function(path, parent) {
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)
  parent <- normalizePath(parent, winslash = "/", mustWork = TRUE)

  startsWith(path, paste0(parent, "/"))
}

relative_to <- function(path, root) {
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)
  root <- normalizePath(root, winslash = "/", mustWork = TRUE)

  if (identical(path, root)) {
    return("")
  }

  substring(path, nchar(root) + 2)
}

is_in_published_dir <- function(path, root, published_dirs) {
  relative_path <- relative_to(path, root)

  if (!nzchar(relative_path)) {
    return(TRUE)
  }

  first_part <- strsplit(relative_path, "/", fixed = TRUE)[[1]][[1]]
  first_part %in% published_dirs
}

validate_manifest_paths <- function(paths, should_exist) {
  if (is.null(paths) || length(paths) == 0) {
    return(invisible(NULL))
  }

  full_paths <- p(target_root, paths)
  exists <- file.exists(full_paths)

  if (should_exist && any(!exists)) {
    stop(
      "Export validation failed. Missing expected file(s):\n",
      paste(paths[!exists], collapse = "\n"),
      call. = FALSE
    )
  }

  if (!should_exist && any(exists)) {
    stop(
      "Export validation failed. Unexpected file(s) exist:\n",
      paste(paths[exists], collapse = "\n"),
      call. = FALSE
    )
  }

  invisible(NULL)
}

if (!dir.exists(p(source_root, "scripts")) || !is_file(p(source_root, "course_docs", "syllabus.qmd"))) {
  stop("Run this script from the course source repository root.", call. = FALSE)
}

student_readme <- p(source_root, "student_repo", "README.md")
student_updater <- p(source_root, "student_repo", "updater.R")

if (!is_file(student_readme)) {
  stop("Missing student README template: student_repo/README.md", call. = FALSE)
}

if (!is_file(student_updater)) {
  stop("Missing student updater script: student_repo/updater.R", call. = FALSE)
}

if (identical(target_root, source_root) || is_inside(target_root, source_root)) {
  stop("Choose a target outside the source repository.", call. = FALSE)
}

managed_paths <- c(
  "assignments",
  "data",
  "docs",
  "modules",
  "practice",
  "rendered",
  "scripts",
  "slides",
  "syllabus.html",
  "README.md",
  "updater.R",
  ".gitignore",
  "_quarto.yml",
  "data-visualization-course.Rproj",
  "data-visualization-course.code-workspace"
)

skip_names <- c(
  ".DS_Store",
  ".quarto",
  "_freeze",
  ".Rproj.user"
)

should_skip <- function(path) {
  name <- basename(path)

  name %in% skip_names ||
    grepl("_cache$", name) ||
    grepl("_files$", name) ||
    grepl("[.]knit[.]md$", name) ||
    grepl("[.]utf8[.]md$", name)
}

is_codebook_markdown <- function(path) {
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)
  codebook_dir <- normalizePath(p(source_root, "data", "codebooks"), winslash = "/", mustWork = TRUE)

  startsWith(path, paste0(codebook_dir, "/")) && grepl("[.]md$", path)
}

is_rendered_data_source_markdown <- function(path) {
  path <- normalizePath(path, winslash = "/", mustWork = FALSE)
  data_dir <- normalizePath(p(source_root, "data"), winslash = "/", mustWork = TRUE)

  identical(dirname(path), data_dir) && grepl("[.]md$", path)
}

copy_clean_dir <- function(from, to, extra_skip = function(path) FALSE) {
  if (!dir.exists(from)) {
    stop("Missing source directory: ", from, call. = FALSE)
  }

  dir_create(to)

  entries <- list.files(from, all.files = TRUE, no.. = TRUE, full.names = TRUE)
  entries <- entries[!vapply(entries, function(path) should_skip(path) || extra_skip(path), logical(1))]

  for (entry in entries) {
    destination <- p(to, basename(entry))

    if (dir.exists(entry)) {
      copy_clean_dir(entry, destination, extra_skip = extra_skip)
    } else {
      copy_file(entry, destination)
    }
  }
}

rewrite_practice_here_paths <- function(directory, practice_root = "practice/templates") {
  qmd_files <- list.files(directory, pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE)

  for (qmd_file in qmd_files) {
    relative_path <- substring(qmd_file, nchar(directory) + 2)
    here_path <- file.path(practice_root, relative_path)
    lines <- readLines(qmd_file, warn = FALSE)
    lines <- gsub(
      'here::i_am\\("practice/[^"\\n]+"\\)',
      paste0('here::i_am("', here_path, '")'),
      lines,
      perl = TRUE
    )
    writeLines(lines, qmd_file)
  }
}

copy_rendered_html_for_sources <- function(source_dir, rendered_dir, target_dir, source_pattern = "[.]qmd$", source_files = NULL) {
  if (!dir.exists(source_dir)) {
    stop("Missing source directory: ", source_dir, call. = FALSE)
  }

  if (!dir.exists(rendered_dir)) {
    stop("Missing rendered directory: ", rendered_dir, call. = FALSE)
  }

  dir_create(target_dir)

  sources <- if (is.null(source_files)) {
    list.files(source_dir, pattern = source_pattern, full.names = FALSE)
  } else {
    basename(source_files)
  }

  html_files <- sub("[.][^.]+$", ".html", sources)

  for (html_file in html_files) {
    rendered_file <- p(rendered_dir, html_file)

    if (!is_file(rendered_file)) {
      stop(
        "Missing rendered file: ", rendered_file,
        ". Render the matching .qmd before building the student repo.",
        call. = FALSE
      )
    }

    copy_file(rendered_file, p(target_dir, html_file))
  }
}

copy_rendered_html_file <- function(rendered_file, target_file) {
  if (!is_file(rendered_file)) {
    stop("Missing rendered file: ", rendered_file, call. = FALSE)
  }

  copy_file(rendered_file, target_file)
}

render_file <- function(path) {
  message("Rendering ", path)

  output <- system2("quarto", c("render", path), stdout = TRUE, stderr = TRUE)
  status <- attr(output, "status")

  if (!is.null(status) && !identical(status, 0L)) {
    cat(output, sep = "\n")
    stop("Quarto render failed for ", path, call. = FALSE)
  }
}

render_qmds_in <- function(directory) {
  qmd_files <- list.files(directory, pattern = "[.]qmd$", full.names = TRUE)

  for (qmd_file in qmd_files) {
    render_file(qmd_file)
  }
}

slide_qmd_files <- function() {
  files <- list.files(p(source_root, "slides"), pattern = "[.]qmd$", full.names = TRUE)
  files[order(files)]
}

render_slide_qmds <- function() {
  for (qmd_file in slide_qmd_files()) {
    render_file(qmd_file)
  }
}

module_qmd_files <- function() {
  files <- list.files(p(source_root, "modules"), pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE)
  files <- files[!grepl("/00_preclass-tech-check/", files, fixed = TRUE)]
  files <- files[vapply(
    files,
    is_in_published_dir,
    logical(1),
    root = p(source_root, "modules"),
    published_dirs = setdiff(published_module_dirs, "00_preclass-tech-check")
  )]
  files[order(files)]
}

render_module_qmds <- function() {
  for (qmd_file in module_qmd_files()) {
    render_file(qmd_file)
  }
}

render_markdowns_in <- function(directory) {
  markdown_files <- list.files(directory, pattern = "[.]md$", full.names = TRUE)

  for (markdown_file in markdown_files) {
    render_file(markdown_file)
  }
}

html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x
}

copy_rendered_module_html <- function() {
  qmd_files <- module_qmd_files()

  for (qmd_file in qmd_files) {
    relative_qmd <- substring(qmd_file, nchar(p(source_root, "modules")) + 2)
    relative_html <- sub("[.]qmd$", ".html", relative_qmd)
    rendered_file <- p(source_root, "docs", "modules", relative_html)
    target_file <- p(target_root, "modules", "rendered", relative_html)

    if (!is_file(rendered_file)) {
      stop(
        "Missing rendered module file: ", rendered_file,
        ". Render the matching module .qmd before building the student repo.",
        call. = FALSE
      )
    }

    copy_file(rendered_file, target_file)
  }
}

write_rendered_modules_index <- function() {
  qmd_files <- module_qmd_files()
  relative_qmds <- substring(qmd_files, nchar(p(source_root, "modules")) + 2)
  relative_html <- sub("[.]qmd$", ".html", relative_qmds)
  labels <- sub("[.]qmd$", "", relative_qmds)
  labels <- gsub("[-_]", " ", labels)

  links <- paste0(
    "  <li><a href=\"", html_escape(relative_html), "\">",
    html_escape(labels),
    "</a></li>"
  )

  write_lines(
    p(target_root, "modules", "rendered", "index.html"),
    c(
      "<!doctype html>",
      "<html lang=\"en\">",
      "<head>",
      "  <meta charset=\"utf-8\">",
      "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
      "  <title>Rendered Module Notebooks</title>",
      "  <style>body{font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;line-height:1.5;max-width:900px;margin:3rem auto;padding:0 1.25rem;}li{margin:0.35rem 0;}code{background:#f3f4f6;padding:0.1rem 0.25rem;border-radius:0.2rem;}</style>",
      "</head>",
      "<body>",
      "  <h1>Rendered Module Notebooks</h1>",
      "  <p>These are HTML versions of the class module notebooks. Use the other folders in <code>modules/</code> when you want to open and run the course-owned Quarto notebooks.</p>",
      "  <ul>",
      links,
      "  </ul>",
      "</body>",
      "</html>"
    )
  )
}

source_notice <- function(codebook_id) {
  if (grepl("^simulated_", codebook_id)) {
    return(list(
      source_label = "Simulated teaching dataset",
      source_url = NA_character_,
      detail = "This is a simulated analog created for classroom use. It has no real-world source and must never be used as evidence."
    ))
  }

  if (codebook_id %in% c("data_manifest", "simulated_dataset_crosswalk")) {
    return(list(
      source_label = "Course metadata",
      source_url = NA_character_,
      detail = "This metadata file was generated for course navigation and classroom use only."
    ))
  }

  if (grepl("^prams", codebook_id)) {
    return(list(
      source_label = "CDC PRAMS",
      source_url = "https://www.cdc.gov/prams/index.html",
      detail = "This course file was processed and simplified from PRAMS-related teaching materials."
    ))
  }

  if (grepl("^nhanes_", codebook_id)) {
    return(list(
      source_label = "CDC/NCHS NHANES",
      source_url = "https://www.cdc.gov/nchs/nhanes/index.html",
      detail = "This course file was processed and simplified from selected public-use NHANES files. It does not preserve the full survey-analysis workflow."
    ))
  }

  if (grepl("^epa_air_quality", codebook_id)) {
    return(list(
      source_label = "EPA Air Quality in Cities and Counties",
      source_url = "https://www.epa.gov/air-trends/air-quality-cities-and-counties",
      detail = "This course file was processed and simplified from EPA county air-quality teaching extracts."
    ))
  }

  if (grepl("^places_", codebook_id)) {
    return(list(
      source_label = "CDC PLACES",
      source_url = "https://www.cdc.gov/places/",
      detail = "This course file was processed and simplified from CDC PLACES area-level estimates."
    ))
  }

  if (grepl("^flu_vaccination", codebook_id)) {
    return(list(
      source_label = "CDC FluVaxView",
      source_url = "https://www.cdc.gov/flu/fluvaxview/",
      detail = "This course file was processed and simplified from flu vaccination coverage teaching materials."
    ))
  }

  if (grepl("^census_|^state_population|^state_race", codebook_id)) {
    return(list(
      source_label = "U.S. Census 2020",
      source_url = "https://www.census.gov/programs-surveys/decennial-census/decade/2020.html",
      detail = "This course file was processed and simplified from Census-related teaching materials."
    ))
  }

  fox_ids <- c(
    "davis_height_weight",
    "migraine_headache_diary",
    "titanic_passengers",
    "infant_mortality_countries",
    "ginzberg_depression",
    "exercise_eating_disorders",
    "post_coma_recovery"
  )

  if (codebook_id %in% fox_ids) {
    return(list(
      source_label = "John Fox Applied Regression data archive",
      source_url = "https://www.john-fox.ca/AppliedRegression/datasets/index.html",
      detail = "This course file was processed and simplified from the John Fox teaching data archive."
    ))
  }

  list(
    source_label = "Course teaching data",
    source_url = NA_character_,
    detail = "This course file was processed and simplified for classroom use."
  )
}

teaching_notice_html <- function(codebook_id) {
  notice <- source_notice(codebook_id)

  source_text <- if (is.na(notice$source_url)) {
    html_escape(notice$source_label)
  } else {
    paste0(
      "<a href=\"", html_escape(notice$source_url), "\">",
      html_escape(notice$source_label),
      "</a>"
    )
  }

  paste0(
    "\n<div class=\"callout-important\" style=\"border-left: 4px solid #b00020; padding: 0.75rem 1rem; margin: 1rem 0; background: #fff5f5;\">\n",
    "<p><strong>Teaching-use warning:</strong> This dataset has been modified for teaching. It should never be used for research, publication, clinical decisions, policy decisions, or official reporting. Use the original source data and documentation for any research purpose.</p>\n",
    "<p><strong>Source/context:</strong> ", source_text, ". ", html_escape(notice$detail), "</p>\n",
    "</div>\n"
  )
}

annotate_codebook_html <- function(path) {
  codebook_id <- sub("[.]html$", "", basename(path))
  html <- paste(readLines(path, warn = FALSE), collapse = "\n")
  notice <- teaching_notice_html(codebook_id)

  if (grepl("teaching-use warning", html, fixed = TRUE)) {
    return(invisible(NULL))
  }

  if (grepl("<h1[^>]*>.*?</h1>", html, perl = TRUE)) {
    html <- sub("(<h1[^>]*>.*?</h1>)", paste0("\\1", notice), html, perl = TRUE)
  } else {
    html <- sub("(<body[^>]*>)", paste0("\\1", notice), html, perl = TRUE)
  }

  writeLines(html, path)
}

annotate_rendered_codebooks <- function(directory) {
  html_files <- list.files(directory, pattern = "[.]html$", full.names = TRUE)

  for (html_file in html_files) {
    annotate_codebook_html(html_file)
  }
}

link_path_from_data_root <- function(path) {
  sub("^data/", "", path)
}

html_codebook_path <- function(path) {
  sub("[.]md$", ".html", path)
}

markdown_escape <- function(x) {
  x <- ifelse(is.na(x) | x == "", "", x)
  x <- gsub("\\|", "\\\\|", x)
  x
}

markdown_link <- function(label, path) {
  ifelse(
    is.na(path) | path == "",
    "",
    paste0("[", markdown_escape(label), "](", link_path_from_data_root(path), ")")
  )
}

topic_key_measures <- function(topic) {
  measures <- c(
    "measured vs self-reported exercise minutes" = "measured and reported values; BMI or totals; reporting errors and missing-report flags",
    "toothache diary" = "person-day, day, treatment/medication condition, reported symptom outcome",
    "fictional boat passenger survival" = "survival, age, class, sex, and missing-age flag",
    "rural health indicators" = "income, mortality rate, region, and oil-exporter status",
    "stress beliefs survey" = "simplicity, fatalism, depression, and adjusted scale scores",
    "physical therapy activity" = "age, activity hours, subject/group, and repeated observations",
    "injury recovery follow-up" = "days since injury, injury duration, age, sex, and performance/verbal scores",
    "neighborhood health survey demographics" = "age, age group, gender, race/ethnicity, income-to-poverty, and survey design variables",
    "neighborhood blood pressure screening" = "systolic, diastolic, pulse readings, reading means, arm, and cuff size",
    "neighborhood hepatitis A antibody status" = "participant ID and hepatitis A antibody result/status",
    "neighborhood dietary food records" = "food-level recalls, eating occasion, food source, energy, nutrients, and recall day",
    "neighborhood dietary daily summary" = "daily energy, sugars, sodium, nutrients, recall day, and recall quality fields",
    "neighborhood dietary person summary" = "person-level mean daily energy, sugars, sodium, recall-day totals, and number of recall days",
    "joined neighborhood health survey" = "demographics, dietary summaries, blood pressure means/categories, and hepatitis A status",
    "new-parent wellness subgroup estimates" = "state/subgroup percentages for depression, anxiety, binge drinking, and alcohol use",
    "new-parent wellness state overall wide" = "state-level overall percentages for depression, anxiety, binge drinking, and alcohol use",
    "new-parent wellness previous births wide" = "state percentages by previous-live-birth categories and wellness indicators",
    "respiratory booster coverage" = "season, month, geography, age group, coverage estimate, confidence interval, and sample size",
    "respiratory booster age-month wide" = "age group by month coverage estimates in wide format",
    "respiratory booster national age-season wide" = "national age-group coverage estimates by flu season in wide format",
    "state school enrollment groups long" = "state, rank, total population, race/ethnicity group count, and share",
    "state school enrollment groups wide" = "state-level race/ethnicity group counts and shares in wide format",
    "state enrollment ranks" = "state, state name, population rank, and total population",
    "state enrollment group summary" = "state population totals and race/ethnicity group summaries",
    "county wellness indicators long" = "county, population, PLACES measure, estimate, and confidence interval",
    "county wellness indicators wide" = "county population plus PLACES measure estimates in wide format",
    "metro neighborhood wellness indicators long" = "tract/county geography, PLACES measure, estimate, confidence interval, and coordinates",
    "county noise exposure long" = "county, pollutant, statistic, unit, value, status, standard, and exceedance flag",
    "county noise exposure wide" = "county-level pollutant metric values and reporting-status fields in wide format",
    "data directory manifest" = "dataset paths, rows, measures, codebooks, dataset kind, pairing ID, and simulated analog links",
    "real-to-simulated dataset crosswalk" = "real dataset path, simulated analog path, and pairing topic"
  )

  ifelse(
    topic %in% names(measures),
    paste0(topic, "; ", unname(measures[topic])),
    topic
  )
}

write_manifest_table <- function(df) {
  lines <- c(
    "| Dataset | Rows | Measures | Codebook | Topic & Key measures |",
    "|---|---:|---:|---|---|"
  )

  for (i in seq_len(nrow(df))) {
    file_label <- basename(df$file_path[[i]])
    codebook_path <- html_codebook_path(df$codebook_path[[i]])

    lines <- c(
      lines,
      paste0(
        "| ", markdown_link(file_label, df$file_path[[i]]),
        " | ", df$n_rows[[i]],
        " | ", df$n_columns[[i]],
        " | ", markdown_link("Codebook", codebook_path),
        " | ", markdown_escape(topic_key_measures(df$analog_topic[[i]])),
        " |"
      )
    )
  }

  lines
}

write_data_index_markdown <- function() {
  manifest <- read.csv(p(source_root, "data", "manifest.csv"), stringsAsFactors = FALSE)

  metadata <- manifest[manifest$dataset_kind == "metadata", ]
  real <- manifest[manifest$dataset_kind == "real", ]
  simulated <- manifest[manifest$dataset_kind == "simulated", ]

  lines <- c(
    "---",
    "title: \"Course Data\"",
    "format:",
    "  html:",
    "    toc: true",
    "    embed-resources: true",
    "---",
    "",
    "This page links to the datasets, rendered codebooks, and simulated analogs used in the course.",
    "",
    "> **Teaching-use warning:** These datasets have been modified or generated for teaching. They should never be used for research, publication, clinical decisions, policy decisions, or official reporting. Use the original source data and documentation for any research purpose.",
    "",
    "Open this file from the course project at `data/data.html`.",
    "",
    "# Quick Links",
    "",
    "- [Dataset manifest with paired dataset paths](manifest.csv)",
    "- [Simulated dataset crosswalk for real/simulated pairs](simulated/simulated_dataset_crosswalk.csv)",
    "- [Codebook folder](codebooks/)",
    "",
    "# Real Datasets",
    "",
    write_manifest_table(real),
    "",
    "# Simulated Analog Datasets",
    "",
    write_manifest_table(simulated),
    "",
    "# Metadata Files",
    "",
    write_manifest_table(metadata),
    "",
    "# Dataset Notes",
    "",
    "- [PRAMS selected data](real/prams_2011_selected.csv) are pre-aggregated state/subgroup estimates, not person-level records. Original source/context: [CDC PRAMS](https://www.cdc.gov/prams/index.html). Start with the [PRAMS codebook](codebooks/prams_2011_selected.html).",
    "- [Census race/ethnicity data](real/census_state_race_ethnicity_long.csv) are state-level counts and shares. The `share` denominator is the sum of the included race/ethnicity categories in the file; see the [Census long codebook](codebooks/census_state_race_ethnicity_long.html).",
    "- [Flu vaccination data](real/flu_vaccination_age_time_clean.csv) are useful for change over time and age-group comparisons. Check the [flu vaccination codebook](codebooks/flu_vaccination_age_time_clean.html) before interpreting time trends.",
    "- [NHANES analysis data](real/nhanes_2021_2023_analysis.csv) are simplified teaching files from a complex survey. Original source/context: [CDC/NCHS NHANES](https://www.cdc.gov/nchs/nhanes/index.html). Treat plots as exploratory sample visualizations, not national estimates; see the [NHANES analysis codebook](codebooks/nhanes_2021_2023_analysis.html).",
    "- [NHANES dietary data](real/nhanes_2021_2023_dietary_foods.csv) are long food-record data, while [NHANES dietary person summaries](real/nhanes_2021_2023_dietary_person_summary.csv) are derived summaries. Original source/context: [CDC/NCHS NHANES](https://www.cdc.gov/nchs/nhanes/index.html). See the [dietary foods codebook](codebooks/nhanes_2021_2023_dietary_foods.html) and [dietary person summary codebook](codebooks/nhanes_2021_2023_dietary_person_summary.html).",
    "- [PLACES county data](real/places_county_core_measures_long.csv) and [PLACES tract data](real/places_tract_dc_md_va_core_measures_long.csv) are area-level estimates, not person-level observations. See the [PLACES county codebook](codebooks/places_county_core_measures_long.html) and [PLACES tract codebook](codebooks/places_tract_dc_md_va_core_measures_long.html).",
    "- [EPA air quality data](real/epa_air_quality_county_2025_long.csv) summarize monitored county pollutant information. Original source/context: [EPA Air Quality in Cities and Counties](https://www.epa.gov/air-trends/air-quality-cities-and-counties). Missing numeric values can reflect no data or insufficient data; see the [EPA air quality codebook](codebooks/epa_air_quality_county_2025_long.html).",
    "- John Fox teaching datasets, including Titanic, migraine, depression, eating-disorder exercise, and recovery examples, are useful small teaching datasets. Original source/context: [John Fox Applied Regression data archive](https://www.john-fox.ca/AppliedRegression/datasets/index.html). Some topics are sensitive; use respectful language and check the linked codebooks before plotting.",
    "- Real and simulated paired datasets have matching column names. Use the [dataset manifest](manifest.csv) or [simulated dataset crosswalk](simulated/simulated_dataset_crosswalk.csv) to find pairs."
  )

  write_lines(p(source_root, "data", "data.md"), lines)
}

rewrite_student_manifest_codebooks <- function(path) {
  manifest_lines <- readLines(path, warn = FALSE)
  manifest_lines <- gsub("data/codebooks/([^,]+)[.]md", "data/codebooks/\\1.html", manifest_lines)
  writeLines(manifest_lines, path)
}

render_file(p("course_docs", "syllabus.qmd"))
render_qmds_in("assignments")
render_slide_qmds()
render_module_qmds()
render_markdowns_in(p("data", "codebooks"))
annotate_rendered_codebooks(p(source_root, "docs", "data", "codebooks"))
write_data_index_markdown()
render_file(p("data", "data.md"))

dir_create(target_root)

for (managed_path in managed_paths) {
  destination <- p(target_root, managed_path)

  if (file.exists(destination)) {
    unlink(destination, recursive = TRUE, force = TRUE)
  }
}

copy_clean_dir(
  p(source_root, "data"),
  p(target_root, "data"),
  extra_skip = function(path) is_codebook_markdown(path) || is_rendered_data_source_markdown(path)
)
copy_clean_dir(
  p(source_root, "modules"),
  p(target_root, "modules"),
  extra_skip = function(path) {
    !is_in_published_dir(path, p(source_root, "modules"), published_module_dirs)
  }
)
copy_clean_dir(
  p(source_root, "practice"),
  p(target_root, "practice", "templates"),
  extra_skip = function(path) {
    !is_in_published_dir(path, p(source_root, "practice"), published_practice_dirs)
  }
)
rewrite_practice_here_paths(p(target_root, "practice", "templates"))
copy_rendered_module_html()
write_rendered_modules_index()
copy_rendered_html_for_sources(
  p(source_root, "slides"),
  p(source_root, "docs", "slides"),
  p(target_root, "slides"),
  source_files = slide_qmd_files()
)
copy_rendered_html_for_sources(
  p(source_root, "assignments"),
  p(source_root, "docs", "assignments"),
  p(target_root, "assignments")
)
copy_rendered_html_for_sources(
  p(source_root, "data", "codebooks"),
  p(source_root, "docs", "data", "codebooks"),
  p(target_root, "data", "codebooks"),
  source_pattern = "[.]md$"
)
copy_rendered_html_file(
  p(source_root, "docs", "data", "data.html"),
  p(target_root, "data", "data.html")
)

rewrite_student_manifest_codebooks(p(target_root, "data", "manifest.csv"))

syllabus_html <- p(source_root, "docs", "course_docs", "syllabus.html")

if (!is_file(syllabus_html)) {
  stop(
    "Missing rendered syllabus: docs/course_docs/syllabus.html. Render course_docs/syllabus.qmd first.",
    call. = FALSE
  )
}

copy_file(syllabus_html, p(target_root, "syllabus.html"))

write_lines(
  p(target_root, "_quarto.yml"),
  c(
    "project:",
    "  type: default",
    "  output-dir: docs",
    "  execute-dir: project",
    "",
    "format:",
    "  html:",
    "    theme: default",
    "    toc: true",
    "    toc-depth: 3",
    "    embed-resources: true",
    "    highlight-style: github"
  )
)

write_lines(
  p(target_root, ".gitignore"),
  c(
    ".DS_Store",
    ".Rhistory",
    ".RData",
    ".Ruserdata",
    ".Rproj.user/",
    ".quarto/",
    "docs/",
    "_freeze/",
    "*_cache/",
    "*_files/",
    "*.knit.md",
    "*.utf8.md",
    "practice/work/*",
    "!practice/work/",
    "!practice/work/README.md"
  )
)

write_lines(
  p(target_root, "practice", "work", "README.md"),
  c(
    "# Practice Work",
    "",
    "This is your workspace for practice notebooks.",
    "",
    "Run this from the project root to update course files and copy any new practice templates into this folder without overwriting existing files:",
    "",
    "```r",
    "source(\"updater.R\")",
    "```",
    "",
    "Files in this folder are ignored by Git so your edits and rendered work do not conflict with course updates."
  )
)

write_lines(
  p(target_root, "data-visualization-course.Rproj"),
  c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: No",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: No",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX"
  )
)

write_lines(
  p(target_root, "data-visualization-course.code-workspace"),
  c(
    "{",
    "\t\"folders\": [",
    "\t\t{",
    "\t\t\t\"path\": \".\"",
    "\t\t}",
    "\t],",
    "\t\"settings\": {}",
    "}"
  )
)

copy_file(student_readme, p(target_root, "README.md"))
copy_file(student_updater, p(target_root, "updater.R"))

validate_manifest_paths(export_manifest$must_exist_after_export, should_exist = TRUE)
validate_manifest_paths(export_manifest$must_not_exist_after_export, should_exist = FALSE)

message("Student repository built at: ", target_root)
message("Published days: ", paste(published_days, collapse = ", "))
