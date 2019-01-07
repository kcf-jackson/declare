#' Source file with type annotation
#' @param fpath Character; the full file path.
#' @param local TRUE, FALSE or an environment; determining where the parsed
#' expressions are evaluated. FALSE (the default) corresponds to the user's
#' workspace (the global environment) and TRUE to the environment from which
#' source is called.
#' @param show_order T or F; if T, print out the expression in the order they
#' are evaluated.
#' @export
source_with_type_annotation <- function(fpath, local = FALSE, show_order = F) {
  # The environment setup is copied from the `source` function
  envir <- if (isTRUE(local))
    parent.frame()
  else if (isFALSE(local))
    .GlobalEnv
  else if (is.environment(local))
    local
  else stop("'local' must be TRUE, FALSE or an environment")

  src_code <- rlang::parse_exprs(file(fpath))
  annotation <- rlang::parse_exprs(get_type_annotation(fpath))
  eval0 <- ifelse(show_order, eval_and_print, eval)

  iter_eval <- function(src_code, annotation) {
    if (length(src_code) == 0) return(NULL)
    eval0(src_code[[1]], envir)

    if (length(annotation) == 0) {
      # evaluate the remaining expressions
      purrr::map(src_code[-1], ~eval0(.x, envir))
      return(invisible(NULL))
    }

    check_match <- match_calls(src_code[[1]], annotation[[1]])
    if (check_match) {
      eval0(annotation[[1]], envir)
      iter_eval(src_code[-1], annotation[-1])
    } else {
      iter_eval(src_code[-1], annotation)
    }
  }

  iter_eval(src_code, annotation)
  invisible(NULL)
}

match_calls <- function(expr0, expr1) {
  same_name <- function(x, y) { x[[2]] == y[[2]] }
  is_assign <- function(x) { rlang::is_call(x, c("<-", "=")) }
  is_declare <- function(x) {
    rlang::is_call(x[[3]], c("type", "type_ls"))
  }
  is_assign(expr0) && is_assign(expr1) &&
    same_name(expr0, expr1) &&
    is_declare(expr1)
}

get_type_annotation <- function(fpath) {
  chr_xs <- readLines(fpath)
  annotation_lines <- which(purrr::map_lgl(chr_xs, is_type_annotation))
  purrr::map_chr(chr_xs[annotation_lines], remove_n_char, n = 3)
}

eval_and_print <- function(x, ...) {
  print(x)
  eval(x, ...)
}

# Low-level helper functions
is_type_annotation <- function(chr_x) {
  first_n_char(chr_x, 3) == "#$ "
}

first_n_char <- function(x, n) {
  paste(unlist(strsplit(x, split = ""))[seq(n)], collapse = "")
}

remove_n_char <- function(x, n) {
  paste(unlist(strsplit(x, split = ""))[-seq(n)], collapse = "")
}
