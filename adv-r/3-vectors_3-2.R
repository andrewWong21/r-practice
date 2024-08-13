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

# can test if vector is of given type with is.*()
# is.logical(), is.integer(), is.double(), is.character()
is.logical(lgl_var)
is.integer(int_var)
is.double(dbl_var)
is.character(chr_var)

# avoid is.vector(), is.atomic(), is.numeric() due to caveats

# type is property of entire atomic vector
# combining different types coerces them in a fixed order
# character -> double -> integer -> logical

# e.g. combining character and integer yields character
str(c("a", 1))

# mathematical functions typically coerce to numeric
# useful for logical vectors, coercing TRUE to 1 and FALSE to 0
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)

sum(x)

mean(x)

# deliberate coercion can be performed with as.*()
# as.logical(), as.integer(), as.double(), as.character()
# if coercion fails, result is missing value and warning is generated
as.integer(c("1", "1.5", "a"))

# -------------------------------------------------------------------------

# 1. How do you create raw and complex scalars?
xx <- raw(2)
xx

raw(1)

# use as.raw() to coerce a numeric argument to raw type
# or charToRaw() for character arguments
xx[1] <- as.raw(40)
xx

xx[2] <- charToRaw("A")
xx

# complex() constructor takes length, real, and imaginary parts
complex(length.out = 2, real = c(1, 2), imaginary = c(3, 4))
complex(length.out = 1, real = 3, imaginary = -7)

# can create imaginary numbers without real parts
complex(length.out = 1, real = 0, imaginary = 2)


# 2. Test your knowledge of the vector coercion rules by predicting the output
# of the following uses of c():
c(1, FALSE)
c("a", 1)
c(TRUE, 1L)


# 3. Why is 1 == "1" true? Why is -1 < FALSE true? Why is "one" < 2 false?

# 1 == "1" is true
c(1, "1")

# -1 < FALSE is true
c(-1, FALSE)

# "one" < 2 is false
c("one", 2)


# 4. Why is the default missing value, NA, a logical vector?
# What's special about logical vectors?

c(FALSE, NA_character_)


# 5. Precisely what do is.atomic(), is.numeric(), and is.vector() test for?
