# atomic vectors do not include matrices, arrays, factors, or date-times

# adding attributes to atomic vectors allows creation of these data structures

# dim attribute is used to make matrices and arrays

# class attribute is used for S3 vectors - factors, dates, date-times

# attributes attach metadata to an object, effectively work like name-value pairs

a <- 1:3
attr(a, "x") <- "abcdef"
attr(a, "x")

attr(a, "y") <- 4:6
str(attributes(a))

a <- structure(
  1:3,
  x = "abcdef",
  y = 4:6
)
str(attributes(a))

# most attributes are generally lost following operations
# only names (character vector for names of elements) 
# and dims (integer vector for dimensions) are routinely preserved

# vectors can be named during creation, by assigning names, 
# or applying them inline with setNames()
x <- c(a = 1, b = 2, c = 3)
x <- 1:3
names(x) <- c("a", "b", "c")
x <- setNames(1:3, c("a", "b", "c"))
