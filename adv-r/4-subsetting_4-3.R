# [[]] is used for extracting single items from data structures
# $ is an alternative to [[]] - x$y is equivalent to x[["y"]]

# [] returns a smaller list when subsetting lists, while [[]] returns elements
x <- list(1:3, "a", 4:6)
x
x[1]   # returns list with one element
x[[1]] # returns single element

x[1:2]
x[-2]
x[c(1, 1)]
x[0]

# [[]] must be used with a single positive integer or string
# negative subscripts are not allowed and will return an error
x[[-1]]

# using a vector will subset recursively
x[[c(1, 2)]] # equivalent to x[[1]][[2]]

# recommended to use [[]] with atomic vectors for extracting single values
fun <- function(a, b){
  a
}

out <- list()
for (i in length(x)){
  out[[i]] <- fun(x[[i]], out[[i]])
}
out

# $ is shorthand for [[]], but cannot be used with names stored in variables
var <- "cyl"
mtcars$var
mtcars[[var]]

# $ does partial matching from left to right
x <- list(abc = 1)
x$a

# can be disabled by setting global option warnPartialMatchDollar = TRUE
# or using tibbles in place of data frames, which do not allow partial matching
options(warnPartialMatchDollar = TRUE)
x$a

# [[]] has different behaviors with invalid indices depending on
# whether the structure is an atomic vector, a list, or NULL
# and whether the subset involves zero-length, out-of-bounds, or missing values

# atomic vectors return errors for all "invalid" indices
# zero-length objects, OOB int or char values, missing values

# lists return NULL for OOB char and missing values, and errors otherwise

# NULL objects always return NULL for any invalid indices

# purrr::pluck() and purrr::chuck() were developed to standardize behavior
# pluck() always returns NULL or specified .default argument value
# chuck() always throws an error for missing elements
x <- list(
  a = list(1, 2, 3),
  b = list(3, 4, 5)
)
x

# pluck() is useful for indexing deeply nested data structures
# allows mixing of both integer and character indices
# and customizable default values for missing elements
purrr::pluck(x, "a", 1)
purrr::pluck(x, "c", 1)
purrr::pluck(x, "c", 1, .default = NA)

# -------------------------------------------------------------------------
