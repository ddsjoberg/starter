context("%not_in%")

test_that("%not_in% works", {
  expect_equal(
    mtcars$cyl %not_in% c(2, 6),
    !(mtcars$cyl %in% c(2, 6))
  )

  expect_equal(
    c(2, 6) %not_in% mtcars$cyl,
    !(c(2, 6) %in% mtcars$cyl)
  )
})
