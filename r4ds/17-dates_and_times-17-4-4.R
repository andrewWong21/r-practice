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
last_year <- today() - dyears(1)

# adding/subtracting durations may cause unexpected results
# working with different timezones
one_am <- ymd_hms("2026-03-08 01:00:00", tz = "America/New_York")
one_am
one_am + ddays(1)

# time zone changes in this calculation due to DST

# -------------------------------------------------------------------------
