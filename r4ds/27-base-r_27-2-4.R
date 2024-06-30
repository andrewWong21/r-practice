library("tidyverse")

# [] extracts subcomponents from vectors or data frames, e.g. x[i] x[i, j]

# five types of things that vectors can be subsetted with

# vector of positive integers keeps elements at specified positions
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]

# positions can be repeated, creating output longer than input
x[c(1, 1, 5, 5, 5, 2)]

# vector of negative integers drops elements at specified positions
x[c(-1, -3, -5)]

# vector of logical values keeps values corresponding to TRUE
y <- c(10, 3, NA, 5, 8, 1, NA)

# keep non-missing values of y
y[!is.na(y)]

# keep even and missing values of y
# NA values are included in output as NA
# unlike filter() which drops values corresponding to NA
y[y %% 2 == 0]

# vector of characters
# named vectors can be subsetted with character vectors
z <- c(abc = 1, def = 2, xyz = 5)
z[c("xyz", "def")]

# subsetting with nothing returns complete vector
# not useful for vectors but useful for subsetting 2D structures
x[]
y[]
z[]

# many ways to use [] with data frame, covered in Advanced R book
# most important way is selecting rows and columns independently
# i.e. df[rows, cols] where rows and cols are vectors
# df[rows, ] selects specific rows, df[, cols] selects specific columns
df <- tibble(
  x = 1:3,
  y = c("a", "e", "f"),
  z = runif(3)
)
df

# select first row, second column
df[1, 2]

# select all rows and columns x and y
df[, c("x", "y")]

#select rows with x > 1 and all columns
df[df$x > 1, ]

# $ extracts variable from data frame in the form df$var
# [] does not use tidy evaluation, so source of variable must be made explicit

# tibbles are data frames with some more convenient behaviors
# R's built-in data frame is data.frame

# if df is a data.frame:
# df[, cols] returns a vector if one column is selected
# df[, cols] returns a data frame if more than one column is selected
df1 <- data.frame(x = 1:3)
df1
df1[, "x"]

# if df is a tibble then [] always returns a tibble
df2 <- tibble(x = 1:3)
df2
df2[, "x"]

# avoid ambiguity with data.frame by explicitly specifying drop = FALSE
df1[, "x", drop = FALSE]
typeof(df1[, "x"])
typeof(df1[, "x", drop = FALSE])

# several dplyr verbs are special cases of []
# filter() subsets rows with a logical vector, excluding missing values
df3 <- tibble(
  x = c(2, 3, 1, 1, NA),
  y = letters[1:5],
  z = runif(5)
)
df3

# equivalent statements
df3 |> filter(x > 1)
df3[!is.na(df3$x) & df3$x > 1, ]

# which() drops missing values
df3[which(df3$x > 1), ]
df3[df3$x > 1, ]

# arrange() subsets rows with integer vector, usually created with order()
df3 |> arrange(x, y)
df3[order(df3$x, df3$y), ]

# use order(decreasing = TRUE) to sort all columns in decreasing order
df3[order(df3$x, df3$y, decreasing = TRUE), ]

# use -rank(col) to sort columns in decreasing order individually
df3[order(-rank(df3$x), -rank(df3$y)), ]
df3[order(-rank(df3$x), df3$y), ]
df3[order(df3$x, -rank(df3$y)), ]

# select() and relocate() subset columns with character vector
df3 |> select(x, z)
df3[, c("x", "z")]

# base R provides subset() which is equivalent to combining
# dplyr's filter() and select()
df3 |> 
  filter(x > 1) |> 
  select(y, z)

df3 |> subset(x > 1, c(y, z))

# -------------------------------------------------------------------------

# 1. Create functions that take a vector as input and return:

v <- c(1, 2, NA, 4, 5, NA, 7, 8, NA, NA, NA, 12)
v

# a. The elements at even-numbered positions.
even_pos <- function(v){
  v[c(FALSE, TRUE)]
}
v |> even_pos()

# b. Every element except the last value.
except_last <- function(v){
  v[-length(v)]
}
v |> except_last()

# c. Only even values (and no missing values).
even_not_na <- function(v){
  v[which(v %% 2 == 0)]
}
v |> even_not_na()

# 2. Why is x[-which(x > 0)] not the same as x[x <= 0]?
w <- c(-Inf, -7, -6, -5, NA, -3, 0, NA, 1, 2, 3, NA, 5, 6, NaN, Inf)

# difference is in how NaN is treated, using which() converts it to NA
w[-which(w > 0)]
w[w <= 0]
