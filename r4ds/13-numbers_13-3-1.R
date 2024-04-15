{
  library(tidyverse)
  library(nycflights13)
}

# numbers are usually recorded as integers or doubles
# numbers may sometimes appear as strings due to column pivoting
# or problems with data importing process

# readr provides two parsing functions for converting strings to numbers:

# parse_double() for converting numbers written as strings
x <- c("1.2", "5.6", "1e3")
parse_double(x)

# parse_number() for ignoring all non-numeric text in string
y <- c("$1,234", "USD 5,313", "59%")
parse_number(y)

# count() is useful for quick exploration and checks during analysis
flights |> count(dest)

# sort by most common values with sort = TRUE
flights |> count(dest, sort = TRUE)

# same result can be achieved with group_by(), summarize(), and n(),
# but other summaries can be computed at the same time as well
flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

# n() does not take any arguments,
# accesses information about current group only,
# so it does not work outside of dplyr verbs
n()

# n_distinct() counts number of distinct values of one or more variables
flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

# calculating weighted count of miles for each plane
flights |>
  group_by(tailnum) |> 
  summarize(miles = sum(distance))

# specify wt in count() for calculating weighted counts
flights |> count(tailnum, wt = distance)

# count missing values by combining sum() and is.na()
flights |> 
  group_by(dest) |> 
  summarize(n_cancelled = sum(is.na(dep_time)))

# -------------------------------------------------------------------------

# 1. How can you use count() to count the number rows with
# a missing value for a given variable?

df <- tibble(
  x = c(1, 2, 3, 4, 5, 6, 7, 8),
  y = c(3, NA, 7, NA, NA, 5, 4, 2)
)

df |> count(is.na(y))


# 2. Expand the following calls to count()
# to instead use group_by(), summarize(), and arrange():

flights |> count(dest, sort = TRUE)

flights |> 
  group_by(dest) |> 
  summarize(n = n()) |> 
  arrange(desc(n))

flights |> count(tailnum, wt = distance)

flights |> 
  group_by(tailnum) |> 
  summarize(n = sum(distance))
