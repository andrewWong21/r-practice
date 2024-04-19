{
  library(tidyverse)
  library(nycflights13)
}

# dplyr::min_rank() gives smallest values the lowest ranks
x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)

# use desc(x) to give lowest ranks to largest values
min_rank(desc(x))

# variants include dplyr::row_number(), dplyr::dense_rank(), 
# dplyr:: percent_rank(), dplyr::cume_dist()
df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),     # give every input a unique rank
    dense_rank = dense_rank(x),     # min_rank with no gaps (e.g. 1, 2, 2, 3)
    percent_rank = percent_rank(x), # (values < x) / (total # values - 1)
    cume_dist = cume_dist(x)        # (values <= x) / (total # values)
  )

# rank() function in base R can provide the same results with the 
# corresponding value for the ties.method argument

# row_number() can be used without arguments in a dplyr verb
df2 <- tibble(id = 1:10)
df2 |> 
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3,
    three_in_each_group = row0 %/% 3
  )

# dplyr::lead() and dplyr::lag() allow referring to values just before
# or after current value, returns NA-padded vector with same length as input
# optional position argument n that changes offset value, default is 1
y <- c(2, 5, 11, 11, 19, 35)
lag(y)
lead(y)

# v - lag(v) results in difference between current and previous value
y - lag(y)

# v == lag(v) shows when current value changes
y == lag(y)

# -------------------------------------------------------------------------

# 1. Find the 10 most delayed flights using a ranking function. How do you 
# want to handle ties? Carefully read the documentation for min_rank().

# 2. Which plane (tailnum) has the worst on-time record?

# 3. What time of day should you fly if you want to
# avoid delays as much as possible?

# 4. What do the following lines of code do?
flights |> 
  group_by(dest) |> 
  filter(row_number() > 4)

flights |> 
  group_by(dest) |> 
  filter(row_number(dep_delay) > 4)

# 5. For each destination, compute the total minutes of delay. For each flight, 
# compute the proportion of the total delay for its destination.

# 6. Delays are typically temporally correlated: even once the problem that
# caused the initial delay has been resolved, later flights are delayed to
# allow the earlier flights to leave. Using lag(), explore how the average 
# flight delay for an hour relates to the average delay for the previous hour.

# 7. Look at each destination. Can you find flights that are suspiciously fast
# (i.e. flights that represent a potential data entry error)? Compute the
# air time of a flight relative to the shortest flight to that destination.
# Which flights were most delayed in the air?

# 8. Find all destinations that are flown by at least two carriers. Use those
# destinations to come up with a relative ranking of the carriers based on
# their performance for the same destination.