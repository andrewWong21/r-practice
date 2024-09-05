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
