# 1. What is the difference between subsetting a vector with positive integers,
# negative integers, a logical vector, or a character vector?

# 2. What’s the difference between [, [[, and $ when applied to a list?

# 3. When should you use drop = FALSE?

# 4. If x is a matrix, what does x[] <- 0 do? How is it different from x <- 0?

# 5. How can you use a named vector to relabel categorical variables?

# multiple interrelated concepts required to internalize
# in order to master subsetting in R

# six ways of subsetting atomic vectors

# subsetting operators [], [[]], and $

# different interactions of subsetting operators with different vector types
# e.g. atomic vectors, lists, factors, matrices, and data frames

# combining subsetting with assignment - subassignment

# str() shows all pieces and structure of an object,
# while subsetting extracts parts important to current projects

# [] is used to select any number of elements from a vector
# can be generalized beyond 1D vectors to objects with more complex structures
x <- c(2.1, 4.2, 3.3, 5.4)

# subsetting with positive integers returns elements at specified positions
x[c(3, 1)]

# duplicating an integer also duplicates the value
x[c(1, 1)]

# real numbers will be truncated silently - only integer part is considered
x[c(2.1, 2.9)]

# subsetting with negative integers excludes elements at specified positions
x[-c(3, 1)]

# negative integers may only be mixed with 0 when subsetting
x[c(-1, 2)] # throws an error
x[c(-1, 0)]

# logical vectors select elements where corresponding indices are TRUE
x[c(TRUE, TRUE, FALSE, FALSE)]

# logical expressions can be used in place of raw TRUE or FALSE values
x[x > 3]


# recycling rules are applied to x[y] when x and y are different lengths
# shorter vector is recycled to length of longer vector
x[c(TRUE, FALSE)]
x[c(TRUE, FALSE, TRUE, FALSE)]

# convenient if either vector is of length 1
# but rules are not applied consistently for other lengths in base R

# missing values in index will result in missing value in output
x[c(TRUE, TRUE, NA, FALSE)]

# subsetting with [] without arguments returns original vector
# more useful for matrices, arrays, and data frames than for vectors
x[]

# subsetting with [0] returns an empty vector, can be useful for test data
x[0]

# named vectors allow for use of character vectors when subsetting
y <- setNames(x, letters[1:4])
y
y[c("d", "c", "a")]

# character vector indices can be repeated
y[c("a", "a", "a")]

# names must match exactly when subsetting with character vectors
# otherwise NA is returned for nonexistent name
z <- c(abc = 1, def = 2)
z[c("a", "d")]

# avoid subsetting with factors - underlying integer value will be used instead
y[factor("b")]
