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

# four primary rules of scoping
# name masking, functions vs. variables, fresh start, dynamic lookup
