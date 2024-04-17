{
  library(tidyverse)
  library(nycflights13)
}

# most transformation functions are already built into base R
# output is always same length as input, so they work well with mutate()

# R uses recycling rule: when left and right hand side have different lengths,
# the shorter vector is repeated, or recycled until longer vector is matched

x <- c(1, 2, 10, 20)
x / 5
x / c(5, 5, 5, 5)

# R will recycle any short vector, even if length is not 1
x * c(1, 2)
# warning will be thrown if shorter length is not a multiple of longer length
x * c(1, 2, 3)

# recycling can cause unexpected behavior with logical comparisons
flights |> 
  filter(month == c(1, 2))
# does not filter for all flights in January and February, but
# flights in odd-numbered rows that departed in January and
# flights in even-numbered rows that departed in February
# no warning since original number of rows (336,776) is divisible by 2

# correct output is provided with the following code:
flights |> 
  filter(month %in% c(1, 2))

df <- tribble(
  ~x, ~y,
  1, 3,
  5, 2,
  7, NA
)

# pmin() and pmax() return smallest or largest value in each row, respectively
df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

pmin(c(1, 3), c(5, 2), c(7, NA), na.rm = TRUE)
pmax(c(1, 3), c(5, 2), c(7, NA), na.rm = TRUE)

# note difference in output compared to using max() or min(), which are 
# different because they return single values only
df |> 
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )

# %/% does integer division, %% computes remainder
1:10 %/% 3
1:10 %% 3

# with %/% and %%, sched_dep_time can be unpacked into hour and minute
flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    .keep = "used"
  )

# plotting how proportion of cancelled flights varies throughout the day
flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") +
  geom_point(aes(size = n))

# R provides log(), log2(), and log10() for logarithms in base e, 2, 10
# a difference of 1 on log2() scale represents doubling, -1 is halving
# log10() is easy to back-transform with 10^x
# inverse of log() is exp()

# -------------------------------------------------------------------------

# 1. Explain in words what each line of the code
# used to generate Figure 13.1 does.

# 2. What trigonometric functions does R provide? Guess some names and
# look up the documentation. Do they use degrees or radians?

# 3. Currently dep_time and sched_dep_time are convenient to look at, but hard
# to compute with because they're not really continuous numbers. You can see
# the basic problem by running the code below, showing a gap between each hour.
flights |> 
  filter(month == 1, day == 1) |> 
  ggplot(aes(x = sched_dep_time, y = dep_delay)) + 
  geom_point()
# Convert them to a more truthful expression of time, either fractional hours
# or minutes since midnight.

# 4. Round dep_time and arr_time to the nearest five minutes.