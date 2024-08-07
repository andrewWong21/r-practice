library("lobstr")
# two exceptions to copy-on-modify, resulting in in-place modification instead
# objects with a single name bound to them are modified in-place
# environments are always modified in-place

v <- c(1, 2, 3)
ref(v)
cat(tracemem(v), "\n")

v[[3]] <- 4
ref(v)

# R may make in-place modification for optimization or it may not
# R maintains reference counts, counting 0, 1, or many bindings for an object
# removing a binding from an object with 2 bindings
# still results in an object with "many" bindings according to R
# so R may still make copies for objects with only one binding

# calling most functions makes a reference to the object
# primitive C functions found in base package are an exception

# for loops in R tend to be slow due to copies being made each loop
x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))
medians <- vapply(x, median, numeric(1))

for (i in seq_along(medians)){
  x[[i]] <- x[[i]] - medians[[i]]
}

# three copies of data frame are made in each loop
# two are made due to [[]], a third copy is made
# due to reference count of x increasing by 1 as a result of using [[]]
cat(tracemem(x), "\n")
for (i in 1:5){
  x[[i]] <- x[[i]] - medians[[i]]
}
untracemem(x)

# reduce number of copies by using list instead of data frame
# lists use C code for modification, reference count is not incremented
y <- as.list(x)
cat(tracemem(y), "\n")

for (i in 1:5){
  y[[i]] <- y[[i]] - medians[[i]]
}

# easy to determine when a copy is being made, hard to prevent it
# rewriting functions in C++ may be a feasible solution to avoid copies
