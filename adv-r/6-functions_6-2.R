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
# function objects are created with function() and bound to a name with <- 

# binding function object to a name is not required - functions may be anonymous
lapply(mtcars, function(x) length(unique(x)))

# functions can be placed in a list
funs <- list(
  half = function(x) x / 2,
  double = function(x) x * 2
)

funs$half(10)
funs$double(10)

# functions are normally invoked by placing arguments in parentheses after name
mean(1:10, na.rm = TRUE)

# if arguments are already in a data structure, can also use do.call(fun, args)
# where fun is the name of the function and args is a list of arguments
args <- list(1:10, na.rm = TRUE)
do.call(mean, args)

# -------------------------------------------------------------------------

# 1. Given a name, match.fun() lets you find a function. Given a function,
# can you find its name? Why doesn't that make sense in R?

# functions may have more than one name bound to them
# or they may be anonymous functions with no name at all


# 2. It's possible (although typically not useful) to call an anonymous
# function. Which of the two approaches below is correct? Why?

# incorrect - calling f throws an error as it attempts to return 3()
f <- function(x) 3()
f()
# correct - function is wrapped in parentheses
(function(x) 3)()


# 3. A good rule of thumb is that an anonymous function should fit on one line
# and shouldn't need to use {}.

# 4. What function allows you to tell if an object is a function?
# What function allows you to tell if an object is a primitive function?

# use is.function(x) to test if x is a function
is.function(3)
is.function(mean)
is.function(sum)
is.function(`[`)

# use is.primitive(x) to test if x is a primitive function
is.primitive(3)
is.primitive(mean)
is.primitive(sum)
is.primitive(`[`)


# 5. This code makes a list of all functions in the base package.
objs <- mget(ls("package:base", all = TRUE), inherits = TRUE)
funcs <- Filter(is.function, objs)
objs
funcs

# Which function has the most arguments?
t <- tibble::tibble(
  funcs = funcs, 
  args = sapply(lapply(funcs, formals), length)
)
# function with 22 arguments
t |> 
  dplyr::filter(args == max(args))

fun <-  t |> 
  dplyr::filter(args == max(args)) |> 
  dplyr::select(funcs) |> 
  dplyr::pull()
fun
  
head(t)

# How many base functions have no arguments?

# How could you adapt the code to find all primitive functions?
# modify funcs to Filter(is.primitive, objs)


# 6. What are the three important components of a function?

# the three components of a function are its arguments, body, and environment


# 7. When does printing a function not show the environment it was created in?

print(mean)
# if function is primitive function or created in global environment,
# then its environment is not printed
print(sum)
print(`[`)
print(funs$double)
print(funs$half)
