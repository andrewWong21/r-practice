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
