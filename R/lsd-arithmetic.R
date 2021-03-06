## lsd Arithmetic ##

#' Multiplication of pounds, shillings, and pence
#'
#' Multiply pounds, shillings, and pence by a multiplier (`x`). The result is
#' normalized to standard bases for shillings and pence units according to the
#' `bases` argument. This is a wrapper around [deb_normalize()].
#'
#' @family lsd arithmetic functions
#'
#' @inheritParams deb_normalize
#' @param x Multiplier. The value by which `lsd` will be multiplied. A numeric
#'   vector of length 1.
#'
#' @return Returns an object of class lsd with a bases attribute.
#'
#' @examples
#' # Multiply pounds, shillings, and pence by 5
#' deb_multiply(lsd = c(5, 15, 8), x = 5)
#'
#' # Multiply an lsd value that has alternative bases
#' deb_multiply(lsd = c(5, 15, 8), x = 5, bases = c(20, 16))
#'
#' # Multiplying an object of class lsd will use the bases attribute
#' lsd <- deb_as_lsd(lsd = c(5, 15, 8), bases = c(20, 16))
#' deb_multiply(lsd = lsd, x = 5)
#'
#' # Calculate commission of 3% of sales of £3095 17s. 6d.
#' deb_multiply(lsd = c(3095, 17, 6), x = 0.03)
#'
#' # The l, s, and d values do not have to be normalized
#' deb_multiply(lsd = c(10, 38, 65), x = 5)
#'
#' # Like deb_normalize(), deb_multiply() can handle negative numbers
#' deb_multiply(lsd = c(-5, -15, -8), x = 5)
#' deb_multiply(lsd = c(5, 15, 8), x = -5)
#'
#' # Or decimals
#' deb_multiply(lsd = c(5.625, 15.35, 8), x = 5)
#'
#' # Use round argument to round pence unit to specific decimal place
#' deb_multiply(lsd = c(5, 15, 8), x = 2 / 3, round = 2)
#'
#' # Multiply a list of lsd values by a multiplier
#' lsd_list <- list(c(40, 5, 9), c(29, 7, 1), c(35, 6, 5))
#' deb_multiply(lsd = lsd_list, x = 5)
#'
#' # Or an lsd object with alternative bases
#' lsd_list2 <- deb_as_lsd(lsd = lsd_list, bases = c(20, 16))
#' deb_multiply(lsd = lsd_list2, x = 5)
#'
#' @export

deb_multiply <- function(lsd, x, bases = c(20, 12), round = 5) {
  arithmetic_check(x)
  bases <- validate_bases(lsd, bases)
  lsd <- null_check(lsd)

  if (is.list(lsd) == TRUE) {
    lsd <- purrr::map(lsd, ~ . * x)
  } else {
      lsd <- lsd * x
    }

  deb_normalize(lsd = lsd, bases = bases, round = round)
}


#' Division of pounds, shillings, and pence
#'
#' Divide pounds, shillings, and pence by a divisor (`x`). The result is
#' normalized to standard bases for shillings and pence units according to the
#' `bases` argument. This is a wrapper around [deb_normalize()].
#'
#' @family lsd arithmetic functions
#'
#' @inheritParams deb_normalize
#' @param x Divisor. The value by which `lsd` will be divided. A numeric vector
#'   of length 1.
#'
#' @return Returns an object of class lsd with a bases attribute.
#'
#' @examples
#' # Divide pounds, shillings, and pence by a divisor
#' deb_divide(lsd = c(63, 15, 8), x = 4)
#'
#' # Divide an lsd value that has alternative bases
#' deb_divide(lsd = c(63, 15, 8), x = 4, bases = c(20, 16))
#'
#' # Dividing an object of class lsd will use the bases attribute
#' lsd <- deb_as_lsd(lsd = c(63, 15, 8), bases = c(20, 16))
#' deb_divide(lsd = lsd, x = 4)
#'
#' # The l, s, and d values do not have to be normalized
#' deb_divide(lsd = c(109, 38, 65), x = 8)
#'
#' # Like deb_normalize(), deb_divide() can handle negative numbers
#' deb_divide(lsd = c(-63, -15, -8), x = 4)
#' deb_divide(lsd = c(63, 15, 8), x = -4)
#'
#' # Or decimals
#' deb_divide(lsd = c(63.625, 15.35, 8), x = 4)
#'
#' # Use round argument to round pence unit to specific decimal place
#' deb_divide(lsd = c(5, 15, 8), x = 3, round = 2)
#'
#' # Divide a list of lsd values by a divisor
#' lsd_list <- list(c(40, 5, 9), c(29, 7, 1), c(35, 6, 5))
#' deb_divide(lsd = lsd_list, x = 4)
#'
#' # Or an lsd object with alternative bases
#' lsd_list2 <- deb_as_lsd(lsd = lsd_list, bases = c(20, 16))
#' deb_divide(lsd = lsd_list2, x = 4)
#'
#' @export

deb_divide <- function(lsd, x, bases = c(20, 12), round = 5) {
  arithmetic_check(x)
  bases <- validate_bases(lsd, bases)
  lsd <- null_check(lsd)

  if (is.list(lsd) == TRUE) {
    lsd <- purrr::map(lsd, ~ . / x)
  } else {
    lsd <- lsd / x
  }

  deb_normalize(lsd = lsd, bases = bases, round = round)
}


#' Addition of two pounds, shillings, and pence values
#'
#' Add two pounds, shillings, and pence values that are in the form of lsd
#' objects, numeric vectors, or lists of numeric vectors. If one of `lsd1`
#' and `lsd2` is a list and the other is a vector, the vector will be recycled.
#'
#' See [deb_sum()] to get the sum of multiple numeric vectors and/or lists of
#' numeric vectors, reducing the inputs to a single numeric vector.
#'
#' @family lsd arithmetic functions
#'
#' @inheritParams deb_normalize
#' @param lsd1,lsd2 lsd values. Objects of class lsd or objects that can be
#'   coerced to class lsd: numeric vectors of length 3 or lists of such
#'   vectors. If `lsd1` and `lsd2` are both lists, they must be the same
#'   length, or one must be of length 1.
#' @param bases Numeric vector of length 2 used to specify the bases for the
#'   shillings or s and pence or d units. Default is `c(20, 12)`, which
#'   conforms to the most widely used system of 1 pound = 20 shillings and
#'   1 shilling = 12 pence. If `lsd1` and/or `lsd2` is of class lsd, the bases
#'   attribute will be used in the place of this argument. If the bases
#'   attributes of `lsd1` and `lsd2` are different, an error will be thrown.
#'
#' @return Returns an object of class lsd with a bases attribute.
#'
#' @examples
#' # Add pounds, shillings, and pence
#' deb_add(lsd1 = c(56, 8, 5), lsd2 = c(19, 5, 7))
#'
#' # Add lsd values that have alternative bases
#' deb_add(lsd1 = c(56, 8, 5), lsd2 = c(19, 5, 7), bases = c(20, 16))
#'
#' # If one of the values is of class lsd the bases attribute will be used
#' lsd1 <- deb_as_lsd(lsd = c(56, 8, 5), bases = c(20, 16))
#' deb_add(lsd1 = lsd1, lsd2 = c(19, 5, 7))
#'
#' # If lsd1 and lsd2 have different bases, the function will throw an error
#' lsd2 <- deb_as_lsd(lsd = c(19, 5, 7), bases = c(20, 12))
#' \dontrun{
#' deb_add(lsd1 = lsd1, lsd2 = lsd2)
#' }
#'
#' # deb_add with two vectors is equivalent to using deb_sum
#' deb_sum(c(56, 8, 5), c(19, 5, 7))
#'
#' # deb_add is useful when one or both of lsd1 and lsd2
#' # are lists of numerical vectors
#'
#' # With two lists of the same length each vector in lsd1
#' # will be added to the corresponding vector in lsd2.
#' deb_add(lsd1 = list(c(56, 8, 5), c(27, 12, 4)),
#'         lsd2 = list(c(19, 5, 7), c(6, 3, 2)))
#'
#' # As opposed to using deb_normalize, which will not work
#' \dontrun{
#' deb_normalize(list(c(56, 8, 5), c(27, 12, 4)) + list(c(19, 5, 7), c(6, 3, 2)))
#' }
#'
#' # If lsd1 and lsd2 are lists of different lengths,
#' # one must be of length one, which is the same as
#' # if the shorter list was a vector.
#' deb_add(lsd1 = list(c(56, 8, 5),
#'                     c(27, 12, 4),
#'                     c(78, 14, 11)),
#'         lsd2 = list(c(6, 18, 10)))
#'
#' @export

deb_add <- function(lsd1, lsd2, bases = c(20, 12), round = 5) {
  arithmetic_check2(lsd1, lsd2)
  bases <- validate_bases2(lsd1, lsd2, bases)
  lsd1 <- null_check(lsd1)
  lsd2 <- null_check(lsd2)

  if (is.list(lsd1) | is.list(lsd2) == TRUE) {
    # ensure that both are lists to recycle correctly
    if (is.list(lsd1) == FALSE) {
      lsd1 <- list(lsd1)
    }
    if (is.list(lsd2) == FALSE) {
      lsd2 <- list(lsd2)
    }
    lsd <- purrr::map2(lsd1, lsd2, ~ .x + .y)
  } else {
    lsd <- lsd1 + lsd2
  }

  deb_normalize(lsd = lsd, bases = bases, round = round)
}


#' Subtraction of two pounds, shillings, and pence values
#'
#' Subtract two pounds, shillings, and pence values that are in the form of lsd
#' objects, numeric vectors, or lists of numeric vectors. If one of `lsd1`
#' and `lsd2` is a list and the other is a vector, the vector will be recycled.
#'
#' @family lsd arithmetic functions
#'
#' @inheritParams deb_add
#' @param lsd1,lsd2 lsd values. Objects of class lsd or objects that can be
#'   coerced to class lsd: numeric vectors of length 3 or lists of such
#'   vectors. If `lsd1` and `lsd2` are both lists, they must be the same
#'   length, or one must be of length 1. `lsd2` is the value or values to be
#'   subtracted from `lsd1`: `lsd1 - lsd2`.
#'
#' @return Returns an object of class lsd with a bases attribute.
#'
#' @examples
#' # Subtract pounds, shillings, and pence
#' deb_subtract(lsd1 = c(56, 8, 5), lsd2 = c(19, 5, 7))
#'
#' # Subtract lsd values that have alternative bases
#' deb_subtract(lsd1 = c(56, 8, 5), lsd2 = c(19, 5, 7), bases = c(20, 16))
#'
#' # If one of the values is of class lsd the bases attribute will be used
#' lsd1 <- deb_as_lsd(lsd = c(56, 8, 5), bases = c(20, 16))
#' deb_subtract(lsd1 = lsd1, lsd2 = c(19, 5, 7))
#'
#' # If lsd1 and lsd2 have different bases, the function will throw an error
#' lsd2 <- deb_as_lsd(lsd = c(19, 5, 7), bases = c(20, 12))
#' \dontrun{
#' deb_subtract(lsd1 = lsd1, lsd2 = lsd2)
#' }
#'
#' # Subtracting two vectors is equivalent to using deb_normalize
#' deb_normalize(lsd = c(56, 8, 5) - c(19, 5, 7))
#'
#' # deb_subtract is useful when one or both of lsd1 and lsd2
#' # are lists of numerical vectors
#'
#' # With two lists of the same length each vector in lsd1
#' # will be subtracted from the corresponding vector in lsd2.
#' deb_subtract(lsd1 = list(c(56, 8, 5), c(27, 12, 4)),
#'              lsd2 = list(c(19, 5, 7), c(6, 3, 2)))
#'
#' # As opposed to using deb_normalize, which will not work
#' \dontrun{
#' deb_normalize(list(c(56, 8, 5), c(27, 12, 4)) - list(c(19, 5, 7), c(6, 3, 2)))
#' }
#'
#' # If lsd1 and lsd2 are lists of different lengths
#' # or one is a vector, the shorter argument is recycled.
#' deb_subtract(lsd1 = list(c(56, 8, 5),
#'                          c(27, 12, 4),
#'                          c(78, 14, 11)),
#'              lsd2 = c(6, 18, 10))
#'
#' @export

deb_subtract <- function(lsd1, lsd2, bases = c(20, 12), round = 5) {
  arithmetic_check2(lsd1, lsd2)
  bases <- validate_bases2(lsd1, lsd2, bases)
  lsd1 <- null_check(lsd1)
  lsd2 <- null_check(lsd2)

  if (is.list(lsd1) | is.list(lsd2) == TRUE) {
    # ensure that both are lists to recycle correctly
    if (is.list(lsd1) == FALSE) {
      lsd1 <- list(lsd1)
    }
    if (is.list(lsd2) == FALSE) {
      lsd2 <- list(lsd2)
    }
    lsd <- purrr::map2(lsd1, lsd2, ~ .x - .y)
  } else {
    lsd <- lsd1 - lsd2
  }

  deb_normalize(lsd = lsd, bases = bases, round = round)
}
