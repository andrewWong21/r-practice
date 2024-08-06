# the following code binds x and y to the same object, then modifies y
x <- c(1, 2, 3)
y <- x

y[[3]] <- 4
x
y

# R has copy-on-modify behavior: original object does not change
# when an object has multiple names bound to it
# a copy of object is created, modified, and name is rebound to new object

# base::tracemem() helps to show when an object is copied
# call function with object to get object's address
x <- c(1, 2, 3)
cat(tracemem(x), "\n")

y <- x
y[[3]] <- 4L

# modifying y again does not create another copy of the object
# since object only has one name bound to it (modify-in-place optimization)
y[[3]] <- 5L

# untracemem turns tracing off
untracemem(x)

# copying rules also apply to functions
f <- function(a){
  a
}

x <- c(1, 2, 3)
cat(tracemem(x), "\n")

z <- f(x)

untracemem(x)

# since function f() does not modify its argument a, no copy is made of a
# x and z point to the same object after f() finishes running
# while f() is running, a and x point to the same object

# lists store references to values - each element is a pointer to a value
list1 <- list(1, 2, 3)

# lists and vectors both have copy-on-modify behavior
# R makes a shallow copy when modifying lists
# bindings are copied, but values are not copied
# deep copies also copy contents of references into separate memory addresses
list2 <- list1
list2[[3]] <- 4

# use lobstr::ref() to see values shared across lists
# ref() prints memory address and local id of objects for cross-referencing

# elements 2 and 3 of list1 and list2 point to the same object in memory
lobstr::ref(list1, list2)

# data frames are lists of vectors, slightly different behavior
# when modifying rows vs. modifying columns
d1 <- data.frame(x = c(1, 5, 6), y = c(2, 4, 3))

# modifying a column only makes a copy of that column
# other columns are not modified
d2 <- d1
d2[, 2] <- d2[, 2] * 2
lobstr::ref(d1, d2)

# modifying a row makes a copy of every column
# every column is modified
d3 <- d1
d3[1, ] <- d3[1, ] * 3
lobstr::ref(d1, d3)

# -------------------------------------------------------------------------

# 1. Why is tracemem(1:10) not helpful?
tracemem(1:10)
tracemem(1:10)

# tracemem is meant to be used with names bound to objects
# tracemem(1:10) calls the function on an object with no name binding
# so there is no way to refer to the same object again in later code
# running the statement again results in a different address


# 2. Explain why tracemem() shows two copies when you run this code.
x <- c(1L, 2L, 3L)
tracemem(x)

x[[3]] <- 4

# L suffix is used to denote integers rather than doubles.
# The statement after running tracemem() modifies the vector x, creating a copy.
# The object referenced by x[[3]] is also modified, which creates a copy.


# 3. Sketch out the relationship between the following objects:
a <- 1:10
b <- list(a, a)
c <- list(b, a, 1:10)

lobstr::ref(a)
lobstr::ref(b)
lobstr::ref(c)
# b has two references to a
# c has one direct reference to a 
# and a reference to b, itself containing two references to a


# 4. What happens when you run this code?
x <- list(1:10)
tracemem(x)
x[[2]] <- x
x
lobstr::ref(x)

# x is initially bound to a list object referencing an integer vector
# modification of element at index 2 creates a copy of the list
# x is bound to copy of list object so x now points to a new list
# second element of x points to original list, has no name bound to it
