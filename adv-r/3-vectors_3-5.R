# lists can contain elements of any type
# unlike vectors which will coerce elements of different types

# lists store references to other objects
# so elements are all of same type in terms of implementation

# construct lists using list()
list1 <- list(
  1:3,
  "a",
  c(TRUE, FALSE, TRUE),
  c(2.3, 5.9)
)
typeof(list1)
str(list1)

# elements of lists are references to objects instead, saves space
lobstr::obj_size(mtcars)

list2 <- list(mtcars, mtcars, mtcars, mtcars)
lobstr::obj_size(list2)
lobstr::obj_size(list()) # empty list is 48 bytes

# lists can contain other lists - also called recursive vectors
list3 <- list(list(list(1)))
str(list3)

# c() combines multiple lists into one
# if both lists and vectors are provided, vectors are coerced to lists
list4 <- list(list(1, 2), c(3, 4))
list4
str(list4)

list5 <- c(list(1, 2), c(3, 4))
list5
str(list5)

# typeof() returns "list" for a list object
# test for list with is.list(), coerce with as.list()
list(1:3)
str(list(1:3))

as.list(1:3)
str(as.list(1:3))

# can turn list into atomic vector with unlist()
# however, resulting type behavior is not well-documented
# and sometimes different from using c()

# dimension attribute can be applied to lists
# to create list-arrays or list-matrices
dim_list <- list(1:3, "a", TRUE, 1.0)
dim(dim_list) <- c(2, 2)

# useful for arranging different types of objects in a grid-based structure
dim_list
dim_list[[1, 1]]

# -------------------------------------------------------------------------

# 1. List all the ways that a list differs from an atomic vector.

# atomic vectors can only contain elements of one type
# while lists can contain elements of different types

# lists store references to objects, while vectors 


# 2. Why do you need to use unlist() Why doesn't as.vector() work?

x <- list("a", 1, TRUE)
typeof(x)

# lists are also vectors, applying as.vector() still results in a list object
as.vector(x)
typeof(as.vector(x))

unlist(x)
typeof(unlist(x))


# 3. Compare and contrast c() and unlist() when combining
# a date and a date-time vector.

# dates and date-times are stored as doubles with attributes
# dates are stored in terms of days, date-times are stored in terms of seconds
nyd <- as.Date("2024-01-01")
nyd
unclass(nyd)

nyd_dt <- as.POSIXct("2024-01-01", timezone = "UTC")
nyd_dt
unclass(nyd_dt)

# c() coerces both to dates when first argument is a date
c(nyd, nyd_dt)
unclass(c(nyd, nyd_dt))
typeof(c(nyd, nyd_dt))
attributes(c(nyd, nyd_dt))

# coerces both to date-times when first argument is a date-time
c(nyd_dt, nyd)
unclass(c(nyd_dt, nyd))
typeof(c(nyd_dt, nyd))
attributes(c(nyd_dt, nyd))

# unlisting strips list attributes, leaving underlying doubles
# order of types does not affect resulting output type - always double vector
unlist(list(nyd, nyd_dt))
unclass(unlist(list(nyd, nyd_dt)))
typeof(unlist(list(nyd, nyd_dt)))

unlist(list(nyd_dt, nyd))
unclass(unlist(list(nyd_dt, nyd)))
typeof(unlist(list(nyd_dt, nyd)))
