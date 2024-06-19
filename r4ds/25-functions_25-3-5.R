{
  library("tidyverse")
  library("nycflights13")
}

# dplyr verbs may be repeated within large pipelines
# data frame functions work like dplyr verbs, can reduce verb repetition
# take data frame as argument and return data frame or vector as output

# problem of indirection when writing functions using dplyr verbs

# computing mean of mean_var grouped by group_var
grouped_mean <- function(df, group_var, mean_var){
  df |> 
    group_by(group_var) |> 
    summarize(mean(mean_var))
}

# error: group_var not found
diamonds |> grouped_mean(cut, caret)

df <- tibble(
  mean_var = 1,
  group_var = "g",
  group = 1,
  x = 10,
  y = 100
)
df

# calling grouped_mean() uses the variables 'group_var' and 'mean_var'
# instead of the specified columns passed to it
df |> grouped_mean(group, x)
df |> grouped_mean(group, y)

# tidyr uses tidy evaluation - allows referring to data frame variables
# without special treatment, resulting in concise analyses
# but requires workaround for wrapping up repeated tidyverse code

# embracing wraps variable in braces e.g. var becomes {var}
# indicates that tidyr should use value stored inside, not the variable name
grouped_mean <- function(df, group_var, mean_var){
  df |> 
    group_by({{ group_var }}) |> 
    summarize(mean({{ mean_var }}))
}
grouped_mean(df, group, x)

# need to determine which arguments should be embraced
# search in documentation for two terms, most common types of tidy evaluation
# data-masking: compute with variables, e.g. arrange(), filter(), summarize()
# tidy-selection: select variables, e.g. select(), relocate(), rename()
# consider whether function computes (x + 1) or selects (a:x)

# repeated summaries during data exploration can be wrapped in helper function
# when using summarize() in helper, good practice to set .groups = "drop"
# to leave data in ungrouped state
summary6 <- function(data, var){
  data |> summarize(
    min = min({{ var }}, na.rm = TRUE),
    mean = mean({{ var }}, na.rm = TRUE),
    median = median({{ var }}, na.rm = TRUE),
    max = max({{ var }}, na.rm = TRUE),
    n = n(),
    n_miss = sum(is.na({{ var }})),
    .groups = "drop"
  )
}
diamonds |> summary6(carat)

# summary6() can be used on grouped data since it wraps summarize()
diamonds |> 
  group_by(cut) |> 
  summary6(carat)

# arguments to summarize() are data-masking, so summary6() arguments are too
# computed variables can be summarized with summary6()
diamonds |> 
  group_by(cut) |> 
  summary6(log10(carat))

# variation of count() that also computes proportions
# count() uses data-masking for all variables so var must be embraced
# default value for sort provided, defaults to FALSE if not specified
count_prop <- function(df, var, sort = FALSE){
  df |> 
    count({{ var }}, sort = sort) |> 
    mutate(prop = n / sum(n))
}
diamonds |> count_prop(clarity)

# find sorted unique values of variable in subset of data
# supply variable and condition to filter by
# condition is embraced because it is passed to filter()
# var is embraced because it is passed to distinct() and arrange()
unique_where <- function(df, condition, var){
  df |> 
    filter({{ condition }}) |> 
    distinct({{ var }}) |> 
    arrange({{ var }})
}
flights |> unique_where(month == 12, dest)

# data frame can be hardcoded into function if working repeatedly with data
# select time_hour, carrier, and flight columns from flights data frame
# these columns form compound primary key for row identification
subset_flights <- function(rows, cols){
  flights |> 
    filter({{ rows }}) |> 
    select(time_hour, carrier, flight, {{ cols }})
}
subset_flights()

# pick() allows using tidy-selection within data-masking functions
# count number of missing observations in rows
# group_by() uses data-masking, but tidy-selection is needed within it
count_missing <- function(df, group_vars, x_var){
  df |> 
    group_by(pick({{ group_vars }})) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}
flights |>
  count_missing(c(year, month, day), dep_time)

# pick() can also be used to make 2D table of counts
# use vars in rows and cols, then use pivot_wider() to rearrange into grid
count_wide <- function(data, rows, cols){
  data |> 
    count(pick(c({{ rows }}, {{ cols }}))) |> 
    pivot_wider(
      names_from = {{ cols }},
      values_from = n,
      names_sort = TRUE,
      values_fill = 0
    )
}
diamonds |> 
  count_wide(c(clarity, color), cut)

# tidy evaluation underpins tidyr
# names_from in pivot_wider uses tidy-selection

# -------------------------------------------------------------------------

# 1. Using datasets from nycflights13, write a function that:

# finds all flights that were cancelled or delayed by more than an hour
filter_severe <- function(data){
  data |> 
    filter(is.na(arr_time) | arr_delay > 60)
}
flights |> filter_severe()

# counts number of flights that were cancelled or delayed by more than an hour
summarize_severe <- function(data){
  data |> 
    filter_severe() |> 
    count()
}
flights |> group_by(dest) |> summarize_severe()

# finds all flights that were cancelled
# or delayed by a user-supplied number of hours
filter_severe <- function(data, hours = 1){
  data |> 
    filter(is.na(arr_time) | arr_delay > 60 * hours)
}
flights |> filter_severe(hours = 2)

# summarizes weather to compute minimum, mean, maximum of user-supplied variable
summarize_weather <- function(data, var){
  data |> 
    summarize(
      min = min({{ var }}, na.rm = TRUE),
      mean = mean({{ var }}, na.rm = TRUE),
      max = max({{ var }}, na.rm = TRUE),
    )
}
weather |> summarize_weather(temp)

# converts user-supplied variable using clock time into decimal time
standardize_time <- function(data, var){
  data |> 
    mutate(
      decimal_time = {{ var }} %/% 100 + ({{ var }} %% 100) / 60,
      .keep = "used"
    )
}
flights |> standardize_time(sched_dep_time)

# 2. For each of the following functions list all arguments that use tidy
# evaluation and describe whether they use data-masking or tidy-selection:

# distinct()
# ...: <data-masking>

# count()
# ..., wt: <data-masking>

# group_by()
# ...: <data-masking>

# rename_with()
# ..., .cols: <tidy-select>

# slice_min()
# ..., order_by, weight_by: <data-masking>
# .by: <tidy-select>

# slice_sample()
# ..., order_by, weight_by: <data-masking>
# .by: <tidy-select>


# 3. Generalize the following function to allow supplying any number of
# variables to count.
count_prop <- function(df, var, sort = FALSE){
  df |> 
    count({{ var }}, sort = sort) |> 
    mutate(prop = n / sum(n))
}

# count() uses data-masking, so pick() is needed for tidy-selection within
count_props <- function(df, var, sort = FALSE){
  df |> 
    count(pick({{ var }}), sort = sort) |> 
    mutate(prop = n / sum(n))
}
diamonds |> count_props(c(clarity, color))
