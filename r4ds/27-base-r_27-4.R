library("tidyverse")

# base R equivalent of dplyr::across() is apply() family of functions
# lapply() is similar to purrr::map()
# use [] with lapply() to emulate behavior of across()

# since data frames act as lists of columns, calling lapply() on data frame
# applies function to each column of data frame

df <- tibble(a = 1, b = 2, c = "a", d = "b", e = 4)

# find numeric columns
num_cols <- sapply(df, is.numeric)

# transform columns with lapply() and replace original values
df[, num_cols] <- lapply(df[, num_cols, drop = FALSE], \(x) x * 2)
df

# sapply() is similar to lapply() but tries to simplify result
# simplification may fail, resulting in unexpected type

# vapply() is stricter version of sapply(), short for vector apply
# takes additional argument specifying expected output type

# specify output of is.numeric to return logical vector of length 1
sapply(df, is.numeric)
vapply(df, is.numeric, logical(1))

# distinction is important inside functions to handle unusual inputs

# tapply() computes a single grouped summary
# but returns results as a named vector
# which makes collecting summaries more tedious
diamonds |> 
  group_by(cut) |> 
  summarize(price = mean(price))

tapply(diamonds$price, diamonds$cut, mean)

# apply() works with matrices and arrays
# apply(df, 2, func) is a slow and potentially dangerous version of
# lapply(df, func) but rarely comes up in data science due to
# usage of data frames being more common than matrices
