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
