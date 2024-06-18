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
