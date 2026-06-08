course_packages <- c(
  "dplyr",
  "ggplot2",
  "knitr",
  "readr",
  "rmarkdown",
  "stringr",
  "tibble",
  "tidyr"
)

installed_packages <- rownames(installed.packages())
missing_packages <- setdiff(course_packages, installed_packages)

if (length(missing_packages) == 0) {
  message("All course packages are already installed.")
} else {
  message("Installing missing course packages: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages)
}

message("Course package check complete.")
