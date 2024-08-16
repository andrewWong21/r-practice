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

# attr(x, "names") is not recommended, less readable than names(x)
# remove names from a vector with x <- unname(x) or names(x) <- NULL

# names should be unique and non-missing for useful subsetting
# non-missingness is not enforced, missing names can be "" or NA_character_
y <- setNames(1:3, c(NA, "b", "c"))
y

# add dim attribute to vector to convert it into a matrix or array
# 2Dmatrix with 2 rows and 3 columns
x <- matrix(1:6, nrow = 2, ncol = 3)
x

# 3D matrix - 2 rows, 3 columns, 2 (pages/slices/aisles/...)
y <- array(1:12, c(2, 3, 2))
y

# set dim() after creating an object
z <- 1:6
dim(z) <- c(3, 2)
z

# vector functions have analogous functions for matrices and arrays
# names() -> rownames(), colnames() -> dimnames()
# length() -> nrow(), ncol() -> dim()
# c() -> rbind(), cbind() -> abind::abind()
# - -> t() -> aperm()
# is.null(dim(x)) -> is.matrix() -> is.array()

# vector without a set dim attribute is considered by R to have NULL dimensions
# matrices with single rows/columns or arrays with single dimensions
# will print similarly, but behave differently from vectors

# -------------------------------------------------------------------------


