# data frames and tibbles are S3 vectors built on top of lists

# data frame - named list of vectors
# has attributes names (column names), row.names, and class "data.frame"
df1 <- data.frame(x = 1:3, y = letters[1:3])
df1
typeof(df1)
attributes(df1)

# length of each vector in data frame must be the same
# results in a rectangular structure

# extract row names from data frame using rownames() or row.names()
rownames(df1)
row.names(df1)

# extract column names from data frame using colnames() or names()
colnames(df1)
names(df1)

# extract number of rows or columns in data frame with nrow() or ncol()
nrow(df1)
ncol(df1)

# tibbles are often used to overcome issues with design decisions of data frames
# "lazy and surly" - tibbles do less and complain more

# using tibbles requires tibble package
library(tibble)

# tibbles have multiple classes - "data.frame", "tbl", "tbl_df"
# but share same overall structure with data frames
attributes(tibble())
attributes(data.frame())

df2 <- tibble(x = 1:3, y = letters[1:3])
typeof(df2)
attributes(df2)

# create data frame by supplying name-vector pairs to data.frame()
df <- data.frame(
  x = 1:3, 
  y = c("a", "b", "c")
)
str(df)

# strings are converted to factors by default
# use stringsAsFactors = false to suppress this default behavior
df1 <- data.frame(
  x = 1:3,
  y = c("a", "b", "c"),
  stringsAsFactors = FALSE
)
str(df1)

# create tibbles with name-vector pairs like data frames
# difference: tibbles do not coerce input
df2 <- tibble(
  x = 1:3, 
  y = c("a", "b", "c")
)
str(df2)

# data frames allow for naming rows
df3 <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"),
  row.names = c("Bob", "Susan", "Sam")
)
df3

# row names can be modified and retrieved with rownames()
rownames(df3)

# row names can also be used for subsetting data frames
df3["Bob", ]

# differences in structure between matrices and data frames
# make the usage of row names undesirable
# matrices are transposable while data frames are not
# rows and columns of data frames cannot be interchanged

# metadata should not be stored in a different way from rest of data
# tools for working with column names cannot also be used for row names

# row labels are only useful when rows can be identified by single strings
# rows may be identified with non-character vectors or multiple vectors

# row names must be unique, transformations with row duplications will
# generate rows with different names, making consistent row matching difficult

df3[c(1, 1, 1), ]

# tibbles do not support row names
# but provide tools for converting to column names
# using either rownames_to_column() or rownames argument in as_tibble()

# tibbles show first 10 rows and all columns that can fit on screen
# remaining columns are shown at bottom of display
# column types are provided, abbreviated to 3 or 4 letters
# wide columns are truncated and color may be used in console environments
dplyr::starwars

# data frames and tibbles can be subsetted into 1D or 2D structures
# to behave like lists or matrices, respectively

# certain behaviors of subsetting data frames may be undesirable

# subsetting columns with df[, vars] results in a vector if one variable
# is selected with vars, else a data frame is returned if multiple are selected

# extracting columns with df$x will return any variables prefixed with x
# if no variable exactly matching x exists
# if no variables with prefix x exist, df$x will return NULL

# tibbles always return a tibble when subsetting with []
# when working with $, no partial matching occurs and a warning is generated
# when attempting to subset a tibble with a nonexistent variable

df1 <- data.frame(xyz = "a")
df2 <- tibble(xyz = "a")
df1$x
df2$x

# use [[]] to extract single columns from data frames and tibbles
# in case a data frame output with [] is not desired

# test if an object is a data frame with is.data.frame()
# since tibbles are also data frames, it will return TRUE for tibbles
is.data.frame(df1)
is.data.frame(df2)

# use is_tibble() to check for tibbles in cases where it is important
is_tibble(df1)
is_tibble(df2)

# a data frame is a list of vectors, so a column of a data frame can be a list
# since a list can contain any object, any object can be placed in a data frame
# related objects can be kept in the same row regardless of complexity

# list columns can be added to data frames after creation
# or wrapped in I() (identity function) during creation
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)
df

data.frame(
  x = 1:3,
  y = I(list(1:2, 1:3, 1:4))
)

# list columns can be included directly inside tibble(), have tidier printing
tibble(
  x = 1:3,
  y = list(1:2, 1:3, 1:4)
)

# data frame columns can also be arrays or matrices
# if number of rows matches data frame - NROW() must be equal for each column

# same with list-columns: wrap with I() during creation or add after creation
dfm <- data.frame(
  x = 1:3 * 10
)
dfm

dfm$y <- matrix(1:9, nrow = 3)
dfm

dfm$z <- data.frame(a = 3:1, b = letters[1:3], stringsAsFactors = FALSE)
dfm

# many functions for data frames assume vector columns
# printed displays can be confusing for 
# data frames with matrix and data frame columns
dfm
dfm[1, ]

# -------------------------------------------------------------------------

# 1. Can you have a data frame with zero rows and zero columns?

# 2. What happens if you attempt to set rownames that are not unique?

# 3. If df is a data frame, what can you say about t(df), and t(t(df))?
# Perform some experiments, making sure to try different column types.

# 4. What does as.matrix() do when applied to a data frame with columns of 
# different types? How does it differ from data.matrix()?
