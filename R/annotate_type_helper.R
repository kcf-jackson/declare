#' Match a list of arguments against the formal arguments of a function
#' @param ls_args A list of arguments (named or nameless)
#' @param chr_name Character vector; the formal arguments of a function
#' @keywords internal
match_args <- function(ls_args, chr_name) {
  # Remove common names
  args_name <- names(ls_args)
  if (is.null(args_name)) {
    ls_nameless <- ls_args
    ls_named <- NULL
  } else {
    ls_nameless <- ls_args[args_name == ""]
    ls_named  <- ls_args[args_name != ""]
  }
  chr_name <- setdiff(chr_name, args_name)

  # Match as many as possible
  len_nameless <- length(ls_nameless)
  num_name <- length(chr_name)
  if (len_nameless == 0 || num_name == 0) {
    return(append(ls_nameless, ls_named))
  }
  num_match <- min(len_nameless, num_name)
  names(ls_nameless)[1:num_match] <- chr_name[1:num_match]
  append(ls_nameless, ls_named)
}

# Check a list of arguments against the signature
check_signature <- function(list0, signature) {
  ns <- intersect(names(list0), names(signature))
  success <- purrr::map_lgl(ns, ~list0[[.x]] %in% signature[[.x]])
  ns[which(!success)]
}

collapse <- function(x) paste(x, collapse = ", ")
