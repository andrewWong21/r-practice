{
  library("tidyverse")
  library("nycflights13")
}

# evaluation rules for missing values in Boolean algebra require some thought
df <- tibble(x = c(TRUE, FALSE, NA))
df |> 
  mutate(
    and = x & NA,
    or = x | NA
  )
# missing value in logical expression could either be TRUE or FALSE
# TRUE | NA simplifies to TRUE
# FALSE & NA simplifies to FALSE
# FALSE | NA and TRUE & NA evaluates to NA, as result is dependent on NA
# NA & NA and NA | NA evaluate to NA as they are both unknown

# x %in% y returns a vector as long as x with logical values representing
# whether the element at the corresponding index in x exists anywhere in y,
# allows searching within vectors and shortening chains of == | == | == ...
1:12 %in% c(1, 5, 11)
letters[1:10] %in% c("a", "e", "i", "o", "u")

flights |> 
  filter(month %in% c(11, 12)) # equivalent to month == 11 | month == 12

# %in% has different evaluation rules with NA since NA %in% NA is TRUE
c(1, 2, NA) == NA   # NA NA NA
c(1, 2, NA) %in% NA # FALSE FALSE TRUE

# can be used as a shortcut
# find all flights that either depart at exactly 8:00 am or are missing dep_time
flights |> 
  filter(dep_time %in% c(NA, 0800))

# -------------------------------------------------------------------------

# 1. Find all flights where arr_delay is missing but dep_delay is not.
flights |> 
  filter(is.na(arr_delay) & !is.na(dep_delay))
# Find all flights where neither arr_time nor sched_arr_time is missing, but 
# arr_delay is missing.
flights |> 
  filter(!is.na(arr_time) & !is.na(sched_arr_time) & is.na(arr_delay))


# 2. How many flights have a missing dep_time? What other variables are 
# missing in these rows? What might these rows represent?

# 8,255 flights have a missing dep_time
flights |>
  filter(is.na(dep_time))

# all of these flights have missing dep_delay, arr_time, arr_delay, air_time
# as well, so these rows must represent cancelled flights 

# some, but not all, rows with missing dep_time also have missing tailnum
# which suggests that the flight was cancelled before a plane was chosen
flights |> 
  filter(is.na(dep_time)) |> 
  filter(is.na(tailnum))


# 3. Assuming that a missing dep_time means that a flight is cancelled, look at
# the number of cancelled flights per day. Is there a pattern? Is there a
# connection between the proportion of cancelled flights and the average delay
# of non-cancelled flights?

# flights appear to be cancelled most often in early-mid February,
# early March, and the first half of December
flights |> 
  mutate(
    date = as.Date(str_c(year, "-", month, "-", day)),
    cancelled = is.na(dep_time)
  ) |> 
  count(date, status = cancelled == TRUE) |> 
  filter(status == TRUE) |> 
  arrange(desc(n), date) |> 
  ggplot(aes(x = date, y = n)) + 
  geom_line() +
  scale_x_date(
    date_labels = "%b", 
    date_breaks = "1 month"
  )

# no strong correlation between daily average delay of non-cancelled flights
# and proportion of cancelled flights for the day
flights |> 
  mutate(
    date = as.Date(str_c(year, "-", month, "-", day))
  ) |> 
  summarize(
    cancelled_prop = sum(is.na(dep_time)) / n(),
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .by = date
  ) |> 
  ggplot(aes(x = date)) + 
  geom_line(
    aes(y = avg_delay), 
    color = "red"
  ) + 
  geom_line(
    aes(y = cancelled_prop * 100), 
    color = "blue"
  ) +
  scale_x_date(
    date_labels = "%b", 
    date_breaks = "1 month"
  )

# using geom_bin2d() and log10 transform shows some correlation
flights |> 
  mutate(
    date = as.Date(str_c(year, "-", month, "-", day))
  ) |> 
  summarize(
    n = n(),
    cancelled_prop = sum(is.na(dep_time)) / n(),
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .by = date
  ) |> 
  ggplot(aes(x = cancelled_prop, y = avg_delay)) + 
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

# plotting the variables grouped by month instead of by day
flights |> 
  summarize(
    n = n(),
    cancelled_prop = sum(is.na(dep_time)) / n(),
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .by = month
  ) |> 
  ggplot(aes(x = month)) + 
  geom_line(aes(y = avg_delay), color = "red") + 
  geom_line(aes(y = cancelled_prop * 100), color = "blue") +  
  scale_x_continuous(breaks = 1:12)
