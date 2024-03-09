library("nycflights13")
library("tidyverse")

# 336,776 x 19 tibble
flights

# open scrollable view
View(flights)

# show all columns
print(flights, width=Inf)

# transposed view of print() showing each column on different row
glimpse(flights)

# first argument of dplyr verb is dataframe
# subsequent arguments describe columns
# output is another dataframe

# x |> f(y) is equivalent to f(x, y)
# x |> f(y) |> g(z) is equivalent to g(f(x, y), z)
flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# filter() allows keeping rows based on values of columns
# first argument is dataframe, subsequent arguments are conditions
# conditions support >, <, ==, !=, &, |
# view flights that departed over two hours after scheduled departure time
flights |> 
  filter(dep_delay > 120)

# %in% is used as a shortcut for combining == and |
# view flights that departed in January or February
flights |> 
  filter(month %in% c(1, 2))

# output from filter() does not modify original dataframe
# result needs to be assigned to another variable
jan1 <- flights |>
  filter(month == 1 & day == 1)

# arrange() changes row order based on value of columns
# when multiple columns are provided, additional columns are used to break ties when ordering
flights |> 
  arrange(year, month, day, dep_time)

# desc() reorders one column of dataframe in descending order
flights |>
  arrange(desc(dep_delay))

flights |> 
  arrange(desc(year), desc(month), desc(day), desc(dep_time))

# distinct finds first occurrence of each unique row in dataset, removing duplicates if any exist
flights |>
  distinct()

# list rows with unique pairs of origin and destination airports
flights |>
  distinct(origin, dest)
# .keep_all = TRUE allows keeping other columns when filtering using distinct()
flights |>
  distinct(origin, dest, .keep_all = TRUE)

# use count() to find number of occurrences
# with sort = TRUE argument to arrange in descending order
flights |>
  count(origin, dest, sort = TRUE)

# --------------------------------------------------------------------------------

# 1. In a single pipeline for each condition, find all flights that meet the condition
# had an arrival delay of two or more hours
flights |>
  filter(arr_delay >= 120)
# flew to Houston (IAH or HOU)
flights |>
  filter(dest %in% c("IAH", "HOU"))
# were operated by United, American, or Delta
flights |>
  filter(carrier %in% c("UA", "AA", "DL"))
# departed in summer (July, August, September)
flights |>
  filter(month %in% c(7, 8, 9))
# arrived more than two hours late but didn't leave late
flights |>
  filter(arr_delay > 120 & dep_delay <= 0)
# were delayed by at least an hour but made up over 30 minutes in flight
flights |>
  filter(dep_delay >= 60 & arr_delay < dep_delay - 30)


# 2. Sort flights to find the flights with longest departure delays.
arrange(flights, desc(dep_delay))
# Find the flights that left earliest in the morning.
arrange(flights, dep_time)


# 3. Sort flights to find the fastest flights.
arrange(flights, desc(distance / air_time))


# 4. Was there a flight on every day of 2013?
distinct(flights, month, day)
# 365 unique month-day pairs, so there was a flight on every day


# 5. Which flights traveled the farthest distance? Which flights traveled the least distance?
arrange(flights, desc(distance))
# JFK-HNL flights traveled the farthest distance
arrange(flights, distance)
# EWR-PHL flights traveled the least distance (one EWR-PHL flight with many missing values)


# 6. Does it matter what order you used filter() and arrange() if you're using both? Why/why not?
# Filtering the dataset reduces its size, while arranging it keeps it the same size.
# It is better to filter the dataset first so the arrangement operation 
# does not have to operate on as many rows or columns compared to arranging the dataset first.
