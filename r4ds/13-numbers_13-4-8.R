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

# round() rounds to nearest integer
x = 123.456
round(x)

# round to nearest 10^-n with round(x, digits = n)
round(x, 2)
round(x, 1)
round(x, 0)
round(x, -1)
round(x, -2)

# round() uses banker's rounding - rounds to the nearest even integer
# when exactly halfway between two integers
round(c(1.5, 2.5))

# floor() rounds down, ceiling() rounds up, no digits argument
floor(x)
ceiling(x)

# floor and ceiling do not use digits argument unlike round()
# scale down and back up as needed to round up/down to specific places
floor(x / 0.01) * 0.01   # round down to nearest 0.01
ceiling(x / 0.01) * 0.01 # round up to nearest 0.01

# can also round to nearest multiples in this way
round(x / 4) * 4

round(x / 0.25) * 0.25

# use cut() to bin a numeric vector into discrete buckets
y <- c(1, 2, 5, 10, 15, 20)
cut(y, breaks = c(0, 5, 10, 15, 20))

# breaks can be unevenly spaced if needed
cut(y, breaks = c(0, 5, 10, 100))

# labels can be supplied, there should be one fewer label than there are breaks
cut(y,
  breaks = c(0, 5, 10, 15, 20),
  labels = c("small", "medium", "large", "extra large")
)

# values outside breaks will become NA
z <- c(NA, -10, 5, 10, 30)
cut(z, breaks = c(0, 5, 10, 15, 20))

# interval types can be changed with right and include.lowest arguments

# cumulative (running) sums, products, mins, maxes
# can be calculated in base R with cumsum(), cumprod(), cummin(), cummax()
nums <- 1:10
cumsum(nums)

# dplyr provides cumulative means with cummean()
# slider package provides more complex rolling or sliding aggregate functions

# -------------------------------------------------------------------------

# 1. Explain in words what each line of the code
# used to generate Figure 13.1 does.

flights |> 
  # group flights by the hour of their scheduled departure time, rounded down
  group_by(hour = sched_dep_time %/% 100) |> 
  # calculate proportion of cancelled flights (missing departure time)
  # for each group by dividing the number of cancelled flights by group size
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  # filter flights to those scheduled to depart at 2 AM and later
  # (remove group with outlier of 1 flight that was cancelled, proportion 100%)
  filter(hour > 1) |> 
  # plot proportion of flights vs. flight departure hour
  ggplot(aes(x = hour, y = prop_cancelled)) +
  # draw lines between proportions of cancelled flights in consecutive hours
  geom_line(color = "grey50") + 
  # indicate how many flights are grouped into the hour by point size
  geom_point(aes(size = n))


# 2. What trigonometric functions does R provide? Guess some names and
# look up the documentation. Do they use degrees or radians?

# sin, cos, tan for sine, cosine, tangent
# asin, acos, atan for arc-sine, arc-cosine, arc-tangent
# atan2(y, x) returns angle between x-axis and vector from (0, 0) to (x, y)
# sinpi, cospi, tanpi compute cos(pi*x), sin(pi*x), tan(pi*x)

# angles are measured in radians, not degrees


# 3. Currently dep_time and sched_dep_time are convenient to look at, but hard
# to compute with because they're not really continuous numbers. You can see
# the basic problem by running the code below, showing a gap between each hour.
flights |> 
  filter(month == 1, day == 1) |> 
  ggplot(aes(x = sched_dep_time, y = dep_delay)) + 
  geom_point()
# Convert them to a more truthful expression of time, either fractional hours
# or minutes since midnight.

flights |> 
  mutate(
    fractional_hours = hour + minute / 60,
    mins_since_midnight = 60 * hour + minute, # 60 * fractional_hours,
    .keep = "used"
  )


# 4. Round dep_time and arr_time to the nearest five minutes.
flights |> 
  mutate(
    rounded_dep_time = round(dep_time / 5) * 5,
    rounded_arr_time = round(arr_time / 5) * 5,
    .keep = "used"
  )
