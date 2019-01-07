context("Test type annotation")

test_that("Test that type_ls is functioning", {
  add_one <- function(x) { x + 1 }
  add_one <- declare::type_ls(add_one, list(x = "numeric"))
  expect_equal(add_one(10), 11)
  expect_error(add_one(nrow(1:10)))

  cbind_rows <- function(r1, r2) { cbind(r1, r2) }
  cbind_rows <- declare::type_ls(cbind_rows, list(r1 = "matrix", r2 = "matrix"))
  X <- matrix(1:9, 3, 3)
  Y <- matrix(1:3, ncol = 3)
  expect_equal(cbind_rows(Y, Y), cbind(Y, Y))
  expect_error(cbind_rows(X[1,], Y))
})

test_that("Test that type is functioning", {
  f <- function(x, y) { x[1:3, ] * y }
  f <- declare::type(f, list(y = "numeric"))
  x <- matrix(1:9, 3, 3)
  x2 <- as.data.frame(x)
  k <- 5
  expect_equal(f(x, k), x[1:3, ] * k)
  expect_equal(f(x2, k), x2[1:3, ] * k)
  expect_error(f(x2, "A"))

  # Example 4 - Multiple labels
  f <- function(x, y) { x[1:3, ] * y }
  f <- declare::type_ls(f, list(x = c("matrix", "data.frame"), y = "numeric"))

  x <- matrix(1:9, 3, 3)
  x2 <- as.data.frame(x)
  k <- 5
  expect_equal(f(x, k), x[1:3, ] * k)
  expect_equal(f(x2, k), x2[1:3, ] * k)
  expect_error(f("A", k))
})
