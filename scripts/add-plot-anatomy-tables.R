# Add plot-anatomy tables before plotting code chunks in modules.

annotation_start <- "<!-- plot-anatomy-start -->"
annotation_end <- "<!-- plot-anatomy-end -->"
style_start <- "<!-- plot-anatomy-style-start -->"
style_end <- "<!-- plot-anatomy-style-end -->"

target_dirs <- c("modules")

qmd_files <- unlist(lapply(target_dirs, function(directory) {
  list.files(directory, pattern = "[.]qmd$", recursive = TRUE, full.names = TRUE)
}), use.names = FALSE)

trim_inline <- function(x) {
  x <- gsub("[[:space:]]+", " ", x)
  trimws(x)
}

escape_table_cell <- function(x) {
  x <- gsub("\\|", "\\\\|", x)
  x
}

format_items <- function(items) {
  items <- unique(trim_inline(items[nzchar(trimws(items))]))
  items <- items[!items %in% c("()", "``")]

  if (length(items) == 0) {
    return("none")
  }

  escape_table_cell(paste(sprintf("`%s`", items), collapse = "; "))
}

has_items <- function(items) {
  items <- trim_inline(items[nzchar(trimws(items))])
  length(items[!items %in% c("()", "``")]) > 0
}

split_top_level_args <- function(text) {
  args <- character()
  start <- 1L
  depth <- 0L
  in_single <- FALSE
  in_double <- FALSE
  escaped <- FALSE

  if (!nzchar(text)) {
    return(character())
  }

  for (pos in seq_len(nchar(text))) {
    char <- substr(text, pos, pos)

    if (escaped) {
      escaped <- FALSE
      next
    }

    if (char == "\\") {
      escaped <- TRUE
      next
    }

    if (!in_double && char == "'") {
      in_single <- !in_single
      next
    }

    if (!in_single && char == '"') {
      in_double <- !in_double
      next
    }

    if (in_single || in_double) {
      next
    }

    if (char %in% c("(", "[", "{")) {
      depth <- depth + 1L
    } else if (char %in% c(")", "]", "}")) {
      depth <- depth - 1L
    } else if (char == "," && depth == 0L) {
      args <- c(args, substr(text, start, pos - 1L))
      start <- pos + 1L
    }
  }

  args <- c(args, substr(text, start, nchar(text)))
  trimws(args[nzchar(trimws(args))])
}

extract_arg_names <- function(call, positional_names = character()) {
  args <- split_top_level_args(call_inside(call))

  vapply(seq_along(args), function(i) {
    arg <- args[[i]]

    if (grepl("^[A-Za-z.][A-Za-z0-9_.]*\\s*=", arg)) {
      return(trimws(sub("\\s*=.*$", "", arg)))
    }

    if (i <= length(positional_names)) {
      return(positional_names[[i]])
    }

    ""
  }, character(1))
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

find_balanced_calls <- function(code, call_name) {
  pattern <- paste0("(?<![A-Za-z0-9_.])", call_name, "\\s*\\(")
  starts <- gregexpr(pattern, code, perl = TRUE)[[1]]

  if (length(starts) == 1L && starts[[1]] == -1L) {
    return(character())
  }

  matches <- attr(starts, "match.length")
  out <- character()

  for (i in seq_along(starts)) {
    open_pos <- starts[[i]] + matches[[i]] - 1
    depth <- 0L
    in_single <- FALSE
    in_double <- FALSE
    escaped <- FALSE

    for (pos in seq(open_pos, nchar(code))) {
      char <- substr(code, pos, pos)

      if (escaped) {
        escaped <- FALSE
        next
      }

      if (char == "\\") {
        escaped <- TRUE
        next
      }

      if (!in_double && char == "'") {
        in_single <- !in_single
        next
      }

      if (!in_single && char == '"') {
        in_double <- !in_double
        next
      }

      if (in_single || in_double) {
        next
      }

      if (char == "(") {
        depth <- depth + 1L
      } else if (char == ")") {
        depth <- depth - 1L

        if (depth == 0L) {
          out <- c(out, substr(code, starts[[i]], pos))
          break
        }
      }
    }
  }

  out
}

call_inside <- function(call) {
  sub("^[^(]*\\(", "", sub("\\)$", "", call))
}

remove_balanced_calls <- function(code, call_name) {
  calls <- find_balanced_calls(code, call_name)

  for (call in calls) {
    code <- sub(call, "", code, fixed = TRUE)
  }

  code
}

find_function_names <- function(code, prefix_regex) {
  regex <- paste0("(?<![A-Za-z0-9_.])", prefix_regex, "\\s*\\(")
  matches <- gregexpr(regex, code, perl = TRUE)[[1]]

  if (length(matches) == 1L && matches[[1]] == -1L) {
    return(character())
  }

  values <- regmatches(code, list(matches))[[1]]
  values <- sub("\\s*\\($", "", values)
  values <- trimws(values)
  unique(values)
}

find_balanced_prefixed_calls <- function(code, prefix_regex) {
  regex <- paste0("(?<![A-Za-z0-9_.])", prefix_regex, "\\s*\\(")
  starts <- gregexpr(regex, code, perl = TRUE)[[1]]

  if (length(starts) == 1L && starts[[1]] == -1L) {
    return(data.frame(name = character(), call = character()))
  }

  matches <- attr(starts, "match.length")
  names <- character()
  calls <- character()

  for (i in seq_along(starts)) {
    open_pos <- starts[[i]] + matches[[i]] - 1L
    call_name <- trimws(sub("\\s*\\($", "", substr(code, starts[[i]], open_pos)))
    depth <- 0L
    in_single <- FALSE
    in_double <- FALSE
    escaped <- FALSE

    for (pos in seq(open_pos, nchar(code))) {
      char <- substr(code, pos, pos)

      if (escaped) {
        escaped <- FALSE
        next
      }

      if (char == "\\") {
        escaped <- TRUE
        next
      }

      if (!in_double && char == "'") {
        in_single <- !in_single
        next
      }

      if (!in_single && char == '"') {
        in_double <- !in_double
        next
      }

      if (in_single || in_double) {
        next
      }

      if (char == "(") {
        depth <- depth + 1L
      } else if (char == ")") {
        depth <- depth - 1L

        if (depth == 0L) {
          names <- c(names, call_name)
          calls <- c(calls, substr(code, starts[[i]], pos))
          break
        }
      }
    }
  }

  data.frame(name = names, call = calls)
}

calls_without <- function(code, call_names) {
  for (call_name in call_names) {
    code <- remove_balanced_calls(code, call_name)
  }

  code
}

extract_fixed_property_names <- function(call) {
  code_without_aes <- remove_balanced_calls(call, "aes")
  args <- split_top_level_args(call_inside(code_without_aes))
  property_regex <- "^(outlier[.]alpha|outlier[.]shape|fill|colou?r|alpha|size|linewidth|linetype|shape|width|height|method|formula|se|span)\\s*="
  property_args <- args[grepl(property_regex, args, perl = TRUE)]

  vapply(property_args, function(arg) {
    property_name <- trimws(sub("\\s*=.*$", "", arg))

    if (property_name == "method") {
      return(trim_inline(arg))
    }

    property_name
  }, character(1))
}

plot_anatomy_rows <- function(chunk_lines) {
  code <- paste(chunk_lines, collapse = "\n")

  aes_calls <- find_balanced_calls(code, "aes")
  mappings <- unlist(lapply(aes_calls, extract_arg_names, positional_names = c("x", "y")), use.names = FALSE)

  geom_calls <- find_balanced_prefixed_calls(code, "(geom_[A-Za-z0-9_.]+|stat_[A-Za-z0-9_.]+)")

  geoms <- find_function_names(code, "(geom_[A-Za-z0-9_.]+|stat_[A-Za-z0-9_.]+)")
  geoms <- paste0(geoms, "()")

  features <- find_function_names(
    code,
    "(scale_[A-Za-z0-9_.]+|coord_[A-Za-z0-9_.]+|facet_[A-Za-z0-9_.]+|guides|labs|theme|theme_[A-Za-z0-9_.]+)"
  )
  features <- paste0(features, "()")

  geom_property_rows <- character()

  if (nrow(geom_calls) > 0) {
    geom_name_counts <- table(geom_calls$name)
    geom_seen <- setNames(integer(length(geom_name_counts)), names(geom_name_counts))

    for (i in seq_len(nrow(geom_calls))) {
      geom_name <- geom_calls$name[[i]]
      geom_seen[[geom_name]] <- geom_seen[[geom_name]] + 1L
      properties <- extract_fixed_property_names(geom_calls$call[[i]])

      if (length(properties) > 0) {
        row_label <- paste0("`", geom_name, "()` properties")

        if (geom_name_counts[[geom_name]] > 1L) {
          row_label <- paste0(row_label, " (layer ", geom_seen[[geom_name]], ")")
        }

        geom_property_rows <- c(
          geom_property_rows,
          paste0("| ", row_label, " | ", format_items(properties), " |")
        )
      }
    }
  }

  component_rows <- data.frame(component = character(), values = character())

  add_row <- function(component, values) {
    component_rows <<- rbind(
      component_rows,
      data.frame(component = component, values = values, stringsAsFactors = FALSE)
    )
  }

  if (has_items(mappings)) {
    add_row("Aesthetic mappings", format_items(mappings))
  }

  if (has_items(geoms)) {
    add_row("Geoms / stats", format_items(geoms))
  }

  if (length(geom_property_rows) > 0) {
    for (row in geom_property_rows) {
      row_parts <- strsplit(sub("^\\| ", "", sub(" \\|$", "", row)), " \\| ", perl = TRUE)[[1]]
      add_row(row_parts[[1]], row_parts[[2]])
    }
  }

  if (has_items(features)) {
    add_row("Scales / coordinates / facets / labels", format_items(features))
  }

  component_rows
}

changed_plot_anatomy_rows <- function(current_rows, previous_rows = NULL) {
  if (is.null(previous_rows) || nrow(previous_rows) == 0) {
    return(current_rows)
  }

  keep <- vapply(seq_len(nrow(current_rows)), function(i) {
    previous_match <- which(previous_rows$component == current_rows$component[[i]])

    length(previous_match) == 0 || !identical(previous_rows$values[[previous_match[[1]]]], current_rows$values[[i]])
  }, logical(1))

  current_rows[keep, , drop = FALSE]
}

plot_anatomy_table <- function(rows) {
  if (nrow(rows) == 0) {
    return(character())
  }

  c(
    annotation_start,
    "::: {.plot-anatomy}",
    "| Plot component | Code in this chunk |",
    "|---|---|",
    paste0("| ", rows$component, " | ", rows$values, " |"),
    ":::",
    annotation_end
  )
}

plot_anatomy_style <- function() {
  c(
    style_start,
    "```{=html}",
    "<style>",
    ".plot-anatomy {",
    "  font-size: 0.9em;",
    "  line-height: 1.25;",
    "}",
    ".plot-anatomy p {",
    "  margin-bottom: 0.25rem;",
    "}",
    ".plot-anatomy table {",
    "  margin-top: 0.25rem;",
    "  margin-bottom: 0.75rem;",
    "}",
    ".plot-anatomy table th,",
    ".plot-anatomy table td {",
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

insert_plot_anatomy_style <- function(lines) {
  if (length(lines) >= 2L && identical(lines[[1]], "---")) {
    yaml_end_candidates <- which(lines[-1] == "---")

    if (length(yaml_end_candidates) == 0) {
      return(c(plot_anatomy_style(), "", lines))
    }

    yaml_end <- yaml_end_candidates[[1]] + 1L
    remainder <- character()

    if (yaml_end < length(lines)) {
      remainder <- lines[seq.int(yaml_end + 1L, length(lines))]
    }

    return(c(
      lines[seq_len(yaml_end)],
      "",
      plot_anatomy_style(),
      remainder
    ))
  }

  c(plot_anatomy_style(), "", lines)
}

is_plot_chunk <- function(chunk_lines) {
  code <- paste(chunk_lines, collapse = "\n")
  grepl("(?<![A-Za-z0-9_.])ggplot\\s*\\(", code, perl = TRUE) ||
    grepl("(?<![A-Za-z0-9_.])(geom_[A-Za-z0-9_.]+|stat_[A-Za-z0-9_.]+)\\s*\\(", code, perl = TRUE) ||
    grepl("(?<![A-Za-z0-9_.])(scale_[A-Za-z0-9_.]+|coord_[A-Za-z0-9_.]+|facet_[A-Za-z0-9_.]+|guides|labs|theme|theme_[A-Za-z0-9_.]+)\\s*\\(", code, perl = TRUE)
}

is_eval_false_chunk <- function(chunk_lines) {
  any(grepl("#\\|[[:space:]]*eval:[[:space:]]*false", chunk_lines))
}

annotate_file <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lines <- remove_existing_annotations(lines)

  out <- character()
  in_r_chunk <- FALSE
  chunk_lines <- character()
  inserted <- 0L
  previous_plot_rows <- NULL

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

        if (is_plot_chunk(body) && !is_eval_false_chunk(body)) {
          current_plot_rows <- plot_anatomy_rows(body)
          changed_rows <- changed_plot_anatomy_rows(current_plot_rows, previous_plot_rows)
          anatomy_table <- plot_anatomy_table(changed_rows)

          if (length(anatomy_table) > 0) {
            out <- c(out, anatomy_table, "", chunk_lines)
            inserted <- inserted + 1L
          } else {
            out <- c(out, chunk_lines)
          }

          previous_plot_rows <- current_plot_rows
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

  message("Inserted plot-anatomy tables before ", total, " plotting chunks in ", sum(counts > 0), " files.")

  if (total > 0) {
    print(data.frame(file = names(counts[counts > 0]), tables = as.integer(counts[counts > 0])), row.names = FALSE)
  }
}
