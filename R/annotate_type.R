#' Declare type of a function
#' @param f A function; the function to which type-annotations are added.
#' @param signature A named list of character vector. The type / classes.
#' Union class is supported, e.g. list(arg_1 = c("numeric", "matrix")) is allowed.
#' @examples
#' \dontrun{
#' # Example 1
#' add_one <- function(x) { x + 1 }
#' add_one <- declare::type_ls(add_one, list(x = "numeric"))
#' add_one(10)          # Runs fine
#' add_one(nrow(1:10))  # Expect type error since nrow of a vector returns NULL.
#'
#' # Example 2
#' cbind_rows <- function(r1, r2) { cbind(r1, r2) }
#' cbind_rows <- declare::type_ls(cbind_rows, list(r1 = "matrix", r2 = "matrix"))
#'
#' X <- matrix(1:9, 3, 3)
#' Y <- matrix(1:3, ncol = 3)
#' cbind_rows(Y, Y)     # Runs fine
#' cbind_rows(X[1,], Y) # Expect type error since X[1,] is converted to vector implicitly.
#'
#' # Example 3 - Partial specification
#' f <- function(x, y) { x[1:3, ] * y }
#' f <- declare::type_ls(f, list(y = "numeric"))  # 'x' is unspecified
#'
#' x <- matrix(1:9, 3, 3)
#' x2 <- as.data.frame(x)
#' k <- 5
#' f(x, k)     # runs fine
#' f(x2, k)    # runs fine
#' f(x2, "A")  # type error
#'
#' # Example 4 - Multiple labels
#' f <- function(x, y) { x[1:3, ] * y }
#' f <- declare::type_ls(f, list(x = c("matrix", "data.frame"), y = "numeric"))
#'
#' x <- matrix(1:9, 3, 3)
#' x2 <- as.data.frame(x)
#' k <- 5
#' f(x, k)    # runs fine
#' f(x2, k)   # runs fine
#' f("A", k)  # type error
#' }
#' @export
type_ls <- function(f, signature) {
  g <- f
  function(...) {
    input_var <- match_args(list(...), formalArgs(g))
    input_var_class <- Map(class, input_var)
    mismatch <- check_signature(input_var_class, signature)
    if (length(mismatch) > 0) {
      stop(glue::glue(
        "The following variables do not have the right class: {collapse(mismatch)}
         - Expected: {collapse(signature[mismatch])}
         - Actual  : {collapse(input_var_class[mismatch])}"
      ))
    }
    g(...)
  }
}

#' Declare type of a function
#' @description A wrapper for `declare_ls`; just to provide another interface.
#' @param f A function; the function to which type-annotations are added.
#' @param ... The type / classes for each argument.
#' @examples
#' \dontrun{
#' # Example 1
#' add_one <- function(x) { x + 1 }
#' add_one <- declare::type(add_one, x = "numeric")
#' add_one(10)          # Runs fine
#' add_one(nrow(1:10))  # Expect type error since nrow of a vector returns NULL.
#' }
#' @export
type <- function(f, ...) {
  type_ls(f, list(...))
}
