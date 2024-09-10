# subassignment - combining subsetting with assignment
# to modify certain values of an input vector
# x[i] <- value

# value should be the same length as x[i], and i should be unique
# to prevent unexpected behavior from R's vector recycling rules
x <- 1:5
x[c(1, 2)] <- c(101, 102)
x

# use x[[i]] <- NULL to remove a component in a list
x <- list(a = 1, b = 2)
str(x)
x[["b"]] <- NULL
str(x)

# add a literal NULL as a component with x[i] <- list(NULL)
y <- list(a = 1, b = 2)
y["b"] <- list(NULL)
str(y)

# subsetting with empty brackets preserves original structure of object
mtcars[] <- lapply(mtcars, as.integer)
is.data.frame(mtcars)

# converts data frame into list after applying function
mtcars <- lapply(mtcars, as.integer)
is.data.frame(mtcars)

# selecting one or more elements and subsetting + assignment
# are useful to know when implementing functions for specific situations

# create lookup tables with character matching
# converting abbreviations into full terms
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]

# remove names with unname()
unname(lookup[x])

# lookup tables can be constructed with multiple columns of information
grades <- c(1, 2, 2, 3, 1)
info <- data.frame(
  grade = 3:1,
  desc = c("Excellent", "Good", "Poor"),
  fail = c(F, F, T)
)

# duplicate info table and create a row for each value in grades
# combine match() and integer subsetting
id <- match(grades, info$grade)
id
info[id, ]

# use integer indices to bootstrap or randomly sample a data frame
# sample(n) generates a random permutation of 1:n
df <- data.frame(x = c(1, 2, 3, 1, 2), y = 5:1, z = letters[1:5])
df

# randomly reorder rows of data frame
df[sample(nrow(df)), ]

# select 3 random rows without replacement
df[sample(nrow(df), 3), ]

# select 6 random rows with replacement
df[sample(nrow(df), 6, replace = TRUE), ]

# sample(x, size, replace = FALSE)
# select size samples from x without replacement (samples are only picked once)
# if replace = FALSE, size must be less than or equal to population size

# order(x) returns integer vector showing how x is ordered
# order(x)[i] is current index of element that should be at x[i] if ordered
# x[order(x)] returns sorted x
x <- c("b", "c", "a")
order(x)
x[order(x)]

# can use additional variables to break ties or specify decreasing = TRUE/FALSE
# missing values are placed at end by default, can remove with na.last = NA
# missing values can be placed at the front with na.last = FALSE

# use order() and integer subsetting to order an object by its rows or columns
df2 <- df[sample(nrow(df)), 3:1]
df2

# order df2 by column x, ascending
df2[order(df2$x), ]

# order columns of df2
df2[, order(names(df2))]

# vectors can be sorted directly with sort()
# data frames can be sorted with dplyr::arrange()

# some data frames collapse identical rows into one row with a count column
# combining integer subsetting and rep() allows for uncollapsing such tables
# rep(x, y) repeats x[i], y[i] times
df <- data.frame(
  x = c(2, 4, 1),
  y = c(9, 11, 6),
  n = c(3, 5, 1)
)
rep(1:nrow(df), df$n)
df[rep(1:nrow(df), df$n), ]

# columns can be removed from a data frame by setting columns to NULL
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df
df$z <- NULL
df

# alternatively, data frame can be subsetted to return relevant columns
df[c("x", "y")]

# specify columns to exclude with set operations
df[setdiff(names(df), "z")]

# logical subsetting can consider conditions of multiple columns at once
# conditions can be easily combined with & and |, "and" and "or"
mtcars[mtcars$gear == 5, ]
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]

# & and | are vector operators, while && and || are scalar operators (use in if)
# use De Morgan's laws to simplify boolean expressions
# !(x & y) is equivalent to !x | !y
# !(x | y) is equivalent to !x & !y

# !(x & !(y | z)) == !x | !!(y | z) == !x | y | z
