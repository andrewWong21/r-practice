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

# subsetting lists works similarly to atomic vectors
# [] returns a list, [[]] and $ will extract specified elements

# higher-dimensional structures like arrays and matrices
# allow subsetting with one or more vectors, or a matrix

a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a

# 1D subsetting can be generalized for matrices and arrays
# by supplying comma-separated 1D indices for each dimension

# blank subsetting allows keeping all rows or columns
# retrieve first and second rows, all columns
a[1:2, ]

# retrieve first and third rows, ordered by second then first column
a[c(TRUE, FALSE, TRUE), c("B", "A")]

a[0, -2]

# [] simplifies results to lowest possible dimensionality
# which means some results may be outputted in 1D vector form
a[1, ]
a[1, 1]

# matrices and arrays can be subsetted with a single 1D vector
vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
vals

# arrays are stored in column-major order
# return 4th and 15th values in matrix
vals[c(4, 15)]

# higher-dimensional data structures can be subsetted with an integer matrix
# character matrices can also be used in cases of named structures

# rows represent locations of values, columns correspond to dimensions
# generalization - n-column matrix for subsetting n-dimensional structure
select <- matrix(ncol = 2, byrow = TRUE, c(
  1, 1,
  3, 1,
  2, 4
))
vals[select]

# data frames behave like lists when subsetting with single indices
# using indices to select columns
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df

# select first two columns
df[1:2]

# select rows where x = 2
df[df$x == 2, ]

# select rows 1 and 3
df[c(1, 3), ]

# select first 3 rows
df[1:3, ]

# columns can be selected from a data frame like a list
df[c("x", "z")]

# or like a matrix
df[, c("x", "z")]

# when selecting single columns, matrix subsetting simplifies output
str(df[, "x"])
# list subsetting a single column of a data frame returns another data frame
str(df["x"])

# subsetting a tibble always returns a tibble regardless of subsetting type
df2 <- tibble::tibble(df)
df2

str(df2["x"])
str(df2[, "x"])

# subsetting matrices and data frames with a single number, name, or
# logical vector with a single TRUE will return lower dimensions by default
# use drop = FALSE to maintain original dimensionality in output
# recommended to specify explicitly when writing functions with 2D objects

# dimensions of length 1 will be dropped for matrices and arrays
a <- matrix(1:4, nrow = 2)
str(a[1, ])
str(a[1, , drop = FALSE])

# data frames with single columns will return column contents
df3 <- data.frame(a = 1:2, b = 1:2)
str(df3[, "a"])
str(df3[, "a", drop = FALSE])

# tibbles default to drop = FALSE

# -------------------------------------------------------------------------
