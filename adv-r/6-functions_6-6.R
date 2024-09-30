# functions can have special argument, ...
# allows for variable number of additional arguments
# varargs (variable arguments), variadic function

i01 <- function(y, z){
  list(y = y, z = z)
}

# ... can be used to pass arguments to an additional function
i02 <- function(x, ...){
  i01(...)
}

str(i02(x = 1, y = 2, z = 3))

# ..N can be used to refer to additional elements by position

# list(...) evaluates arguments and stores them in a list