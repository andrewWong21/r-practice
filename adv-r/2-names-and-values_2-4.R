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
