# objects with class attributes become S3 objects
# behave differently from regular vectors when passed to generic function

# S3 object has base type with additional info stored in attributes

# four important types of S3 vectors:
# factor vectors containing categorical data with a fixed set of levels
# date vectors containing doubles of class "Date"
# POSIXct vectors containing date-times
# difftime vectors containing time durations

# factors can only contain predefined values
# factors have class attribute "factor"
# and levels attribute defining allowed values in factor

x <- factor(c("a", "b", "b", "a"))
x

typeof(x)
attributes(x)

# tabulating a factor provides counts of all categories, including unobserved
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)

# ordered factors have a meaningful order of categories
# useful for modeling and visualization functions
grade <- ordered(c("b", "b", "a", "c"), levels = c("c", "b", "a"))
grade

# some base R functions automatically convert character vectors to factors
# function cannot know proper order or all possible levels just from data
# use stringsAsFactors = FALSE to suppress this behavior when applicable

# factors look like strings, but are built on top of integers
# string methods may coerce to strings, use integer values, or throw an error
# recommended to explicitly convert to strings if string behavior is needed

# date vectors are double vectors with class "Date"
today <- Sys.Date()
today

typeof(today)
attributes(today)

# value of double stored is number of days since January 1, 1970
date <- as.Date("1970-02-01")
date
unclass(date)

# date-times may be stored as POSIXct or POSIXlt format in base R
# POSIX - Portable Operating System Interface
# ct - calendar time, lt - local time
# POSIXct is more appropriate for use in data frames

# POSIXct vectors are double vectors
# value is number of seconds since Unix epoch 1970-01-01
now_ct <- as.POSIXct("2024-08-01 22:00", tz = "UTC")
now_ct

typeof(now_ct)
attributes(now_ct)
unclass(now_ct)

# changing tzone only affects format of date-time, does not change time instant
# time is not printed if midnight
structure(now_ct, tzone = "Asia/Tokyo")
structure(now_ct, tzone = "America/New_York")
structure(now_ct, tzone = "Australia/Lord_Howe")
structure(now_ct, tzone = "Europe/Paris")

# -------------------------------------------------------------------------

