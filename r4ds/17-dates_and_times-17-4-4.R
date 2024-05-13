{
  library("tidyverse")
  library("nycflights13")
}

# three classes of timespans:
# durations - exact number of seconds
# periods - human units of time
# intervals - starting and ending points

# pick simplest data structure to suit needs
# duration for physical times
# periods for arithmetic with human times
# intervals for finding time span lengths

# subtracting two dates results in a difftime object
# that records time spans of seconds, minutes, hours, days, or weeks
h_age <- today() - ymd("1970-10-14")
h_age

# lubridate uses durations, an alternative for difftime objects
# that always expresses timediffs in seconds to avoid ambiguity
as.duration(h_age)

# durations can be constructed with different time components
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

# years are treated as 365.25 days
# due to high variation in number of days in months,
# no function for converting a month to a duration is provided

# durations can be added and multiplied
2 * dyears(1)
dyears(1) + dweeks(12) + dhours(15)

# add/subtract durations to and from days
tomorrow <- today() + ddays(1)
tomorrow
last_year <- today() - dyears(1)
last_year

# adding/subtracting durations may cause unexpected results
# working with different timezones
one_am <- ymd_hms("2026-03-08 01:00:00", tz = "America/New_York")
one_am
one_am + ddays(1)

# time zone changes in this calculation due to DST

# periods use "human" times for spans instead of fixed lengths in seconds

# arithmetic with time periods is more intuitive
one_am
one_am + days(1)

# no d prefix: seconds(), minutes(), hours(), days(), months(), years()
hours(c(12, 24))
days(7)
months(1:6)

# add and multiply periods
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)

# adding periods to dates is more likely to give expected results

# adding one year to a leap year using durations vs. periods
ymd("2024-01-01")
ymd("2024-01-01") + dyears(1) # add 365.25 days (365 days, 6 hours)
ymd("2024-01-01") + years(1)  # same date one year later

# working with daylight savings time using durations vs. periods
one_am
one_am + ddays(1) # adding 24 hours
one_am + days(1)  # 1 AM the next day

# handling times for overnight flights (arriving the next day)
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

# overnight flights currently appear to arrive before they depart
flights_dt |> 
  filter(arr_time < dep_time)

# add days(1) to arrival times of each overnight flight
flights_dt <- flights_dt |> 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight),
    sched_arr_time = sched_arr_time + days(overnight)
  )

flights_dt |> 
  filter(arr_time < dep_time)

# dyears() is defined as the number of seconds per average year (365.25 days)
dyears(1) / ddays(1)

# lubridate returns an estimate since 1 year / 1 day could return 365 or 366
# depending on whether the year is a leap year
years(1) / days(1)

# intervals are defining by a pair of start and end times
# or framed as a duration with a starting point

# use %--% to define an interval, end point is not included
y2023 <- ymd("2023-01-01") %--% ymd("2024-01-01")
y2024 <- ymd("2024-01-01") %--% ymd("2025-01-01")

y2023
y2024

y2023 / days(1) # 2023 has 365 days
y2024 / days(1) # 2024 has 366 days

# everyday names of time zones are ambiguous (see locations that use EST)

# R uses international standard IANA time zone names
# in the form {area}/{location} as {continent}/{city} or {ocean}/{city}

# country names and time zone rules in cities have changed over the years
# using city name captures history of used time zones

# print detected timezone in R with Sys.timezone(), returns NA if not detected
Sys.timezone()

# view complete list of all time zone names with OlsonNames()
length(OlsonNames())
head(OlsonNames())

# time zone in R only controls how date is printed

# the following objects represent the same instant in time
x1 <- ymd_hms("2024-06-01 12:00:00", tz = "America/New_York")
x2 <- ymd_hms("2024-06-01 18:00:00", tz = "Europe/Copenhagen")
x3 <- ymd_hms("2024-06-02 04:00:00", tz = "Pacific/Auckland")

x1
x2
x3

# these three objects have a time difference of 0 seconds
x1 - x2
x2 - x3
x1 - x3

# lubridate always uses UTC unless specified otherwise
# Coordinated Universal Time is roughly equivalent to GMT, does not have DST

# operations that combine date-times often drop the time zone
# and display them in the time zone of the first element
x4 <- c(x1, x2, x3)
x4

# change time zone with with_tz() or force_tz() depending on circumstances:

# change display for a more natural display when instant in time is correct
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a
x4a - x4

# change underlying instant in time if instant is labeled with incorrect
# time zone, use given tz for timezone instead
x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")
x4b
x4b - x4

# -------------------------------------------------------------------------

# 1. Explain days(!overnight) and days(overnight) to someone who has just
# started learning R. What key fact do you need to know?

# overnight is a boolean, which takes the value TRUE or FALSE.
# TRUE is treated numerically as 1, while FALSE is treated numerically as 0.

# If a flight is an overnight flight, then overnight = TRUE
# and the days to be added to the arrival times is days(overnight)
# or days(TRUE), which is evaluated as days(1), or one day as a period.

# If overnight is FALSE, days(!overnight) becomes days(TRUE) or days(1).


# 2. Create a vector of dates giving the first day of every month in 2015.
# Create a vector of dates giving the first day of every month in this year.

ymd("2015-01-01") + months(0:11)

ymd(str_c(toString(year(today())), "-01-01")) + months(0:11)


# 3. Write a function that given your birthday as a date,
# returns how old you are in years.

get_age <- function(birthdate){
  as.integer((birthdate %--% today()) / years(1))
}

get_age(ymd("1941-09-09"))
get_age(ymd("1956-01-31"))


# 4. Why can't (today() %--% (today() + years(1))) / months(1) work?

# months(1) is a valid time duration
months(1)

# calculating an interval of one year, starting today
# and finding the number of months contained
(today() %--% (today() + years(1))) / months(1)

# expression returns the expected result of 12, seems to work properly
