{
  library("tidyverse")
  library("nycflights13")
}

# functions that take data frames as input can also return plots as output
# aes() is a data-masking function

# two histograms made with repeated code
diamonds |> 
  ggplot(aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)
diamonds |> 
  ggplot(aes(x = carat)) + 
  geom_histogram(binwidth = 0.5)

# wrap code into histogram function
histogram <- function(df, var, binwidth = NULL){
  df |> 
    ggplot(aes(x = {{ var }})) +
    geom_histogram(binwidth = binwidth)
}
diamonds |> histogram(carat, 0.1)

# histogram() returns a ggplot2 plot object, can add additional components
diamonds |> 
  histogram(carat, 0.1) + 
  labs(x = "Size (in carats)", y = "Number of diamonds")

# overlay straight line and smooth line to check linearity of dataset
linearity_check <- function(df, x, y){
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) + 
    geom_point() + 
    geom_smooth(method = "loess", formula = y ~ x, color = "red", se = FALSE) + 
    geom_smooth(method = "lm", formula = y ~ x, color = "blue", se = FALSE)
}

starwars |> 
  filter(mass < 1000) |> 
  linearity_check(mass, height)

# create hexplot for large datasets to handle overplotting issue
hex_plot <- function(df, x, y, z, bins = 20, fun = "mean"){
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }}, z = {{ z }})) + 
    stat_summary_hex(
      aes(color = after_scale(fill)),
      bins = bins,
      fun = fun
    )
}
diamonds |> hex_plot(carat, price, depth)

# some helper functions combine data manipulation with ggplot2
# generate sorted vertical bar chart with highest frequency at the top
# tidy evaluation treats walrus operator := as =
# embraced variable on left side of = can be treated as a literal name
# variable name is generated based on user-supplied data so := is needed
sorted_bars <- function(df, var){
  df |> 
    mutate({{ var }} := fct_rev(fct_infreq({{ var }}))) |> 
    ggplot(aes(y = {{ var }})) + 
    geom_bar()
}
diamonds |> sorted_bars(clarity)

# draw bar plot for subset of data
conditional_bars <- function(df, condition, var){
  df |> 
    filter({{ condition }}) |> 
    ggplot(aes(x = {{ var }})) + 
    geom_bar()
}
diamonds |> conditional_bars(cut == "Good", clarity)

# rlang is a low-level package used by other tidyverse packages
# implements tidy evaluation and provides englue() function
# which works like str_glue() but also combines embracing capabilities

# histogram function that labels output plot with variable and binwidth used
histogram_labeled <- function(df, var, binwidth){
  label <- rlang::englue("Histogram of {{var}} with binwidth {binwidth}")
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth) + 
    labs(title = label)
}
diamonds |> histogram_labeled(carat, 0.1)

# -------------------------------------------------------------------------

# 1. Build up a rich plotting function by incrementally implementing
# each of the steps below:

# Draw a scatterplot given dataset and x and y variables
custom_plot <- function(df, x, y){
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) + 
    geom_point()
}
palmerpenguins::penguins |>
  custom_plot(bill_length_mm, flipper_length_mm)

# Add a line of best fit (linear model with no standard errors).
custom_plot <- function(df, x, y){
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE)
}
palmerpenguins::penguins |>
  custom_plot(bill_length_mm, flipper_length_mm)

# Add a title.
custom_plot <- function(df, x, y){
  label <- rlang::englue("Scatterplot of {{ x }} vs. {{ y }}")
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) + 
    labs(title = label)
}
palmerpenguins::penguins |>
  custom_plot(bill_length_mm, flipper_length_mm)
