# R provides two ways to compose function calls
# (apply multiple functions in a given order)

# calculate population standard deviation using sqrt() and mean()
x <- runif(100)
x
square <- function(x) x^2
deviation <- function(x) x - mean(x)

# function calls can be nested
sqrt(mean(square(deviation(x))))

# or intermediate results can be saved as variables
out <- deviation(x)
out <- square(out)
out <- mean(out)
out <- sqrt(out)
out

# magrittr package provides %>% or |> operator to pipe functions together
library(magrittr)
x |> 
  deviation() |> 
  square() |> 
  mean() |> 
  sqrt()

# x |> f() is equivalent to f(x)
# x |> f(y) is equivalent to f(x, y)

# nesting is concise, but read inside out and right to left
# arguments end up spread out over long distances

# intermediate objects requires naming objects, useful if objects are important
# intermediate values are not very useful outside of process

# piping is read left to right, more straightforward than nesting
# but can only be used for linear transformations, requires third-party package

# code often combines different styles, piping is more common in data analysis

# scoping is the act of finding a value associated with a name

# R uses lexical scoping
# values are looked up based on how a function is defined, not called
# scoping rules use a parse-time structure
x <- 10
g01 <- function(){
  x <- 20
  x
}
g01()

# four primary rules of scoping
# name masking, functions vs. variables, fresh start, dynamic lookup

# name masking - names defined inside a function mask names defined outside
x <- 10
y <- 20
g02 <- function(){
  x <- 1
  y <- 2
  c(x, y)
}
g02()

# R looks one level up if name is not defined within function
x <- 2
g03 <- function(){
  y <- 1
  c(x, y)
}
g03()

# previous value of y is not changed
y

# rules can be extrapolated to nested functions
# R will check inside function, then where function was defined, and so on
# until global environment is reached, then loaded packages are checked
x <- 1
g04 <- function(){
  y <- 2
  i <- function(){
    z <- 3
    c(x, y, z)
  }
  i()
}
g04()

# R's scoping rules also apply to functions since they are objects too
g07 <- function(x) x + 1
g08 <- function(){
  g07 <- function(x) x + 100
  g07(10)
}
g08()

# when function and non-function share name, R will ignore non-function objects
# when looking for a name used in a function call
# not recommended to give different objects the same name
g09 <- function(x) x + 100
g10 <- function(){
  g09 <- 10
  g09(g09)
}
g10()

# a function creates a new environment for hosting its execution
# each time it is called, so it cannot keep track of previous calls

# g11 returns the same value every time it is called
# returns 1 because the name "a" does not exist in the execution environment
g11 <- function(){
  if (!exists("a")){
    a <- 1
  }
  else{
    a <- a + 1
  }
  a
}
g11()
g11()

# lexical scoping determines where to look for values
# R looks for values at runtime instead of compile-time
# output of function may differ depending on objects outside of its environment
g12 <- function() x + 1
x <- 15
g12() # 16
x <- 20
g12() # 21

# use codetools::findGlobals() to list a function's external dependencies
codetools::findGlobals(g12)

# fix external dependency by changing function environment to empty environment
environment(g12) <- emptyenv()
g12() # returns error

# R relies on lexical scoping to find every object,
# including functions (e.g. mean()) and built-ins (e.g. +, -)
# which allows for simplicity in scoping rules

# -------------------------------------------------------------------------
