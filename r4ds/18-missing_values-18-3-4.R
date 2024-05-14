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

stock <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(   1,    2,    3,    4,    2,    3,    4),
  price = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# price in 4th quarter of 2020 is explicitly missing, value is NA
# price in 1st quarter of 2021 is implicitly missing, does not appear in data

# -------------------------------------------------------------------------


