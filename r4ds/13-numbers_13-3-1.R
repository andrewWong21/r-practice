{
  library(tidyverse)
  library(nycflights13)
}

# numbers are usually recorded as integers or doubles
# numbers may sometimes appear as strings due to column pivoting
# or problems with data importing process

# readr provides two parsing functions for converting strings to numbers:

# parse_double() for converting numbers written as strings
x <- c("1.2", "5.6", "1e3")
parse_double(x)

# parse_number() for ignoring all non-numeric text in string
y <- c("$1,234", "USD 5,313", "59%")
parse_number(y)

# -------------------------------------------------------------------------

# 1. How can you use count() to count the number rows with
# a missing value for a given variable?