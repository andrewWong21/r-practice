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

# across() is useful for operating on multiple columns within functions
expand_dates <- function(df){
  df |> 
    mutate(
      across(where(is.Date), list(year = year, month = month, day = mday))
    )
}

df_date <- tibble(
  name = c("Amy", "Bob"),
  date = c(ymd("2009-08-03", ymd("2010-01-16")))
)

df_date |> 
  expand_dates()

# across() allows supplying multiple columns to a single argument
# first argument of across() uses tidy-select so it must be embraced
summarize_means <- function(df, summary_vars = where(is.numeric)){
  df |> 
    summarize(
      across({{ summary_vars }}, \(x) mean(x, na.rm = TRUE)),
      n = n(),
      .groups = "drop"
    )
}

diamonds |> 
  group_by(cut) |> 
  summarize_means()

diamonds |> 
  group_by(cut) |> 
  summarize_means(c(carat, x:z))

# connection between across() and pivot_longer()
# same calculations performed by first pivoting data, then
# performing operations by group rather than by column

# multi-function summary with across()
df |> 
  summarize(across(a:d, list(median = median, mean = mean)))

# same values obtained by pivoting longer, then summarizing by group
long <- df |> 
  pivot_longer(a:d) |> 
  group_by(name) |> 
  summarize(
    median = median(value),
    mean = mean(value)
  )
long

# same structure can then be obtained by pivoting wider
long |> 
  pivot_wider(
    names_from = name,
    values_from = c(median, mean),
    names_vary = "slowest",
    names_glue = "{name}_{.value}"
  )

# problem not currently possible to solve with across()
# groups of columns to be computed with simultaneously
df_paired <- tibble(
  a_val = rnorm(10),
  a_wts = runif(10),
  b_val = rnorm(10),
  b_wts = runif(10),
  c_val = rnorm(10),
  c_wts = runif(10),
  d_val = rnorm(10),
  d_wts = runif(10)
)
df_paired

# straightforward to solve with pivot_longer()
df_long <- df_paired |> 
  pivot_longer(
    everything(),
    names_to = c("group", ".value"),
    names_sep = "_"
  )
df_long

df_long |> 
  group_by(group) |> 
  summarize(mean = weighted.mean(val, wts))

# pivoting wider to return to original form
df_long |> 
  group_by(group) |> 
  summarize(mean = weighted.mean(val, wts)) |> 
  pivot_wider(
    names_from = group,
    values_from = mean,
    names_glue = "{group}_{.value}"
  )

# -------------------------------------------------------------------------

# 1. Practice your across() skills by:

# Computing the number of unique values in each column of 
# the data frame palmerpenguins::penguins.
palmerpenguins::penguins |> 
  summarize(across(everything(), n_distinct))

# Computing the mean of every column in mtcars.
mtcars |> 
  summarize(across(where(is.numeric), mean))

# Grouping diamonds by cut, clarity, and color then counting the number of 
# observations and computing the mean of each numeric column.
diamonds |> 
  group_by(cut, clarity, color) |> 
  mutate(n = n()) |> 
  summarize(
    across(where(is.numeric), mean), 
    .groups = "drop"
  )
# observations in the same group have the same value for the column n
# so computing the mean of n within a group has no noticeable effect


# 2. What happens if you use a list of functions in across(),
# but don't name them? How is the output named?

# The functions are assigned numbers which are then used in the column names 
diamonds |> 
  summarize(across(where(is.numeric), list(median, mean)))


# 3. Adjust expand_dates() to automatically remove date columns after
# they've been expanded. Do you need to embrace any arguments?

# since all date columns are expanded, can select all non-date columns
# after expanding them into their components
expand_dates_filter <- function(df){
  df |> 
    mutate(
      across(where(is.Date), list(year = year, month = month, day = mday))
    ) |> 
    select(-where(is.Date))
}
df_date |> 
  expand_dates_filter()


# 4. Explain what each step of this pipeline does. What special feature of
# where() are we taking advantage of?

show_missing <- function(df, group_vars, summary_vars = everything()){
  df |> 
    # group by user-specified columns
    group_by(pick({{ group_vars }})) |> 
    # count missing values in each column in summary_vars for each group
    summarize(
      across({{ summary_vars }}, \(x) sum(is.na(x))),
      .groups = "drop"
    ) |> 
    # select columns that have a nonzero value in at least one group
    # uses ability to define custom function for where()
    # which returns variables to be used in select()
    select(where(\(x) any(x > 0)))
}
nycflights13::flights |> show_missing(c(year, month, day))
