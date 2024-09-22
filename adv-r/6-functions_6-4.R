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
