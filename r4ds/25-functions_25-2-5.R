{
  library("tidyverse")
  library("nycflights13")
}

# functions give names to blocks of code to make them easier to understand
# only need to update code within function when requirements change
# eliminates risk of incidental mistakes when copying and pasting
# increases productivity by allowing work to be reused

# rule of thumb - write a function when code is repeated more than twice

# vector function takes one or more vectors as input, outputs one vector
# dataframe function takes a dataframe as input, outputs one dataframe
# plot function takes a dataframe as input, outputs one plot

# analyze existing code to figure out which parts are constant and which vary
# a function needs a name, one or more arguments, and a body
# template: name <- function(arguments){body}

rescale01 <- function(x){
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))

df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5)
)

# duplication can be reduced even further with across()
# df |> mutate(across(a:d, rescale01))
df |> mutate(
  a = rescale01(a),
  b = rescale01(b),
  c = rescale01(c),
  d = rescale01(d)
)
df

# improve rescale01 by only computing minimum and maximum once with range()
# and ignoring infinite values
rescale01 <- function(x){
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(1:10, Inf))

# mutate functions return output of same length as input
# work well inside mutate() and filter()

# compute Z-score of elements in vector, rescaling to mean of 0 and sd of 1
z_score <- function(x){
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

# clamp values in vector within a range
clamp <- function(x, min, max){
  case_when(
    x < min ~ min,
    x > max ~ max,
    .default = x
  )
}

clamp(c(1:10), 3, 7)

# functions can also work with and manipulate string variables

# make first character of string uppercase
first_upper <- function(x){
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}
first_upper('hello')

# convert dollar amounts and percents into numbers
clean_number <- function(x){
  is_pct <- str_detect(x, "%")
  num <- x |> 
    str_remove_all("%") |> 
    str_remove_all(",") |> 
    str_remove_all(fixed("$")) |> 
    as.numeric()
  if_else(is_pct, num / 100, num)
}
clean_number("$12,300")
clean_number("45%")

# use functions to handle certain steps in data analysis
# treating 997, 998, 999 as missing values in data set
fix_na <- function(x){
  if_else(x %in% c(997, 998, 999), NA, x)
}

# functions can take multiple vector inputs
# summary functions return a single value for use in summarize()

# flatten vector of strings into string of comma-separated elements
commas <- function(x){
  str_flatten(x, collapse = ", ", last = ", and ")
}
commas(c("cat", "dog", "pigeon"))

# wrap computation of coefficient of variation (standard deviation / mean)
cv <- function(x, na.rm = FALSE){
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}
cv(runif(100, min = 0, max = 50))
cv(runif(100, min = 0, max = 500))

# give common pattern a memorable name to make it easier to remember
n_missing <- function(x){
  sum(is.na(x))
}

# compute mean absolute percentage error
mape <- function(actual, predicted){
  sum((abs(actual - predicted)) / actual) / length(actual)
}

# shortcuts in RStudio
# place cursor on name of user-defined function and press F2 to find definition
# press Ctrl + . to search for function name and jump to definition

# -------------------------------------------------------------------------

# 1. Practice turning code snippets into functions. Think about what each
# function does. What would you call it? How many arguments does it need?

# compute proportion of missing values in vector
missing_prop <- function(x){
  mean(is.na(x))
}
missing_prop(c(1, 2, 3, 4, 5))
missing_prop(c(1, 2, NA, NA, 5))

# normalize vector to sum to 1
normalize_sum <- function(x){
  x / sum(x, na.rm = TRUE)
}
normalize_sum(c(1, 2, 3, 4, 5, 10))

# convert each element into percentage of total rounded to nearest tenth
percentage <- function(x){
  round(x / sum(x, na.rm = TRUE) * 100, 1)
}
percentage(c(1, 2, 3, 4, 5))


# 2. In the second variant of rescale01(), infinite values are left unchanged.
# Rewrite the function to map -Inf to 0 and Inf to 1.
rescale01_mapinf <- function(x){
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  x <- (x - rng[1]) / (rng[2] - rng[1])
  x <- if_else(x == -Inf, 0, x)
  if_else(x == Inf, 1, x)
}
rescale01_mapinf(c(-Inf, 1, 2, 3, 4, 5, Inf))


# 3. Given a vector of birthdates, compute the age in years.

library("lubridate")
age <- function(x){
  (x %--% today()) / years(1)
}
age(c(ymd("1941-09-09"), ymd("1942-01-30"), ymd("1943-02-04")))


# 4. Write your own functions to compute the variance and skewness
# of a numeric vector.
variance <- function(x, na.rm = FALSE){
  x_bar <- mean(x, na.rm = na.rm)
  n <- length(x)
  sum((x - x_bar)^2 / (n - 1))
}
var(1:5, na.rm = TRUE)
variance(1:5)

skew <- function(x, na.rm = FALSE){
  x_bar <- mean(x, na.rm = na.rm)
  x_tilde <- median(x, na.rm = na.rm)
  s <- sd(x, na.rm = na.rm)
  3 * (x_bar - x_tilde) / s
}
skew(1:5)


# 5. Write both_na(), a summary function that takes two vectors of the same
# length and returns the number of positions that have an NA in both vectors.

both_na <- function(x, y){
  sum(is.na(x) & is.na(y))
}
both_na(c(NA, 1, NA, 1), c(NA, NA, 1, 1))
both_na(c(NA, 2, 3, NA, 5), c(NA, 7, NA, NA, 10))


# 6. Read the documentation to figure out what the following functions do.
# Why are they so useful even though they are so short?

# file.info() by itself returns extra info, including size, permissions,
# and modification, creation, and access times

# returns logical specifying whether filepath is a directory
is.directory <- function(x){
  file.info(x)$isdir
}

# file.access() by itself returns info about file including existence,
# as well as read, write, and execute permissions

# returns logical specifying whether file read permissions are granted
is_readable <- function(x){
  file.access(x, 4) == 0
}
