library("lobstr")

# use lobstr::obj_size() to find out the size of an object in memory
obj_size(letters)
obj_size(ggplot2::diamonds)

# elements of lists are references to values, references are very small objects
x <- runif(1e6)
obj_size(x)
y <- list(x, x, x)
obj_size(y)

# size of empty list with 3 elements is 80 bytes
obj_size(list(NULL, NULL, NULL))

# R uses global string pool 
# repeating a string is more memory efficient than expected
banana <- "bananas bananas bananas"
obj_size(banana)
obj_size(rep(banana, 100))

# shared values between objects means size(x) + size(y) < size(x, y)
obj_size(x, y)

# alternative representation is a feature in later versions of R
# vector representations are represented more compactly
# R stores only first and last numbers of sequences
# all sequences are the same size in memory
obj_size(1:3)
obj_size(1:1e3)
obj_size(1:1e6)
obj_size(1:1e9)

# -------------------------------------------------------------------------

# 1. In the following example, why are object.size(y) and obj_size(y)
# so radically different? Consult the documentation of object.size().
y <- rep(list(runif(1e4)), 100)
object.size(y)
obj_size(y)

# object.size does not detect shared elements within a list
# provides rough memory indication

# obj_size accounts for all types of shared values
# accounts for size of environments associated with objects


# 2. Take the following list. Why is its size somewhat misleading?
funs <- list(mean, sd, var)
obj_size(funs)
obj_size(list(NULL, NULL, NULL))
obj_size(mean)
obj_size(sd)
obj_size(var)

# mean, sd, and var are built-in functions within R and do not take up
# extra space in the same sense as user-defined functions and variables


# 3. Predict the output of the following code:
a <- runif(1e6)
obj_size(a)

# empty list and double vector have size of 48 bytes
obj_size(list())
obj_size(double())

# double object has size of 8 bytes
obj_size(double(1))

# vector of 1 million doubles has size of (1,000,000) * 8 + 48 bytes
obj_size(a)


b <- list(a, a)
obj_size(b)
obj_size(a, b)

# b is list of two elements pointing to same address in memory
ref(a, b)

# size of b is 48 bytes for list + 16 bytes (8 for each element) + size of a
# for a total of 8,000,064 bytes
obj_size(b)

b[[1]][[1]] <- 10
obj_size(b)
obj_size(a, b)

# copy-on-modify occurs, new double of size 8,000,048 bytes created
# size of b is 64 bytes for list of size 2 + 16,000,096 (2 doubles)
# for a total of 16,000,160 bytes

b[[2]][[1]] <- 10
obj_size(b)
obj_size(a, b)

# copy-on-modify, b no longer shares references with a
# sum of sizes of b and a is 24,000,208 bytes
