# 1. What are the four common types of atomic vectors?
# What are the two rare types?

# 2. What are attributes? How do you get them and set them?

# 3. How is a list different from an atomic vector?
# How is a matrix different from a data frame?

# 4. Can you have a list that is a matrix?
# Can a data frame have a column that is a matrix?

# 5. How do tibbles behave differently from data frames?

# -------------------------------------------------------------------------

# two flavors of vectors: atomic vectors and lists
# elements of atomic vectors must all be of the same type
# lists may contain different types of elements

# NULL is closely related to vectors, often used as generic zero-length vector

# vectors can have attributes - dimension and class
# dimensions turns vectors into matrices and arrays
# classes are used by S3 object system

# atomic vectors: logical, integer, double, character

# attributes work as R's flexible metadata specification

# atomic vectors can be combined with special attributes
# including factors, dates, date-times, and durations

# lists are useful for representing hierarchical data of different types

# data frames and tibbles represent rectangular data, useful for statistics

# -------------------------------------------------------------------------

# four primary types of vectors are logical, double, integer, and character
# two rare types are complex (not needed in stats) and binary (raw data)

# theoretical distinction: R does not possess scalars
# all apparent scalars are vectors of length 1
1[1]
1[[1]]

# logicals can be written out fully (TRUE, FALSE) or abbreviated (T, F)

# doubles can be specified in decimal, scientific, or hexadecimal
# three special values for doubles are -Inf, Inf, and NaN

# integers are written like doubles, but must be suffixed with L
# and cannot contain fractional values

# strings may be surrounded with single or double quotes
# special characters are escaped with backslash \

# c() is a function used to combine vectors
lgl_var <- c(TRUE, FALSE)
int_var <- c(1L, 6L, 10L)
dbl_var <- c(1, 2.5, 6.5)
chr_var <- c("these are", 'some strings')

# c() flattens atomic vectors provided as inputs,
# creating a single atomic vector
c(c(1, 2), c(3, 4))

# use typeof() to get type of vector
typeof(lgl_var)
typeof(int_var)
typeof(dbl_var)
typeof(chr_var)

# use length() to get length of vector
length(lgl_var)
length(int_var)
length(dbl_var)
length(chr_var)

# NA is sentinel value for representing missing values
# missingness is usually infectious for computations
# computations with missing values often return missing values
NA > 5
10 * NA
!NA

# some exceptions for infectious missingness - boolean identities
NA ^ 0     # xor of different inputs
NA | TRUE  # x or true -> true
NA & FALSE # x and false -> false

# missingness propagation occurs with equality
x <- c(NA, 5, NA, 10)
x == NA

# use is.na() to properly test missingness
is.na(x)

# different missing values exist for each atomic type
# but NA is automatically coerced to types as needed
NA
NA_integer_
NA_real_
NA_character_
