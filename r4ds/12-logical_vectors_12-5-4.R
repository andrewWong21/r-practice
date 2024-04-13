{
  library("tidyverse")
  library("nycflights13")
}

# dplyr::if_else() has three main arguments: `condition`, `true``, `false`
# `condition` is a logical vector, `true` and `false` are outputs for result
x <- c(-3:3, NA)
if_else(x > 0, "+ve", "-ve")

# optional fourth argument `missing` specifies output for NA values
if_else(x > 0, "+ve", "-ve", "???")

# vectors can be provided for `true` and `false`
if_else(x > 0, x, -x)

# coalesce() function is similar to SQL - finds first non-missing value at each
# position given a set of vectors, can be implemented with if_else()
x1 <- c(NA, 1, 2, NA)
y1 <- c(3, NA, 4, 6)

if_else(is.na(x1), y1, x1)

# if_else can be chained, but this reduces readability
if_else(x == 0, "0", if_else(x > 0, "+ve", "-ve"), "???")

# dplyr::case_when() is inspired by CASE statement in SQL
case_when(
  x == 0 ~ "0",
  x < 0 ~ "+ve",
  x > 0 ~ "-ve",
  is.na(x) ~ "???"
)

# if no cases match, output is assigned NA
case_when(
  x < 0 ~ "+ve",
  x > 0 ~ "-ve",
  is.na(x) ~ "???"
)

# specify .default argument for catch-all value
case_when(
  x < 0 ~ "+ve",
  x > 0 ~ "-ve",
  .default = "???"
)

# output is assigned on first match if multiple conditions match
case_when(
  x > 0 ~ "+ve",
  x > 2 ~ "big"
)

# variables can be used as needed on both sides of ~
flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)     ~ "cancelled",
      arr_delay < -30      ~ "very early",
      arr_delay < -15      ~ "early",
      abs(arr_delay) <= 15 ~ "on time",
      arr_delay < 60       ~ "late",
      arr_delay < Inf      ~ "very late"
    ),
    .keep = "used"
  )

# -------------------------------------------------------------------------

# 1. A number is even if it's divisible by 2, which can be checked with
# x %% 2 == 0. Use this fact and if_else to determine whether each number
# between 0 and 20 is even or odd.

if_else(c(0:20) %% 2 == 0, "even", "odd")


# 2. Given a vector of days, use an if_else() statement to label them as
# weekends or weekdays.
days <- c(
  "Monday", "Tuesday", "Wednesday", "Thursday",
  "Friday", "Saturday", "Sunday"
  )
if_else(str_detect(days,  "^S"), "weekend", "weekday")


# 3. Use if_else() to compute the absolute value of a numeric vector called x.
if_else(x >= 0, x, -x)


# 4. Write a case_when() statement that uses the month and day columns from
# flights to label a selection of important US holidays (e.g. New Years Day,
# 4th of July, Thanksgiving, and Christmas). First create a logical column
# that is either TRUE or FALSE, and then create a character column that gives
# the name of the holiday or is NA.

