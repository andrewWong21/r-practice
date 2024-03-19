library("tidyverse")
library("nycflights13")

# use pipe to combine multiple verbs in readable format
# check "Use native pipe operator" in settings to enable Ctrl+Shift+M shortcut for |> 
# find fastest flights to Houston (IAH)
flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# alternatively, verb calls can be nested
arrange(
  select(
    mutate(
      filter(
        flights, dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

# or passed to intermediate objects
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))

# group_by() divides dataset into groups for analysis
# does not directly change data but affects how subsequent verbs are applied
flights |> group_by(month)

# summarize() reduces a grouped dataframe into a single row for each group
flights |> 
  group_by(month) |> 
  summarize(
    mean_delay = mean(dep_delay)
  )
# the previous code results in a mean delay of NA for all months 
# due to some rows having missing values in the dep_delay column,
# so na.rm = TRUE must be specified within mean() to ignore missing values
flights |> 
  group_by(month) |> 
  summarize(
    mean_delay = mean(dep_delay, na.rm = TRUE)
  )

# n() is used within summarize() to return the number of rows in each group
flights |> 
  group_by(month) |> 
  summarize(
    mean_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

# slice_() functions allow extracting specific rows within each group
# slice_head(n = 1) takes first row of group
# slice_tail(n = 1) takes last row of group
# slice_min(x, n = 1) takes row of group with minimum value in column x
# slice_max(x, n = 1) takes row of group with maximum value in column x
# slice_sample(n = 1) takes random row of group

# n is used to specify number of rows of slice
# alternatively, use prop to specify proportion of dataframe
# e.g. prop = 0.1 to select 10% of rows in group
flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |> 
  relocate(dest)
# note that slice_min() and slice_max() keep tied values by default
# if multiple rows are tied for highest/lowest column value
# n = 1 returns all of them unless the argument with_ties = FALSE is specified

# groups can be made using multiple variables
daily <- flights |> 
  group_by(year, month, day)
daily

daily_flights <- daily |> 
  summarize(n = n())
daily_flights
# the default behavior of summarize() with groups of multiple variables
# is to drop the last grouping after summarizing
# dplyr displays a message that this behavior can be overridden with the argument .groups
# .groups = "drop_last" explicitly specifies this and suppresses the message
# .groups = "keep" maintains the original grouping structure before applying summarize()
daily_flights <- daily |> 
  summarize(
    n = n(), 
    .groups = "keep"
  )
daily_flights

# ungroup() removes all groupings from a dataframe
daily |> 
  ungroup()

# summarizing an ungrouped dataframe treats all rows as part of one group
daily |> 
  ungroup() |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )

# dplyr 1.1.0 supports per-operation grouping using the argument .by
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )
# .by works with all groups and does not require suppressing grouping message with .groups
# or using ungroup() to work with full dataframe for later operations

# --------------------------------------------------------------------------------

# 1. Which carrier has the worst average delays?
# Can you disentangle the effects of bad carriers vs. bad airports?
flights |> 
  group_by(carrier) |> 
  summarize(
    flights = n(),
    avg_delay = mean(arr_delay, na.rm = TRUE),
    .groups = "keep"
  ) |> 
  arrange(desc(avg_delay))
filter(airlines, carrier == "F9")
# Frontier Airlines has the worst average arrival delays.

# If the factor contributing to delays is a bad airport,
# all routes to that airport will have high delays regardless of carrier.
# If the factor contributing to delays is a bad carrier,
# all routes with that carrier will have high delays regardless of destination.

routes <- flights |> 
  select(arr_delay, carrier, dest)
routes

route_delays <- flights |> 
  group_by(origin, carrier, dest) |> 
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n(),
    .groups = "keep"
  ) |> 
  arrange(desc(avg_delay))
route_delays

# To separate the effect of bad carriers vs bad airports, 
# compare the average delay times of routes when grouped by carrier 
# vs. routes when grouped by destination airport.

# get average delay by carrier, independent of route
routes |> 
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    .by = carrier
  ) |> 
  arrange(desc(avg_delay))

# get average delay by dest, independent of carrier
routes |> 
  summarize(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    .by = dest
  ) |> 
  arrange(desc(avg_delay))
# A larger average delay is seen when grouping by destination airports,
# so it is more likely that delays are due to destinations rather than carriers.


# 2. Find the flights that are most delayed upon departure from each destination.
flights |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .by = dest
  ) |> 
  arrange(desc(avg_delay))
# highest departure delays are from airport with code CAE (Columbia Metropolitian)


# 3. How do delays vary over the course of the day? Illustrate your answer with a plot.
# group flights by hour and plot dep_delay
flight_delays <- flights |> 
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .by = hour
  )
flight_delays |> 
  ggplot(aes(x = hour)) +
  geom_point(aes(y = avg_dep_delay)) + 
  geom_smooth(aes(y = avg_dep_delay)) + 
  labs(x = "Hour", y = "Departure delay (min)")
# delays are at their lowest in the morning and increase towards the evening


# 4. What happens if you supply a negative n to slice_min() and friends?
flights |> 
  group_by(dest) |> 
  slice_min(arr_delay, n = -2, with_ties = FALSE)
# full dataframe: 336,776 rows
# n = 2: 208 rows
# n = 1: 105 rows
# n = -1: 336,671 rows (336,776 - 105)
# n = -2: 336,568 rows (336,776 - 208)
# Using a negative value for n removes rows from the total group size.


# 5. Explain what count() does in terms of the dplyr verbs you just used.
# What does the sort() argument to count() do?

# count(x) is the same as grouping by x, then summarizing the number of rows in each group under the column n
flights |> 
  count(dest)

flights |> 
  group_by(dest) |> 
  summarize(n = n())
# Specifying sort = TRUE is the same as applying arrange(desc(x)) to the summarized dataframe.
flights |> 
  count(dest, sort = TRUE)

flights |> 
  group_by(dest) |> 
  summarize(n = n()) |> 
  arrange(desc(n))


# 6. Suppose we have the following tiny data frame:
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)
# Write down what you think the output for the following lines will look like,
# and describe what the pipelines do.

df |> group_by(y)
# creates two groups for "a" and "b"
df |> 
  group_by(y) |> 
  summarize(n = n())

df |> arrange(y)
# arrange() sorts df by listing rows with y = "a", then y = "b"

df |> 
  group_by(y) |> 
  summarize(mean_x = mean(x))
# returns mean value of x for each group of y
# mean(x) for rows where y = "a" is (1 + 3 + 4) / 3 = 2.667
# mean(x) for rows where y = "b" is (2 + 5) / 2 = 3.5

df |> 
  group_by(y, z) |> 
  summarize(mean_x = mean(x))
# three groups: (y = "a", z = "K"), (y = "a", z = "L"), (y = "b", z = "K") 
# mean(x) for group 1: 1 / 1 = 1
# mean(x) for group 2: (3 + 4) / 2 = 3.5
# mean(x) for group 3: (2 + 5) / 2 = 3.5
# the message indicates that subsequent operations will act on the grouping structure according to y only
# as the default behavior for summarize() is to drop the last group after summarization

df |> 
  group_by(y, z) |> 
  summarize(mean_x = mean(x), .groups = "drop")
# same result as previous command, but subsequent operations will act on entire dataframe
# as the grouping structure will be dropped after summarization

df |> 
  group_by(y, z) |> 
  summarize(mean_x = mean(x))
# as in earlier command, produces three groups of (y, z) with means 1, 3.5, and 3.5 

df |>
  group_by(y, z) |> 
  mutate(mean_x = mean(x))
# returns original dataframe with x, y, z columns and additional mean_x column
# mean_x holds the calculation of mean(x) for the corresponding group that the row belongs to
# mutate(x) operated on the groupings specified in group_by()
