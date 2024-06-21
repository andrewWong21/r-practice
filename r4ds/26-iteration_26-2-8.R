library("tidyverse")

# implicit iteration in R: double a numeric vector x by writing 2 * x
1:5
2 * 1:5

# R provides lots of tools for iteration
# facet_wrap() and facet_grid() to plot subsets of data
# group_by() and summarize() to compute summary statistics of data
# unnest_wider() and unnest_longer() to make rows and columns from list-columns

# functional programming tools are built around
# functions that take other functions as inputs

# used for three common tasks: 
# modifying multiple columns, reading multiple files, saving multiple objects

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# computing medians of each column individually requires repetitive code
df |> summarize(
  n = n(),
  a = median(a),
  b = median(b),
  c = median(c),
  d = median(d)
)

# use across() to apply the same operation to multiple columns
df |> summarize(
  n = n(),
  across(a:d, median)
)

# across() has three important arguments
# .cols specifies columns to iterate over
# .fns specifies function or operations to apply to each column
# .names may be used to control names of output columns,
# useful in cases where across() is used with mutate()

# .cols uses same specification as select()
# can use starts_with() and ends_with() to select columns based on their name

# everything() selects all non-grouping columns
df2 <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df2

df2 |> 
  group_by(grp) |> 
  summarize(across(everything(), median))

# where() can be used to specify type
# e.g. where(is.numeric), is.character, is.Date, is.POSIXct, is.logical
# selectors can be combined with Boolean algebra

# .fns defines transformation of columns specified in .cols
# simple cases involve a single existing function
# specify a function with its name, not a call to the function itself

# more complex cases require multiple transformations or additional arguments
rnorm_na <- function(n, n_na, mean = 0, sd = 1){
  sample(c(rnorm(n - n_na, mean = mean, sd = sd), rep(NA, n_na)))
}

# finding median of columns where data frame has missing values
df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)
df_miss

# median propagates missing values by default
df_miss |> 
  summarize(across(a:d, median))

# to compute median without NAs, need anonymous (lambda) function to call median
# with the desired argument na.rm = TRUE
df_miss |> 
  summarize(across(a:d, function(x) median(x, na.rm = TRUE)))

# R has shortcut for anonymous function - replace function with backslash \
df_miss |> 
  summarize(across(a:d, \(x) median(x, na.rm = TRUE)))

# compute median and count removed missing values
# supply multiple functions to across() by specifying a named list for .fns
# output columns are named using a glue specification
# {.col}_{.fn}, original column name and function separated by underscore
df_miss |> 
  summarize(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    )),
    n = n()
  )

# output columns of across() are named according to .names argument
# specify function name before original column name with .names = "{.fn}_{.col}"
# column order can be changed afterwards with relocate()
df_miss |> 
  summarize(
    across(
      a:d,
      list(
        median = \(x) median(x, na.rm = TRUE),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    )
  )

# output of across() is given same names as inputs
# using across() with mutate() will replace existing columns by default

# using coalesce() to replace missing values with 0, replacing existing columns
df_miss |> 
  mutate(across(a:d, \(x) coalesce(x, 0)))

# same, but creating new columns instead
df_miss |> 
  mutate(across(a:d, \(x) coalesce(x, 0), .names = "{.col}_na_zero"))

# across() works well with summarize() and mutate()
# filter() may combine multiple conditions from different columns
# dplyr provides variants of across() with if_any() and if_all()

# df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))
df_miss |> filter(if_any(a:d, is.na))

# df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))
df_miss |> filter(if_all(a:d, is.na))
