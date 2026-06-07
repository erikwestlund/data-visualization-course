# Update course materials and copy practice templates into your work folder.
#
# Run from the project root:
#   source("updater.R")
#
# What this does:
# 1. If this folder is a Git clone, run `git pull --ff-only`.
# 2. Copy missing files from practice/templates/ to practice/work/.
# 3. Leave existing files in practice/work/ alone.
#
# Git updates instructor-owned course files. That means files in folders such as
# modules/, slides/, assignments/, data/, and practice/templates/ may be added,
# changed, renamed, or removed. Your own practice files belong in practice/work/.

run_git_pull <- function(project_root) {
  git_available <- nzchar(Sys.which("git"))

  if (!git_available) {
    message("Git is not available on this computer. Skipping Git update.")
    return(invisible(FALSE))
  }

  inside_work_tree <- suppressWarnings(system2(
    "git",
    c("rev-parse", "--is-inside-work-tree"),
    stdout = TRUE,
    stderr = TRUE
  ))

  if (!identical(trimws(inside_work_tree[[1]]), "true")) {
    message("This folder is not a Git clone. Skipping Git update.")
    return(invisible(FALSE))
  }

  message("Updating instructor-owned course files with git pull --ff-only...")
  message("Course files may be added, changed, renamed, or removed. Files in practice/work/ are left alone by this script.")

  output <- suppressWarnings(system2(
    "git",
    c("pull", "--ff-only"),
    stdout = TRUE,
    stderr = TRUE
  ))
  status <- attr(output, "status")

  if (!is.null(status) && !identical(status, 0L)) {
    cat(output, sep = "\n")
    stop(
      "Git update failed. Your practice/work files are safe, but ask for help before continuing.",
      call. = FALSE
    )
  }

  if (length(output) > 0) {
    message(paste(output, collapse = "\n"))
  }

  invisible(TRUE)
}

copy_practice_templates <- function(overwrite = FALSE) {
  project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  templates_dir <- file.path(project_root, "practice", "templates")
  work_dir <- file.path(project_root, "practice", "work")

  if (!dir.exists(templates_dir)) {
    stop("Could not find practice/templates/. Are you running this from the course project root?", call. = FALSE)
  }

  dir.create(work_dir, recursive = TRUE, showWarnings = FALSE)

  template_files <- list.files(
    templates_dir,
    recursive = TRUE,
    full.names = TRUE,
    all.files = TRUE,
    no.. = TRUE
  )

  template_files <- template_files[!dir.exists(template_files)]
  template_files <- template_files[!grepl("(^|/)\\.DS_Store$", template_files)]
  template_files <- template_files[!grepl("(^|/)\\.gitkeep$", template_files)]

  copied <- character()
  skipped <- character()

  for (template_file in template_files) {
    relative_path <- substring(template_file, nchar(templates_dir) + 2)
    destination <- file.path(work_dir, relative_path)

    if (file.exists(destination) && !overwrite) {
      skipped <- c(skipped, relative_path)
      next
    }

    dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)

    if (grepl("[.]qmd$", template_file)) {
      lines <- readLines(template_file, warn = FALSE)
      template_here_path <- file.path("practice", "templates", relative_path)
      work_here_path <- file.path("practice", "work", relative_path)
      lines <- gsub(template_here_path, work_here_path, lines, fixed = TRUE)
      writeLines(lines, destination)
    } else {
      file.copy(template_file, destination, overwrite = TRUE, copy.date = TRUE)
    }

    copied <- c(copied, relative_path)
  }

  message("Practice update complete.")
  message("Copied new files: ", length(copied))
  message("Skipped existing files: ", length(skipped))

  if (length(copied) > 0) {
    message("\nNew files copied to practice/work/:")
    message(paste0("- ", copied, collapse = "\n"))
  }

  if (length(skipped) > 0) {
    message("\nExisting files were left alone:")
    message(paste0("- ", skipped, collapse = "\n"))
  }

  invisible(list(copied = copied, skipped = skipped))
}

project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)

run_git_pull(project_root)
copy_practice_templates()
