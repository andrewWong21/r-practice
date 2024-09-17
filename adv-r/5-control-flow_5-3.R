# use for loops to iterate over items in a vector
# syntax: for (item in vector) perform_action
for (i in 1:3) print(i)

# assignment of loop variable overwrites any previous values
i <- 100
for (i in 1:3){}
i

# use next to exit current iteration, break to exit loop
for (i in 1:10){
  if (i < 3)
    next
  
  print(i)
  
  if (i == 5)
    break
}

# pitfalls to 

# always preallocate output container, otherwise performance will be slow
means <- c(1, 50, 20)
out <- vector("list", length(means))
for (i in 1:length(means)){
  out[[i]] <- rnorm(10, means[[i]])
}
out

# when iterating through 1:length(x), consider if x may be of length 0
# "invalid arguments" error message is not indicative of issue
means <- c()
out <- vector("list", length(means))
for (i in 1:length(means)){
  out[[i]] <- rnorm(10, means[[i]])
}

# colon syntax works with increasing and decreasing sequences
1:length(means)

# seq_along(x) returns a value the same length as x
seq_along(means)

out <- vector("list", length(means))
for (i in seq_along(means)){
  out[[i]] <- rnorm(10, means[[i]])
}
out

# iterating over S3 vectors may result in issues
# loops typically strip attributes from S3 vectors, obscuring values
xs <- as.Date(c("2020-01-01", "2010-01-01"))
for (x in xs){
  print(x)
}

# instead, refer to elements with [[]]
for (i in seq_along(xs)){
  print(xs[[i]])
}

# if loops work well when start and end values to iterate over are known
# use while() to perform an action while a given condition is true
# use repeat() to perform an action forever, or until break keyword reached

# loop flexibility (increasing): for, while, repeat
# best to use least flexible type of loop applicable for each situation

# data analysis tends to use map() and apply() for iterations

# R has no equivalent syntax for performing a do-while loop


# if() is used with scalars, ifelse() is used with vectors

y <- if (x) 3
# if x is TRUE, value of y is 3
# if x is FALSE, value of y is NULL
# if x is NA, statement returns error

switch("x", 
  x = ,
  y = 2, 
  z = 3
)
# result is 2 as x falls through to case y, which returns 2

# -------------------------------------------------------------------------

# 1. Why does this code succeed without warnings?
x <- numeric()
out <- vector("list", length(x))
for (i in 1:length(x)) {
  out[i] <- x[i] ^ 2
}
out
# 1:length(x) results in 1:0


# 2. When the following code is evaluated, what can you say about
# the vector being iterated?
xs <- c(1, 2, 3)
for (x in xs) {
  xs <- c(xs, x * 2)
}
xs
# x is evaluated once at the beginning of each loop


# 3. What does the following code tell you about when the index is updated?
for (i in 1:3){
  i <- i * 2
  print(i)
}

# no error is returned, loop proceeds through 3 iterations
# indexing variable is reassigned at beginning of each iteration
