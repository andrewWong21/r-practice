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
