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
view(x5)

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

# lists and list-columns can be turned back into rows and columns
