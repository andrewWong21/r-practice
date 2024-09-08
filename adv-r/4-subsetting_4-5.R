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
