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


# gaps between data can be used to create groups
events <- tibble(
  time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)

# determine if gap between consecutive events is large enough for a new group
events <- events |> 
  mutate(
    diff = time - lag(time, default = first(time)),
    has_gap = diff >= 5
  )
events

# use cumsum() to count true values in has_gap and increment group number
events |> mutate(
  group = cumsum(has_gap)
)

# consecutive_id() starts a new group every time its argument changes
df3 <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)

df3 |> 
  group_by(id = consecutive_id(x)) |> 
  slice_head(n = 1)

# -------------------------------------------------------------------------

# 1. Find the 10 most delayed flights using a ranking function. How do you 
# want to handle ties? Carefully read the documentation for min_rank().
flights |> 
  filter(arr_delay > 0) |> 
  select(c(flight, tailnum, arr_delay)) |> 
  mutate(
    delayed_rank = min_rank(desc(arr_delay))
  ) |> 
  arrange(delayed_rank) |> 
  slice_head(n = 10)


# 2. Which plane (tailnum) has the worst on-time record?
flights |> 
  select(tailnum, arr_delay) |> 
  filter(arr_delay > 0) |> 
  group_by(tailnum) |> 
  mutate(
    mean_delay = mean(arr_delay, na.rm = TRUE),
  ) |> 
  arrange(min_rank(desc(mean_delay)))
  

# 3. What time of day should you fly if you want to
# avoid delays as much as possible?
flights |> 
  group_by(hour) |> 
  filter(hour > 1) |> 
  summarize(mean_delay = mean(arr_delay, na.rm = TRUE)) |> 
  ggplot(aes(x = hour, y = mean_delay)) + 
  geom_point() + 
  geom_smooth(se = FALSE) + 
  coord_fixed()
# flying as early as possible in the day minimizes potential delays
  

# 4. What do the following lines of code do?
  
# group flights by destination and remove the first four rows of each group
flights |> 
  group_by(dest) |> 
  filter(row_number() > 4)

# group flights by destination and remove 
# the four earliest arriving flights in each group
flights |> 
  group_by(dest) |> 
  filter(row_number(dep_delay) < 4)


# 5. For each destination, compute the total minutes of delay. For each flight, 
# compute the proportion of the total delay for its destination.
flights |> 
  filter(!is.na(arr_delay) & arr_delay > 0) |> 
  group_by(dest) |> 
  mutate(
    total_delay = sum(arr_delay, na.rm = TRUE),
    prop_delay = arr_delay / total_delay,
    .keep = "used"
  )


# 6. Delays are typically temporally correlated: even once the problem that
# caused the initial delay has been resolved, later flights are delayed to
# allow the earlier flights to leave. Using lag(), explore how the average 
# flight delay for an hour relates to the average delay for the previous hour.
flights |> 
  filter(dep_delay > 0 & !is.na(dep_delay)) |> 
  group_by(origin) |> 
  mutate(
    prev_delay = lag(dep_delay)
  ) |> 
  ggplot(aes(x = prev_delay, y = dep_delay)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE) + 
  coord_fixed()


# 7. Look at each destination. Can you find flights that are suspiciously fast
# (i.e. flights that represent a potential data entry error)? Compute the
# air time of a flight relative to the shortest flight to that destination.
# Which flights were most delayed in the air?

# order flights by air_time
flights |> 
  filter(!is.na(air_time)) |> 
  select(flight, dest, air_time) |> 
  arrange(air_time)

flights |> 
  filter(!is.na(air_time)) |> 
  group_by(dest) |> 
  mutate(
    min_flight_time = min(air_time, na.rm = TRUE),
    relative_time = air_time - min_flight_time,
    .keep = "used"
  )

# order flights by how long they were delayed in the air
flights |> 
  filter(!is.na(dep_delay) & !is.na(arr_delay)) |> 
  group_by(dest) |> 
  mutate(
    air_delay = arr_delay - dep_delay,
    .keep = "used"
  ) |> 
  arrange(desc(air_delay))


# 8. Find all destinations that are flown by at least two carriers. Use those
# destinations to come up with a relative ranking of the carriers based on
# their performance for the same destination.
flights |> 
  group_by(dest) |> 
  filter(
    n_distinct(carrier) >= 2
  ) |> 
  select(dest, carrier, dep_delay) |> 
  group_by(dest, carrier) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  ) |> 
  mutate(
    perf_rank = min_rank(avg_delay)
  ) |> 
  arrange(dest, perf_rank)
