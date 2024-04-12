{
  library("tidyverse")
  library("nycflights13")
}

# functions for summarizing logical vectors: any() and all()
# any(x) returns TRUE if any values in x are TRUE
# all(x) returns TRUE only if all values in x are TRUE
# both return NA if missing values are present unless na.rm = TRUE is specified

# checking if all departure delays on each day were at most an hour,
# and if any arrival delays for flights on that day were 5 hours or more
flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# numeric summaries allow viewing how many values within a logical vector
# are TRUE or FALSE, rather than just checking if any or all are true
flights |> 
  group_by(year, month, day) |> 
  summarize(
    proportion_delayed = mean(dep_delay <= 60, na.rm = TRUE),
    count_long_delay = sum(arr_delay >= 300, na.rm = TRUE)
  )

# finding average delay for actually delayed flights
flights |> 
  filter(arr_delay > 0) |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay),
    n = n(),
    .groups = "drop"
  )

# using logical vectors to filter a single variable to a subset of interest
# calculating average delays separately for flights that arrived late and
# flights that arrived early
flights |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay < 0], na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# note that NA values are retained with subset operator []
# so they must be removed with na.rm = TRUE
y <- c(1, 5, 3, -1, 2, -4, NA, NA, NA)
y[y > 0]
y[y < 0]

# -------------------------------------------------------------------------

# 1. What will sum(is.na(x)) tell you? How about mean(is.na(x))?

# sum(is.na(x)) returns the number of missing values in x
x <- c(TRUE, FALSE, TRUE, NA, NA, TRUE, FALSE, NA)
sum(is.na(x)) # 3 missing values in x

# mean(is.na(x)) returns the proportion of values in x that are missing
mean(is.na(x)) # 3/8 = 0.375

# 2. What does prod() return when applied to a logical vector? What logical
# summary function is it equivalent to? What does prod() return when applied 
# to a logical vector? What logical summary function is it equivalent to?

# prod is equivalent to all() when applied to a logical vector
# treats TRUE as 1, FALSE as 0, NA as NA
prod(x)                      # NA
prod(x, na.rm = TRUE)        # 0
prod(c(TRUE, TRUE, TRUE))    # 1
prod(c(FALSE, TRUE, TRUE))   # 0
prod(c(FALSE, FALSE, TRUE))  # 0
prod(c(FALSE, FALSE, FALSE)) # 0
# returns FALSE if FALSE is present in the vector,
# since 0 * 1 * 1 * 1 * ... = 0
prod(c(0, 1, 1, 1)) # 0
prod(c(1, 1, 1, 1)) # 1

# min() is also equivalent to all() when applied to a logical vector
# treats TRUE as 1, FALSE as 0, NA as NA
min(x)                       # NA
min(x, na.rm = TRUE)         # 0
min(c(TRUE, TRUE, TRUE))     # 1
min(c(FALSE, TRUE, TRUE))    # 0
min(c(FALSE, FALSE, TRUE))   # 0
min(c(FALSE, FALSE, FALSE))  # 0
# returns FALSE if FALSE is present in the vector,
# since min(0, 1, 1, 1, ...) = 0
min(c(0, 1, 1, 1)) # 0
min(c(1, 1, 1, 1)) # 1

# both prod() and min() are equivalent to all() when applied to logical vectors
