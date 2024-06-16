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
first_upper <- function(x){
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}
first_upper('hello')
