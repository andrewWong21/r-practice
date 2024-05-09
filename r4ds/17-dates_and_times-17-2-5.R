{
  library("tidyverse")
  library("nycflights13")
}

# lubridate package is part of core tidyverse

# date - specified day, printed as <date> in tibbles
# time - time within a day, printed as <time> in tibbles
# not available in base R, use hms package if needed
# date-time combines both, printed as <dttm> in tibbles

# get current date with today()
today()

# get current time with now()
now()

# dates and times are usually created while reading a file with readr,
# from a string, individual date-time components, or from a date-time object

# readr automatically recognizes dates and date-times in ISO8601 format
# international standard: yyyy-mm-dd hh:mm
# time may be separated from date with T or a space
csv <- "
date,datetime
2022-01-02, 2022-01-02 05:12
"
read_csv(csv)

# other formats will require col_types and col_date() or col_datetime()
# with date-time format using date components, % followed by one character
# %Y is 4-digit year, %y is 2-digit year
# %m is numbered month, %b is abbreviated month name, %B is full month name
# %d shows one digit for days before 10, %e always shows 2 digits for days
# %H is 24-hour system, %I is 12-hour system, %p is for AM/PM,
# %M for minutes, %S for seconds, %OS for seconds with decimals,
# %Z for timezone, %z for UTC offset
# %. to skip one non-digit, %* to skip any non-digits

csv2 <- "
date
01/02/15
"

# month/day/year: January 2, 2015
read_csv(csv2, col_types = cols(date = col_date("%m/%d/%y")))

# day/month/year: February 1, 2015
read_csv(csv2, col_types = cols(date = col_date("%d/%m/%y")))

# year/month/day: February 15, 2001
read_csv(csv2, col_types = cols(date = col_date("%y/%m/%d")))

# locale is required when working with non-English dates and using %b or %B
# built-in languages are provided in date_names_langs()
date_names_langs()

# can also create custom locales with date_names()

# lubridate has helpers for determining format from a given string
# when order of components is specified
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

# create date-time by appending _ and one or more of h, m, s
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# force date-time creation from date by supplying timezone
ymd("2017-01-31", tz = "UTC")

# date-time can be created from individual components
# spread across several columns in dataset
flights |> 
  select(year, month, day, hour, minute)

# use make_date() or make_datetime() with column names to build objects
flights |> 
  select(year, month, day, hour, minute) |> 
  mutate(departure = make_datetime(year, month, day, hour, minute))

# time columns of flights (dep_time, sched_dep_time, arr_time, sched_arr_time)
# are represented as 100 * hour + minute, so create function to convert them
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

# view origin and destination of flights with formatted datetimes
flights_dt

# using datetimes in a numeric context treats 1 as one second
# plot distribution of departure times per day (binwidth of 86400 seconds)
flights_dt |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

# plot distribution of departure times within a single day (Jan 01, 2013)
flights_dt |> 
  filter(dep_time < ymd(20130102)) |> 
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600 seconds = 10 minutes

# switch between date-times and dates with as_date() and as_datetime()
as_datetime(today())
as_date(now())

# Unix epoch is 1970-01-01, dates may be expressed as offsets in days or seconds
# use as_datetime() for offsets in seconds
as_datetime(60 * 60 * 10) # offset of 3600 seconds -> 600 minutes -> 10 hours
# use as_date() for offsets in days
as_date(365 * 10 + 2) # offset of 3652 days

# -------------------------------------------------------------------------

# 1. what happens if you parse a string that contains invalid dates?

# the resulting value for the given string becomes NA
# if multiple strings are provided, a warning is given noting how many of
# the supplied strings did not contain a valid date
ymd(c("2010-10-10", "bananas"))


# 2. What does the tzone argument to today() do? Why is it important?

# The tzone argument specifies which timezone to return the current date for,
# and defaults to the current system's timezone. This is important because 
# timezones may be on different sides of the date boundary.
today()
today(tzone = "UTC")


# 3. For each of the following date-times, show how to parse them
# using a readr column specification and a lubridate function.

d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")
mdy(d1)

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%e")
ymd(d2)

d3 <- "06-Jun-2017"
parse_date(d3, "%e-%b-%Y")
dmy(d3)

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")
mdy(d4)

d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")
mdy(d5)

t1 <- "1705"
parse_time(t1, "%H%M")

t2 <- "11:15:10.12 PM"
parse_time(t2, "%h:%M:%OS %p")
