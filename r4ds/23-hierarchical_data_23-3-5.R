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

# lists and list-columns can be turned back into regular rows and columns
# list-columns may be named or unnamed
# named children of list-columns usually have the same name in each row

# named list-columns naturally unlist into columns
# each named element becomes a new named column
df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32)
)

# unnamed list-columns tend to vary in length
# naturally unnest into rows - one row for each child
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
# x is duplicated for each element in y, one row for each element
df2 |> unnest_longer(y)

# if one element is empty, zero rows are created for output so row disappears
# unless keep_empty is specified as TRUE to add NA for row instead
df3 <- tribble(
  ~x, ~y, 
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df3 |> unnest_longer(y)
df3 |> 
  unnest_longer(y, keep_empty = TRUE)

# unnesting a list-column containing different types of vector
# y contains two numbers, a character, and a logical
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)

# unnest_longer() keeps set of columns unchanged while keeping number of rows
# four rows are produced, every element of list-column contains one element
# since no common vector can be found between the elements
# every element of y is still the same type, though content types differ
df4 |> unnest_longer(y)

# unnest_auto() picks between unnest_wider() and unnest_longer() depending on
# data structure, good for rapid exploration but does not help with
# understanding data structure and makes code harder to read

# unnest() expands both rows and columns, used for list-columns with
# 2D structures like data frames

# -------------------------------------------------------------------------

# 1. What happens when you use unnest_wider() with unnamed list-columns
# like df2? What argument is now necessary? What happens to missing values?

# column y in df2 has unnamed list-columns of varying lengths
# attempting to use unnest_wider() with y throws an error
df2 |> unnest_wider(y)

# requires names_sep argument to generate automatic names
df2 |> unnest_wider(y, names_sep = "_")

# missing values are converted to NA
df3 |> unnest_wider(y, names_sep = "_")

# 2. What happens when you use unnest_longer() with named list-columns
# like df1? What additional information do you get in the output?
# How can you suppress that extra detail?

# using unnest_longer() with named list-column does not throw an error
# adds _id column prefixed with the unnested column
# with values being the name of the corresponding element
df1 |> unnest_longer(y)

# suppress index column by specifying indices_include = FALSE
df1 |> unnest_longer(y, indices_include = FALSE)


# 3. From time-to-time you encounter data frames with multiple list-columns 
# with aligned values. For example, in the following data frame, the values of 
# y and z are aligned (i.e. y and z will always have the same length within a
# row, and the first value of y corresponds to the first value of z).
# What happens if you apply two unnest_longer() calls to this data frame?
# How can you preserve the relationship between y and z?
df5 <- tribble(
  ~x, ~y, ~z,
  "a", list("y-a-1", "y-a-2"), list("z-a-1", "z-a-2"),
  "b", list("y-b-1", "y-b-2"), list("z-b-1", "z-b-2")
)

# applying two unnest_longer() calls results in Cartesian product of rows
df5 |> 
  unnest_longer(y) |> 
  unnest_longer(z)

# unnest aligned columns simultaneously by passing a vector of list-columns
df5 |> 
  unnest_longer(c(y, z))
