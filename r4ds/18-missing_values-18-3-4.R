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

# special missing value NaN that usually behaves like NA
z <- c(NA, NaN)
z * 10
z == 1
is.na(z)

# use is.nan(x) if distinguishing NA from NaN is important
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

# may want to convert implicit to explicit to have values to work with
# or convert explicit to implicit by changing structure of data

# pivoting can be used to convert implicit to explicit (pivot wider)
# and explicit to implicit (pivot longer)
# every combination of rows and new columns must have some value

stocks_wider <- stocks |> 
  pivot_wider(
    names_from = qtr,
    values_from = price
  )

# making data longer preserves explicit missing values
stocks_wider |> 
  pivot_longer(
    cols = c(`1`, `2`, `3`, `4`),
    names_to = "qtr",
    values_to = "price"
  )

# structurally missing values due to untidy data can be dropped
# by specifying values_drop_na = TRUE within pivot_longer()
stocks_wider |> 
  pivot_longer(
    cols = c(`1`, `2`, `3`, `4`),
    names_to = "qtr",
    values_to = "price",
    values_drop_na = TRUE
  )

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

# when working with factor groups, some groups may be empty,
# meaning that the group does not contain any observations
health <- tibble(
  name = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
  smoker = factor(c("no", "no", "no", "no", "no"), levels = c("yes", "no")),
  age = c(34, 88, 75, 47, 56)
)

# only non-smokers counted in dataset
health |> count(smoker)

# specify including zero-observation groups in count() with .drop = FALSE
health |> count(smoker, .drop = FALSE)

# ggplot will also drop empty groups by default,
# specify drop = FALSE for the corresponding axis
ggplot(health, aes(x = smoker)) + 
  geom_bar()

ggplot(health, aes(x = smoker)) + 
  geom_bar() + 
  scale_x_discrete(drop = FALSE)

# same problem can occur with dplyr::group_by(), use .drop = FALSE
health |> 
  group_by(smoker, .drop = FALSE) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  )

# summarizing an empty group applies the summary functions to 0-length vectors
# empty vectors have length 0, missing values have length 1
x1 <- c(NA, NA)
length(x1)

x2 <- numeric()
length(x2)

# mean(x) when x is empty returns sum(x)/length(x) = 0/0, which returns NaN
# min(x) and max(x) when x is empty returns -Inf and Inf, respectively
# min(c(x, y)) is always equal to min(min(x), min(y))

# performing the summary, then using complete() results in all summaries
# being NA for the empty group, even though the count should be 0
health |> 
  group_by(smoker) |> 
  summarize(
    n = n(),
    mean_age = mean(age),
    min_age = min(age),
    max_age = max(age),
    sd_age = sd(age)
  ) |> 
  complete(smoker)

# -------------------------------------------------------------------------

# 1. Can you find any relationship between the carrier
# and the rows that appear to be missing from planes?

# flights and airlines datasets have a variable called "carrier"
# planes does not have a "carrier" column, but can be joined with
# flights on the column "tailnum"
colnames(flights)[colnames(flights) %in% colnames(planes)]

carriers <- flights |>
  anti_join(planes, by = "tailnum") |> 
  distinct(carrier) |> 
  pull()

airlines |> 
  filter(carrier %in% carriers)

# planes dataset is missing tailnums for 10 carriers
flights |>
  anti_join(planes, by = "tailnum") |> 
  distinct(carrier) |> 
  left_join(airlines)
