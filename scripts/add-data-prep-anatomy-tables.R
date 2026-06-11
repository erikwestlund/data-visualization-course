# Add data-preparation anatomy tables before dplyr/tidyr code chunks in modules.

annotation_start <- "<!-- data-prep-anatomy-start -->"
annotation_end <- "<!-- data-prep-anatomy-end -->"
style_start <- "<!-- data-prep-anatomy-style-start -->"
style_end <- "<!-- data-prep-anatomy-style-end -->"

target_dirs <- c("modules")

qmd_files <- unlist(lapply(target_dirs, function(directory) {
  list.files(directory, pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE)
}), use.names = FALSE)

function_groups <- list(
  `Inspect data` = c("glimpse"),
  `Keep or remove rows` = c("filter", "slice_head", "slice_max", "distinct"),
  `Choose or rename columns` = c("select", "rename", "everything"),
  `Create or change columns` = c("mutate", "transmute", "case_when", "if_else"),
  `Count or summarize` = c("count", "group_by", "summarize", "summarise", "n", "n_distinct", "ungroup"),
  `Sort rows` = c("arrange", "desc"),
  `Combine data frames` = c("left_join", "inner_join", "right_join", "full_join", "bind_rows"),
  `Reshape data` = c("pivot_longer", "pivot_wider")
)

all_functions <- unique(unlist(function_groups, use.names = FALSE))
trivial_display_functions <- c("glimpse", "select", "rename", "everything")

trim_inline <- function(x) {
  x <- gsub("[[:space:]]+", " ", x)
  trimws(x)
}

escape_table_cell <- function(x) {
  gsub("\\|", "\\\\|", x)
}

format_functions <- function(functions) {
  functions <- unique(trim_inline(functions[nzchar(trimws(functions))]))
  escape_table_cell(paste(sprintf("`%s()`", functions), collapse = "; "))
}

collapse_blank_lines <- function(lines, max_blank = 1L) {
  out <- character()
  blank_count <- 0L

  for (line in lines) {
    if (!nzchar(line)) {
      blank_count <- blank_count + 1L

      if (blank_count <= max_blank) {
        out <- c(out, line)
      }
    } else {
      blank_count <- 0L
      out <- c(out, line)
    }
  }

  out
}

find_data_prep_functions <- function(code) {
  pattern <- paste0(
    "(?<![A-Za-z0-9_.:])(?:(?:dplyr|tidyr)::)?(",
    paste(all_functions, collapse = "|"),
    ")\\s*\\("
  )

  matches <- gregexpr(pattern, code, perl = TRUE)[[1]]

  if (length(matches) == 1L && matches[[1]] == -1L) {
    return(character())
  }

  values <- regmatches(code, list(matches))[[1]]
  values <- sub("^.*::", "", values)
  values <- sub("\\s*\\($", "", values)
  unique(trimws(values))
}

data_prep_anatomy_table <- function(chunk_lines) {
  code <- paste(chunk_lines, collapse = "\n")
  functions_used <- find_data_prep_functions(code)
  rows <- character()

  for (group_name in names(function_groups)) {
    group_functions <- intersect(function_groups[[group_name]], functions_used)

    if (length(group_functions) > 0) {
      rows <- c(rows, paste0("| ", group_name, " | ", format_functions(group_functions), " |"))
    }
  }

  c(
    annotation_start,
    "::: {.data-prep-anatomy}",
    "| Data preparation step | Functions in this chunk |",
    "|---|---|",
    rows,
    ":::",
    annotation_end
  )
}

data_prep_anatomy_style <- function() {
  c(
    style_start,
    "```{=html}",
    "<style>",
    ".data-prep-anatomy {",
    "  font-size: 0.9em;",
    "  line-height: 1.25;",
    "}",
    ".data-prep-anatomy p {",
    "  margin-bottom: 0.25rem;",
    "}",
    ".data-prep-anatomy table {",
    "  margin-top: 0.25rem;",
    "  margin-bottom: 0.75rem;",
    "}",
    ".data-prep-anatomy table th,",
    ".data-prep-anatomy table td {",
    "  padding: 0.25rem 0.4rem;",
    "}",
    "</style>",
    "```",
    style_end
  )
}

remove_existing_annotations <- function(lines) {
  out <- character()
  skipping <- FALSE

  for (line in lines) {
    if (identical(line, annotation_start) || identical(line, style_start)) {
      skipping <- TRUE
      next
    }

    if (skipping && (identical(line, annotation_end) || identical(line, style_end))) {
      skipping <- FALSE
      next
    }

    if (!skipping) {
      out <- c(out, line)
    }
  }

  out
}

insert_data_prep_anatomy_style <- function(lines) {
  if (length(lines) >= 2L && identical(lines[[1]], "---")) {
    yaml_end_candidates <- which(lines[-1] == "---")

    if (length(yaml_end_candidates) == 0) {
      return(c(data_prep_anatomy_style(), "", lines))
    }

    yaml_end <- yaml_end_candidates[[1]] + 1L
    remainder <- character()

    if (yaml_end < length(lines)) {
      remainder <- lines[seq.int(yaml_end + 1L, length(lines))]
    }

    return(c(
      lines[seq_len(yaml_end)],
      "",
      data_prep_anatomy_style(),
      remainder
    ))
  }

  c(data_prep_anatomy_style(), "", lines)
}

is_data_prep_chunk <- function(chunk_lines) {
  functions_used <- find_data_prep_functions(paste(chunk_lines, collapse = "\n"))

  length(functions_used) > 0 && !all(functions_used %in% trivial_display_functions)
}

is_eval_false_chunk <- function(chunk_lines) {
  any(grepl("#\\|[[:space:]]*eval:[[:space:]]*false", chunk_lines))
}

append_before_trailing_plot_anatomy <- function(lines, new_lines) {
  trailing_blank_count <- 0L

  for (i in rev(seq_along(lines))) {
    if (nzchar(lines[[i]])) {
      break
    }

    trailing_blank_count <- trailing_blank_count + 1L
  }

  content_end <- length(lines) - trailing_blank_count

  if (content_end <= 0 || !identical(lines[[content_end]], "<!-- plot-anatomy-end -->")) {
    return(c(lines, new_lines))
  }

  plot_start_candidates <- which(lines[seq_len(content_end)] == "<!-- plot-anatomy-start -->")

  if (length(plot_start_candidates) == 0) {
    return(c(lines, new_lines))
  }

  plot_start <- plot_start_candidates[[length(plot_start_candidates)]]
  prefix <- character()

  if (plot_start > 1L) {
    prefix <- lines[seq_len(plot_start - 1L)]
  }

  plot_block <- lines[seq.int(plot_start, content_end)]
  trailing_blanks <- character()

  if (trailing_blank_count > 0) {
    trailing_blanks <- lines[seq.int(content_end + 1L, length(lines))]
  }

  c(prefix, new_lines, "", plot_block, trailing_blanks)
}

annotate_file <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lines <- remove_existing_annotations(lines)

  out <- character()
  in_r_chunk <- FALSE
  chunk_lines <- character()
  inserted <- 0L

  for (line in lines) {
    if (!in_r_chunk && grepl("^```\\{r", line)) {
      in_r_chunk <- TRUE
      chunk_lines <- line
      next
    }

    if (in_r_chunk) {
      chunk_lines <- c(chunk_lines, line)

      if (grepl("^```[[:space:]]*$", line)) {
        body <- chunk_lines[-c(1, length(chunk_lines))]

        if (is_data_prep_chunk(body) && !is_eval_false_chunk(body)) {
          out <- append_before_trailing_plot_anatomy(out, data_prep_anatomy_table(body))
          out <- c(out, "", chunk_lines)
          inserted <- inserted + 1L
        } else {
          out <- c(out, chunk_lines)
        }

        in_r_chunk <- FALSE
        chunk_lines <- character()
      }

      next
    }

    out <- c(out, line)
  }

  out <- collapse_blank_lines(out)

  if (!identical(lines, out)) {
    writeLines(out, path, useBytes = TRUE)
  }

  inserted
}

is_direct_rscript_run <- any(grepl("^--file=", commandArgs(trailingOnly = FALSE)))

if (is_direct_rscript_run) {
  counts <- vapply(qmd_files, annotate_file, integer(1))
  total <- sum(counts)

  message("Inserted data-preparation anatomy tables before ", total, " code chunks in ", sum(counts > 0), " files.")

  if (total > 0) {
    print(data.frame(file = names(counts[counts > 0]), tables = as.integer(counts[counts > 0])), row.names = FALSE)
  }
}
