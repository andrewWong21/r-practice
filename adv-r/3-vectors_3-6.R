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
library(tibble)
