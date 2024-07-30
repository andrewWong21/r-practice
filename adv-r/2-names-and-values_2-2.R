# knowing distinction between names and objects is important
# improve accuracy of predictions of code performance and memory usage
# write faster code by avoiding accidental copies of code
# improve understanding of functional programming tools in R

# use lobstr package to dig into internal R object representations
library(lobstr)

# distinction between names and values

# the following statement does two things:
# creates a object - vector of values 1, 2, 3
# binds object to name, "x"
x <- c(1, 2, 3)

# crucial distinction: object is value, name has value
# i.e. name is reference to value, object does not have name

# the following statement creates another binding for existing object in memory
# does not create copy of value
y <- x

# access object identifier with lobstr::obj_addr()
# identifiers change every time R is restarted
obj_addr(x)
obj_addr(y)

# situations where R makes copies

# memory occupied by objects

# -------------------------------------------------------------------------

# 1. Given the following data frame, create a new column "3" that contains
# the sum of columns "1" and "2" while only using $.
# What makes "1", "2", "3" challenging as variable names?
df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)

# 2. In the following code, how much memory does "y" occupy?
x <- runif(1e6)
y <- list(x, x, x)

# 3. On which line does "a" get copied in the following example?
a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10
