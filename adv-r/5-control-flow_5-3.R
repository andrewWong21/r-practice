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
