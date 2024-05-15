library("tidyverse")

# missing values may indicate values in the previous row being carried forward
treatment <- tribble(
  ~person,           ~treatment, ~response,
  "Derrick Whitmore", 1,         7,
  NA,                 2,         10,
  NA,                 3,         NA,
  "Katherine Burke",  1,         4
)

# fill in missing values with tidyr::fill(), which takes a set of columns
# supports last observation carried forward by default,
# use .direction argument to handle other cases (down, up, downup, updown)
treatment |> 
  fill(everything())

# missing values may represent fixed and known value, usually 0
# replace NA with dplyr:coalesce()
x <- c(1, 4, 5, 7, NA)
coalesce(x, 0)

# older software may generate data with fixed values like 99 or -99
# representing NA due to lack of proper representation of missing values
y <- c(1, 4, 5, 7, -99)
na_if(y, -99)

z <- c(NA, NaN)
z * 10
z == 1
is.na(z)

# use is.nan() if distinguishing NA from NaN is important
is.nan(z)

# NaN occurs when performing mathematical operation with indeterminate result
0 / 0
0 * Inf
Inf - Inf
sqrt(-1)

# explicit missing values - denoted with NA or NaN  (presence of absence)
# implicit missing values - entire rows are missing (absence of presence)

stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# price in 4th quarter of 2020 is explicitly missing, value is NA
# price in 1st quarter of 2021 is implicitly missing, does not appear in data

# pivoting makes implicit missing values explicit
# every combination of rows and new columns must have some value

stocks |> 
  pivot_wider(
    names_from = qtr,
    values_from = price
  )

# making data longer preserves explicit missing values
# structurally missing values due to untidy data can be dropped
# by specifying values_drop_na = TRUE

# tidyr::complete() allows generating explicit missing values by defining
# a combination of rows that should exist from the values of certain variables
stocks |> 
  complete(year, qtr)

# complete() is usually called with names of existing variables,
# but individual variables may sometimes be incomplete
# so self-defined ranges and vectors can be provided

# all rows for each quarter of the year 2019 are missing
stocks |> 
  complete(year = 2019:2021, qtr)

# when a range is correct but not all values are present,
# use full_seq(x, step) to generate values from min(x) to max(x), spaced by step

# if complete set of variables cannot be generated from a combination,
# build a data frame with all required rows for groups of columns
# and combine it with the original dataset using dplyr::full_join()

# sometimes missing values can only be found when comparing to other datasets
# dplyr::anti_join(x, y) selects only rows in x that do not match in y
library("nycflights13")

# airports dataset is missing 4 airport names listed in flights
flights |> 
  distinct(faa = dest) |> 
  anti_join(airports)

# planes dataset is missing 722 tailnum values listed in flights
flights |> 
  distinct(tailnum) |> 
  anti_join(planes)

# -------------------------------------------------------------------------

# 1. Can you find any relationship between the carrier and the rows that appear
# to be missing from planes?
