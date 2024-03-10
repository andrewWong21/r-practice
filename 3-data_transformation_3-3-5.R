library("tidyverse")
library("nycflights13")

# mutate() adds new columns derived from existing columns
# new columns are added to the right unless .before = 1 is specified
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

# .after can be used to insert new columns after a specified point
# .before and .after support numerical positions and variable names
# . indicates argument and not new column to create
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# .keep = "used" only keeps columns involved and created with mutate()
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )
# results of mutate() are not stored unless explicitly assigned to a variable

# select columns by name
flights |>
  select(year, month, day)

# select columns between given columns (inclusive)
flights |>
  select(year:day)

# select columns except between given columns (inclusive)
flights |>
  select(!year:day)

# select all columns that are characters
flights |>
  select(where(is.character))
# lists carrier, tailnum, origin, and dest columns

#select() helper functions
# starts_with("abc"), ends_with("xyz"), contains("ijk")
# num_range("x", 1:3) matches x1, x2, x3

# selected columns can be renamed
flights |>
  select(tail_num = tailnum)

# rename() can be used to change column names while still keeping existing columns
flights |>
  rename(tail_num = tailnum)

# relocate() changes column order, moves specified columns to front by default
flights |>
  relocate(time_hour, air_time)

# new location can also be specified with .before and .after
flights |>
  relocate(year:dep_time, .after = time_hour)

flights |>
  relocate(starts_with("arr"), .before = dep_time)

# --------------------------------------------------------------------------------

# 1. Compare dep_time, sched_dep_time, and dep_delay.
# How would you expect those three numbers to be related?

# departure times are formatted as HHMM
# departure delays may result in flights departing the next day
# convert departure times into number of minutes since midnight of scheduled departure day

# since non-cancelled flights have scheduled departure times at 3:00 AM at the earliest
# and flights depart at best 43 minutes ahead of schedule or at worst nearly 22 hours behind schedule,
# all flights depart either on the day of scheduled departure or the next day

flight_times <- mutate(
  flights, 
  sched_dep_time_mins = (sched_dep_time %/% 100 * 60) + sched_dep_time %% 100,
  dep_time_mins = (dep_time %/% 100 * 60) + dep_time %% 100 + 1440 * (dep_delay + sched_dep_time_mins > 1440),
  dep_delay,
  .keep = "none"
)
view(filter(flight_times, dep_delay != (dep_time_mins - sched_dep_time_mins)))
# 0 rows, thus dep_delay always corresponds to the time difference between sched_dep_time and dep_time


# 2. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# select by column name
select(flights, dep_time, dep_delay, arr_time, arr_delay)
# select from column range with condition
select(flights, dep_time:arr_delay & !contains("sched"))
# select by column index
select(flights, c(4,6,7,9))


# 3. What happens if you specify the name of the same variable multiple times in a select() call?
select(flights, year, year)
# The column is displayed only once even if the variable name is specified multiple times.


# 4. What does the any_of() function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, any_of(variables))
# any_of() can be used as a more convenient way to write and refer to a subset of a dataset's columns.


# 5. Does the result of running the following code surprise you?
# How do the select helpers deal with upper and lower case by default? How can you change that?
flights |> select(contains("TIME"))
# The line runs without issues, ignoring case.
# To modify this behavior and make select helpers case sensitive, specify ignore.case = FALSE.
flights |> select(contains("TIME", ignore.case = FALSE))

# 6. Rename air_time to air_time_min to indicate units of measurement
# and move it to the beginning of the data frame.
relocate(flights, air_time_min = air_time, .before = 1)

# 7. Why doesn't the following work, and what does the error mean?
flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
# Selecting the tailnum column removes all other columns from the dataframe,
# so the arr_delay column no longer exists in the dataframe after applying the select operation.
# The error indicates that the column passed as an argument was not found in the dataframe.
