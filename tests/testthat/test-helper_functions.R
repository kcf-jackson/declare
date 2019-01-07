context("Testing type annotation")

library(testthat)
equal_up_to_sort <- function(x, y) {
  if (!is.null(names(x))) {
    return(expect_equal(x[sort(names(x))], y))
  }
  expect_equal(x, y)
}

test_that("Test matching arguments", {
  equal_up_to_sort(
    match_args(list(a = 1, 2, 3, d = 4), c('a', 'b', 'c', 'd')),
    list(a = 1, b = 2, c = 3, d = 4)
  )
  equal_up_to_sort(
    match_args(list(2, 3, d = 4, a = 1), c('a', 'b', 'c', 'd')),
    list(a = 1, b = 2, c = 3, d = 4)
  )
  equal_up_to_sort(
    match_args(list(2, 3, d = 4, a = 1), c('a', 'b', 'c')),
    list(a = 1, b = 2, c = 3, d = 4)
  )
  equal_up_to_sort(
    match_args(list(2, 3, a = 1), c('a', 'b', 'c', 'd')),
    list(a = 1, b = 2, c = 3)
  )
  equal_up_to_sort(
    match_args(list(1, 2, 3, 4), c('a', 'b', 'c', 'd')),
    list(a = 1, b = 2, c = 3, d = 4)
  )
  equal_up_to_sort(
    match_args(list(1, 2, 3, 4), c()),
    list(1, 2, 3, 4)
  )
  equal_up_to_sort(
    match_args(list(a = 1, b = 2, c = 3, d = 4), c('a', 'b', 'c', 'd')),
    list(a = 1, b = 2, c = 3, d = 4)
  )
})
