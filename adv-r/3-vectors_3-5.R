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
