# R lazily evaluates function arguments - only evaluates them when accessed

h01 <- function(x){
  10
}
# error is not executed because x is never used within h01
h01(stop("ERROR"))

# allows for inclusion of potentially expensive computations in arguments

# promise - data structure that allows for lazy evaluation
# three components - expression, environment, value

# expression is evaluated within function environment
y <- 10
h02 <- function(x){
  y <- 100
  x + 1
}
h02(y)

# when assignment is done inside a function call,
# variable is bound outside of function
h02(y <- 1000)
y

# value is computed and cached on first access when evaluated in environment
double <- function(x){
  message("Calculating...")
  x * 2
}
h03 <- function(x){
  c(x, x)
}
h03(double(20))

# lazy evaluation allows for default values to be defined in terms of 
# other arguments or variables defined later in function

# y is defined in terms of x
# z is defined in terms of a and b, defined in function body
h04 <- function(x = 1, y = x * 2, z = a + b){
  a <- 10
  b <- 100
  c(x, y, z)
}
h04()

# not recommended as it makes prediction of return values difficult

# default arguments are evaluated inside function, which is different from
# user-supplied arguments, so different results may be obtained depending on
# the type of argument, even if the value is the same
h05 <- function(x = ls()){
  a <- 1
  x
}
h05()
h05(ls())

# use missing() to determine whether argument is using
# a user-supplied value or pre-defined default value
h06 <- function(x = 10){
  list(missing(x), x)
}
str(h06())
str(h06(10))

# sample() has a required argument x
# uses missing() to provide a default value for size, x, if not user-specified
args(sample)
body(sample)

# x %||% y returns x if x is not NULL, otherwise returns y

# -------------------------------------------------------------------------

# 1. What important property of && makes x_ok() work?
x_ok <- function(x){
  !is.null(x) && length(x) == 1 && x > 0
}
x_ok(NULL)
x_ok(1)
x_ok(1:3)

# What is different with this code? Why is this behavior undesirable here?
x_ok <- function(x){
  !is.null(x) & length(x) == 1 & x > 0
}
x_ok(NULL)
x_ok(1)
x_ok(1:3)

# && short-circuits, returning result as soon as it is determined
# returns a logical vector of length 1
# & performs elementwise comparisons
# returns a logical vector of the same size as the input vector

# NULL > 0 returns logical(0)
# FALSE & FALSE & logical(0) returns logical(0)
# using &&, !is.null(NULL) evaluates to TRUE and length(NULL) == 1 is FALSE
# TRUE && FALSE evaluates to FALSE, && returns FALSE without checking NULL > 0

# 2. What does this function return? Why? What principle does it illustrate?
f2 <- function(x = z){
  z <- 100
  x
}
f2()

# returns 100
# z is bound to the value 100 before x is accessed
# illustrates lazy evaluation


# 3. What does this function return? Why? What principle does it illustrate?
y <- 10
f1 <- function(x = {y <- 1; 2}, y = 0){
  c(x, y)
}
f1() # returns c(2, 1)
y    # returns 10

# when x is accessed while evaluating c(x, y), x is bound to 2, y is bound to 1
# promise y = 0 is not evaluated because y has already been assigned a value
# value of y outside function is not affected by assignment of y inside function
# illustrates name masking


# 4. In hist(), the default value of xlim is range(breaks), the default value
# for breaks is "Sturges", and
range("Sturges")
# Explain how hist() works to get a correct xlim value.

# range is a character vector of size 2


# 5. Explain why this function works. Why is it confusing?
show_time <- function(x = stop("Error!")){
  stop <- function(...) Sys.time()
  print(x)
}
show_time()

# stop function is defined before x is accessed, masking default
# so instead of using the base stop function,
# x calls the defined stop function that returns the system time

# if x is supplied by user, behavior of function changes
# and stop function is not overwritten inside function
show_time(x = stop("Error!"))


# 6. How many arguments are required when calling library()?
args(library)

# no arguments are required, calling library() without arguments
# prints all packages in the directories in lib.loc
# which itself defaults to directories listed in .libPaths()
library()
