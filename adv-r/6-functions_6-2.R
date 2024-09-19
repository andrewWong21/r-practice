# functions can be broken down into three components
# arguments, body, and environment

# R has some primitive base functions implemented in C

# functions are objects, just like vectors are objects

# functions have three parts: 
# formals(), list of arguments for controlling function calls
# body(), code inside function
# environment(), data structure for finding values associated with names

f02 <- function(x, y){
  # A comment
  x + y
}

formals(f02)
body(f02)
environment(f02)

# formals and body are defined explicitly when creating a function
# environment is specified implicitly, according to where function is defined

environment(mean)
environment(dplyr::arrange)
environment(f02)

# functions may also possess attributes similarly to objects
# srcref, short for source reference, is an attribute that points to
# function's source code, including comments and formatting (unlike body())
attr(f02, "srcref")

# primitive functions in R directly call C code
sum
`[`
`[[`

# types of primitive functions may be builtin or special
typeof(sum)
typeof(`[`)
typeof(`[[`)

# these functions do not have a formals(), body(), or environment()
# and attempting to call them will return NULL
formals(sum)
body(sum)
environment(sum)

# R functions are objects in and of themselves - "first-class functions"
# no special syntax for creating functions

# binding function object to a name is not required - functions may be anonymous
lapply(mtcars, function(x) length(unique(x)))
