{
  library("tidyverse")
  library("nycflights13")
}

# transformations to free-floating vectors can also be
# performed on variables within dataframes
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

df <- tibble(x)
df |> 
  mutate(y = x * 2)

# filter() uses a transient logical vector to find rows with conditions
# find all daytime flights that arrived roughly on time
flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

# mutate can create explicit logical variables
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )

# showing intermediate steps can make for better readability and error checking

flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  ) |> 
  filter(daytime & approx_ontime)

# == can have unexpected behavior with numbers
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x
x == c(1, 2)

# print with digits argument shows more exact value of stored variables
print(x, digits = 16)

# dplyr::near() ignores small differences
near(x, c(1, 2))

# most operations involving NA will also result in NA
NA > 5
10 == NA
NA == NA

# filter() drops missing values so checking for NA with == does not work
flights |> 
  filter(dep_time == NA)

# is.na(x) returns boolean depending on whether variable is NA
is.na(c(TRUE, NA, FALSE))
is.na(c(1, NA, 3))
is.na(c("a", NA, "b"))

flights |> 
  filter(is.na(dep_time))

# arrange()'s default sorting of putting missing values last can be
# overridden by first sorting by is.na()
flights |> 
  filter(month == 1, day == 1) |> 
  arrange(desc(is.na(dep_time)), dep_time)

# -------------------------------------------------------------------------

# 1. How does dplyr::near() work? Type near to see the source code.
# Is sqrt(2)^2 near 2?

# near calculates the absolute value of the difference of the two arguments
# x and y and returns true if their difference is less than the square root of
# .Machine$double.eps, which itself is equal to 2.220446e-16

# sqrt(2)^2 is near 2
near(sqrt(2)^2, 2)


# 2. Use mutate(), is.na(), and count() together to see how the missing values
# in dep_time, sched_dep_time, dep_delay are connected.
flights_na <- flights |> 
  mutate(
    missing_dep_time = is.na(dep_time),
    missing_sched_dep = is.na(sched_dep_time),
    missing_dep_delay = is.na(dep_delay),
    .keep = "used"
  )
flights_na

# either dep_time and dep_delay are both NA or neither are
flights_na |> 
  count(missing_dep_time, missing_dep_delay, missing_sched_dep)
# 8,255 flights with missing dep_time and dep_delay (cancelled flights)

# sched_dep_time is never NA, all flights have specified scheduled departure
# time regardless of cancellation status
flights_na |> 
  count(missing_sched_dep)
