{
  library("tidyverse")
  library("repurrrsive")
  library("jsonlite")
}

# data rectangling - convert hierarchical (tree-like) data into
# rectangular data frame made of rows and columns

# vectors are homogenous - every element is of the same data type
x1 <- c(1:4, "a", TRUE)
# lists can contain elements of different types
x1 <- list(1:4, "a", TRUE)

# children of lists can be named like columns in tibbles
x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2

# printing takes up lots of space, str() makes output more compact
# each child is displayed on its own line, works with or without names
str(x1)
str(x2)

# lists can contain lists, useful for representing tree-like structures
x3 <- list(list(1, 2), list(3, 4))
str(x3)

# c() generates a flat vector
x4 <- c(list(1, 2), list(3, 4))
str(x4)

# str() can visualize structure of more complex lists
x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)

# RStudio() has View() for even more complex lists
# allows for interactive expansion of list starting at the top level
# also shows subsetting code for accessing specific elements
View(x5)

# lists can be used in tibbles as list-columns
# used in tidymodels ecosystem to store model outputs and resamples
df <- tibble(
  x = 1:2,
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df

# lists in tibbles behave like other columns
df |> 
  filter(x == 1)

# printing tibble with list-column only shows summary of list contents
# printing list-column contents can be tough when contents are complex
# to view contents, use pull() paired with str() or View()
df |> 
  pull(z) |>
  str()

df |>
  pull(z) |> 
  View()

# lists can be put in a data.frame column
# but data.frame() treats it as a list of columns
data.frame(x = list(1:3, 3:5))

# wrap list with I() to inhibit conversion
# however, result does not print well
data.frame(
  x = I(list(1:2, 3:5)),
  y = c("1, 2", "3, 4, 5")
)

# easier to use list-columns with tibbles
# since tibble() treats lists like vectors
# and printing is designed to handle lists
tibble(x = list(1:3, 3:5))
tibble(
  x = list(1:2, 3:5),
  y = c("1, 2", "3, 4, 5")
)

# lists and list-columns can be turned back into rows and columns
# list-columns may be named or unnamed
# named children of lists usually have the same name in each row

# named list-columns naturally unlist into columns
# each named element becomes a new named column
df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32)
)

# unnamed list-columns tend to vary in length
# naturally unlist into rows - one row for each child
df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32)
)

# unnest_wider() puts each component of list-column into its own column
df1 |> unnest_wider(y)

# new names usually come from names of list elements
# use names_sep argument to combine column name and element name
# useful for disambiguating repeated names
df1 |> 
  unnest_wider(y, names_sep = "_")

# unnest_longer() puts each element of list-column into its own row
df2 |> 
  unnest_longer(y)

# if one element is empty, zero rows are created for output so row disappears
# unless keep_empty is specified as TRUE to add NA for row instead
df6 <- tribble(
  ~x, ~y, 
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> unnest_longer(y)
df6 |> 
  unnest_longer(y, keep_empty = TRUE)

# -------------------------------------------------------------------------


