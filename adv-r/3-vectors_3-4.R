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

# durations are stored in difftimes, built on top of doubles
# represent amount of time between pairs of dates or date-times
# has units class to determine unit of time used

one_week_1 <- as.difftime(1, units = "weeks")
one_week_1
typeof(one_week_1)
attributes(one_week_1)
unclass(one_week_1)

one_week_2 <- as.difftime(7, units = "days")
one_week_2
typeof(one_week_2)
attributes(one_week_2)
unclass(one_week_2)

# -------------------------------------------------------------------------

# 1. What sort of object does table() return? What is its type?
# What attributes does it have? How does the dimensionality change
# as you tabulate more variables?

table(letters)
table(factor(letters))

x <- c("a", "b", "b", "a")
x_fact <- factor(x, levels = letters)
x_fact

table(x)
x_tab <- table(x_fact)

# table is an integer vector
typeof(x_tab)

# has attributes "dim" for length, "dimnames" for level names, and "class" table
attributes(x_tab)

y_tab = table(factor(c("a", "b", "d", "m", "b", "a"), levels = letters))
y_tab
attributes(y_tab)


# 2. What happens to a factor when you modify its levels?

f1 <- factor(letters)
f1
unclass(f1)

# the underlying integer values stay the same when the levels are modified
# z = 1, y = 2, x = 3, ..., a = 26, categories listed z-a
# underlying elements are in order from 1 to 26
levels(f1) <- rev(levels(f1))
f1
unclass(f1)
as.integer(f1)


# 3. What does this code do? How do f2 and f3 differ from f1?

# f2 converts letters to a factor, then reverses the elements
# f2 has reversed elements but maintains the original level order
# a = 1, b = 2, c = 3, ..., z = 26, categories listed a-z
# underlying elements are in reverse order from 26 to 1
f2 <- rev(factor(letters))
f2
unclass(f2)
as.integer(f2)

# f3 has reversed level order on creation, element order is unchanged
f3 <- factor(letters, levels = rev(letters))
f3
unclass(f3)
as.integer(f3)
