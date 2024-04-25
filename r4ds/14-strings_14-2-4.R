{
  library("tidyverse")
  library("babynames")
}

# stringr package is part of core tidyverse
# all stringr functions start with str_ for easy autocomplete

# strings may use single or double quotes
str1 <- "This is a string"
str2 <- 'Use single quotes to enclose "quote" inside string'

# use backslash \ to escape single quotes, double quotes, backslashes
# printed representation shows escape characters
single_quote <- "\'"
double_quote <- "\""
backslash <- "\\"

# use str_view() to view raw content of string
x <- c(single_quote, double_quote, backslash)
x
str_view(x)

# escape characters can pile up when using many quotes or backslashes in string
tricky <- "double_quote <- \"\\\"\" # or '\"'
single_quote <- '\\'' # or \"'\""
tricky
str_view(tricky)

# eliminate escapes by using raw string
cleaner <- r"(double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'")"
cleaner
str_view(cleaner)

# raw string usually starts with "( and ends with )"
# if string contains )" then r"[]" or r"{}" can be used
# or insert dashes as needed to make closing pairs unique like r"--()--"

# special characters like \n (newline) and \t (tab) may appear
# \u and \U are Unicode escapes used to write non-English characters
y <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f605")
y
str_view(y)
# str_view uses curly braces and colors for special characters

# -------------------------------------------------------------------------

# 1. Create strings that contain the following values:

# He said "that's amazing!"
val1 <- r"(He said "that's amazing!")"
val1
str_view(val1)

# \a\b\c\d
val2 <- r"(\a\b\c\d)"
val2
str_view(val2)

# \\\\\\
val3 <- r"(\\\\\\)"
val3
str_view(val3)


# 2. Create the string in your R session and print it. What happens to the
# special "\u00a0"? How does str_view() display it? What is this character?
val4 <- "This\u00a0is\u00a0tricky"

# character \u00a0 is displayed as a space
val4

# appears as {\u00a0} in str_view()
str_view(val4)

# \u00a0 is a non-breaking space, used to prevent automatic line breaks
# occurring at its position when word wrapping is performed, as well as
# keeping consecutive whitespace characters from being converted into a 
# single space
