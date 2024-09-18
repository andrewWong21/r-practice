# functions can be broken down into three components
# arguments, body, and environment

# R has some primitive base functions implemented in C

# functions are objects, just like vectors are objects

# functions have three parts: 
# formals(), list of arguments for controlling function calls
# body(), code inside function
# environment(), data structure for finding values associated with names

fo2 <- function(x, y){
  # A comment
  x + y
}

formals(fo2)
body(fo2)
environment(fo2)
