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
