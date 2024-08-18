# atomic vectors do not include matrices, arrays, factors, or date-times

# adding attributes to atomic vectors allows creation of these data structures

# dim attribute is used to make matrices and arrays

# class attribute is used for S3 vectors - factors, dates, date-times

# attributes are like name-value pairs that attach metadata to an object
# retrieve or modify attributes individually with attr()
# retrieve full attribute set with attributes()
# and modify attribute set with structure()

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

# vectors can be named during creation, 
# by assigning character vector to names(), 
# or applying them inline with setNames()
x <- c(a = 1, b = 2, c = 3)
x <- 1:3
names(x) <- c("a", "b", "c")
x <- setNames(1:3, c("a", "b", "c"))

# attr(x, "names") is not recommended, less readable than names(x)
# remove names from a vector with x <- unname(x) or names(x) <- NULL

# names should be unique and non-missing for useful subsetting
# non-missingness is not enforced, missing names can be "" or NA_character_
# names() returns NULL if all names are missing
y <- setNames(1:3, c(NA, "b", "c"))
y

# add dim attribute to vector to convert it into a matrix or array
# 2D matrix with 2 rows and 3 columns
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

str(1:3)                   # 1D vector
str(matrix(1:3, ncol = 1)) # column vector
str(matrix(1:3, nrow = 1)) # row vector
str(array(1:3, 3))

# -------------------------------------------------------------------------

# 1. How is setNames() implemented? How is unname() implemented?

# setNames() applies name attributes to object and returns the object
# allows for creation of object with names without binding a name to it first

# unname() sets the names attribute of an object to NULL


# 2. What does dim() return when applied to a 1-dimensional vector?
# When might you use NROW() or NCOL()?

# dim() returns NULL for a 1D vector
dim(c(1, 2, 3))

# NROW and NCOL differ from nrow and ncol
# because they do not return NULL for atomic vectors
x <- 1:3
nrow(x)
ncol(x)
NROW(x)
NCOL(x)


# 3. How would you describe the following three objects?
# What makes them different from 1:5?

1:5 # has no dim attribute, while the other 3 do
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

# x objects are 1D
x1
x2
x3

dim(1:5)
dim(x1)
dim(x2)
dim(x3)

# 4. An early draft used this code to illustrate structure():
structure(1:5, comment = "my attribute")
# But when you print that object you don't see the comment attribute. Why?

# comment attributes are not printed but can be retrieved explicitly
x <- structure(1:5, comment = "my attribute")
attr(x, "comment")
