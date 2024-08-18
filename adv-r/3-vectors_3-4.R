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
