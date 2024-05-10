{
  library("tidyverse")
  library("nycflights13")
}

# use accessor functions to extract specific date parts from datetime object
# year(), month(), mday(), yday(), wday(), hour(), minute(), second()
# mday() for day of month, yday() for day of year, wday() for day of week

datetime <- ymd_hms("2026-07-08 12:34:56")
year(datetime)
month(datetime)
yday(datetime)
mday(datetime)
wday(datetime)

# set label = TRUE for month() and wday() to get abbreviated name
# additionally, set abbr = FALSE to get full name
month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

# viewing distribution of flights during the week
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights |> 
  filter(!is.na(dep_time), !is.na(arr_time)) |> 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) |> 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt |> 
  mutate(wday = wday(dep_time, label = TRUE)) |> 
  ggplot(aes(x = wday)) + 
  geom_bar()

# viewing average departure delay by minute within the hour
# that is, grouping flights by the minute of their departure time
# and plotting the average dep_delay of each of these groups
flights_dt |> 
  mutate(minute = minute(dep_time)) |> 
  group_by(minute) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = minute, y = avg_delay)) + 
  geom_line()

# flights that leave around XX:20-XX:30 and XX:50-XX:59
# have much lower departure delays on average

# scheduled departure times do not have the same pattern
flights_dt |> 
  mutate(minute = minute(sched_dep_time)) |> 
  group_by(minute) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = minute, y = avg_delay)) + 
  geom_line()

# strong bias towards flights leaving at "nice" departure times
flights_dt |> 
  mutate(minute = minute(sched_dep_time)) |> 
  group_by(minute) |> 
  summarize(n = n()) |> 
  ggplot(aes(x = minute, y = n)) + 
  geom_line()

# instead of plotting individual components, date can be rounded to
# a nearby unit of time using floor_date(), round_date(), ceiling_date()
# pass vector of dates to adjust and name of unit to round down/near/up

# plot number of flights per week
flights_dt |> 
  count(week = floor_date(dep_time, "week")) |> 
  ggplot(aes(x = week, y = n)) + 
  geom_line() + 
  geom_point()

# using rounding to show distribution of flights over the course of a day
# by computing difference of dep_time and earliest instant of that day
flights_dt |> 
  mutate(dep_hour = dep_time - floor_date(dep_time, "day")) |> 
  ggplot(aes(x = dep_hour)) + 
  geom_freqpoly(binwidth = 60 * 30)

# unit of x-axis for the graph is seconds, ranging from 0 to 86400

flights_dt |> 
  mutate(dep_hour = hms::as_hms(dep_time - floor_date(dep_time, "day"))) |> 
  ggplot(aes(x = dep_hour)) + 
  geom_freqpoly(binwidth = 60 * 30)

(datetime <- ymd_hms("2026-07-08 12:34:56"))

# components of datetime object can be modified individually
year(datetime) <- 2030
datetime

month(datetime) <- 01
datetime

hour(datetime) <- hour(datetime) + 1
datetime

# use update() to modify multiple components at once
update(datetime, year = 2030, month = 2, mday = 2, hour = 2)

# new values for components will roll over to the next one if too big
update(ymd("2023-02-01"), mday = 30)

update(ymd("2023-02-01"), hour = 400)

# -------------------------------------------------------------------------

# 1. How does the distribution of flight times within a day
# change over the course of the year?

# plotting counts of flights per hour for each month
flights_dt |> 
  mutate(
    month = as.factor(month(dep_time)),
    dep_hour = hour(dep_time)
  ) |> 
  group_by(month, dep_hour) |> 
  mutate(n = n()) |> 
  ggplot(aes(x = dep_hour, y = n)) + 
  geom_line(aes(color = month))


# 2. Compare dep_time, sched_dep_time, and dep_delay. Are they consistent?

# calculate difference between dep_time and sched_dep_time and
# compare to dep_delay for each row

# 1205 rows with inconsistent values between columns,
# likely due to flights being delayed until the next day so the date for
# the formatted scheduled departure time is incorrect
flights_dt |> 
  mutate(calc_delay = as.double(dep_time - sched_dep_time) / 60) |> 
  select(dep_delay, calc_delay, dep_time, sched_dep_time) |> 
  filter(dep_delay != calc_delay)


# 3. Compare air_time with the duration between the departure and arrival.
# Explain your findings. (Hint: consider the location of the airport.)

# The calculated and actual air times do not match as the arr_time and
# dep_time are usually in different time zones due to the locations of the 
# origin and destination airports.
flights_dt |> 
  mutate(calc_air_time = as.double(arr_time - dep_time)) |> 
  select(air_time, calc_air_time, arr_time, dep_time) |> 
  filter(air_time != calc_air_time)


# 4. How does the average delay time change over the course of a day?

# 5. On what day of the week should you leave if you want to minimize the 
# chance of a delay?

# 6. What makes the distribution of diamonds$carat
# and flights$sched_dep_time similar?

# Diamond carats tend to be close to a round tenth, plus one or two hundredths.
diamonds |>
  count(carat, sort = TRUE) |> 
  print(n = 20)


# Flight departure times are most often on the hour or half-hour.
flights |>
  count(sched_dep_time, sort = TRUE)


# The most common values for diamond carats and scheduled departure times
# for flights are concentrated around "nice" values.

ggplot(diamonds, aes(x = carat)) + 
  geom_freqpoly(binwidth = 0.001)

ggplot(flights, aes(x = sched_dep_time)) + 
  geom_freqpoly(binwidth = 0.1)


# 7. Confirm our hypothesis that the early departures of flights in minutes
# 20-30 and 50-60 are caused by scheduled flights that leave early. (Hint: 
# create a binary variable that tells you whether or not a flight was delayed.)

