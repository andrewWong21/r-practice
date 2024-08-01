# 1. Given the following data frame, create a new column "3" that contains
# the sum of columns "1" and "2" while only using $.
# What makes "1", "2", "3" challenging as variable names?
df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)

# 2. In the following code, how much memory does "y" occupy?
x <- runif(1e6)
y <- list(x, x, x)

# 3. On which line does "a" get copied in the following example?
a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10

# knowing distinction between names and objects is important
# improve accuracy of predictions of code performance and memory usage
# write faster code by avoiding accidental copies of code
# improve understanding of functional programming tools in R

# use lobstr package to dig into internal R object representations
library(lobstr)

# distinction between names and values

# the following statement does two things:
# creates a object - vector of values 1, 2, 3
# binds object to name, "x"
x <- c(1, 2, 3)

# crucial distinction: object is value, name has value
# i.e. name is reference to value, object does not have name

# the following statement creates another binding for existing object in memory
# does not create copy of value
y <- x

# access object identifier with lobstr::obj_addr()
# identifiers change every time R is restarted
obj_addr(x)
obj_addr(y)

# syntactic names must only contain numbers, letters, digits, and underscores
# but cannot start with underscores or digits

# current locale determines whether certain symbols are letters
# R files that run on one computer may not run on another with different locale
# recommended to use ASCII characters only when naming objects

# reserved words like if, NA, function, NULL cannot be used as names
# error is thrown when attempting to use reserved words as names
# view reserved words with ?Reserved

# rules can be overridden by surrounding otherwise invalid names with backticks
# data created outside of R may contain non-syntactic names when loaded

# situations where R makes copies

# memory occupied by objects

# -------------------------------------------------------------------------

# 1. Explain the relationship between a, b, c, and d in the following code:
a <- 1:10
b <- a
c <- b
d <- 1:10

lobstr::obj_addr(a)
lobstr::obj_addr(b)
lobstr::obj_addr(c)
lobstr::obj_addr(d)

# a, b, c point to the same object in memory
# while d points to a different object in memory despite having the same values


# 2. The following code accesses the mean function in different ways.
# Do they all point to the same underlying function object?
# Verify this with lobstr::obj_addr().
lobstr::obj_addr(mean)
lobstr::obj_addr(base::mean)
lobstr::obj_addr(get("mean"))
lobstr::obj_addr(evalq(mean))
lobstr::obj_addr(match.fun("mean"))
# all statements point to the same object in memory


# 3. By default, base R import functions, like read.csv(), will automatically
# convert non-syntactic names to syntactic ones. Why might this be problematic?
# What option allows you to suppress this behavior?

# conversion may cause issues with back-compatibility
# regarding names containing underscores, which were originally not valid
# suppress syntactic name conversion by setting check.names to false


# 4. What rules does make.names use to convert non-syntactic names into
# syntactic ones?

# character X is prepended if necessary
# invalid characters are translated to a dot
# missing values are translated to NA
# names matching R keywords have a dot appended
# duplicate values are altered by make.unique, appending sequence numbers

make.names(c("a and b", "a-and-b"), unique = TRUE)
make.names(c("a and b", "a_and_b"), unique = TRUE)
make.names(c("a and b", "a_and_b"), unique = TRUE, allow_ = FALSE)
make.names(c("", "X"), unique = TRUE)


# 5. Why is .123e1 not a syntactic name? Read ?make.names for the full details.

# .123e1 is not syntactic because it contains a dot followed by a number.
# Syntactic names may start with a dot not followed by a number.
.x <- 1
