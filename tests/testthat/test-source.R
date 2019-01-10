context("Test code sourcing")

test_that("Test source a code file", {
  my_env <- new.env()
  file0 <- tempfile()
  code0 <- c(
    "#$ f <- declare::type(f, x = 'numeric')",
    "f <- function(x, y) { x + y }"
  )
  writeLines(code0, con = file0)
  source_with_type_annotation(file0, local = my_env)
  expect_true(is.function(my_env$f))
  expect_error(my_env$f('a', 4))
  expect_equal(my_env$f(3, 4), 7)

  my_env <- new.env()
  file0 <- tempfile()
  code0 <- c(
    "f <- function(x, y) { x + y }",
    "#$ f2 <- declare::type(f2, x = 'numeric')",
    "f2 <- function(x, y) { 2*x + y }",
    "f3 <- function(x, y) { 3*x + y }"
  )
  writeLines(code0, con = file0)
  source_with_type_annotation(file0, local = my_env, show_order = T)
  expect_true(is.function(my_env$f))
  expect_error(my_env$f('a', 4))
  expect_equal(my_env$f(3, 4), 7)
})
