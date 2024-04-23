{
  library(tidyverse)
  library(nycflights13)
}

# definition of mean as sum divided by count makes it sensitive to outliers
# median may be a better measure of center if there are many outliers
# 50% of values occur on either side of median

# generally, mean is reported for symmetric distributions
# and median is reported for skewed distributions

# comparing mean vs. median departure delay in minutes
# median delay is smaller because flights may leave a few hours late
# but generally not a few hours early, skewing the distribution
flights |> 
  group_by(year, month, day) |> 
  summarize(
    mean = mean(dep_delay, na.rm = TRUE),
    median = median(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  ggplot(aes(x = mean, y = median)) + 
  geom_abline(slope = 1, intercept = 0, color = "white", linewidth = 2) + 
  geom_point()

# mode is generally not used by statisticians, not provided in base R
# does not work well for many real datasets, as discrete data may have multiple
# most common values and continuous data may not have any most common values

# min() and max() provide smallest and largest values, respectively
# quantile() is a generalization of median that allows finding value in x
# that is greater than some specified percent of values
# quantile(x, 0.5) is equal to median, quantile(x, 0.25) is first quartile, etc.

# comparing max and q95 - top 5% of numerical column can be very extreme
flights |> 
  group_by(year, month, day) |> 
  summarize(
    max = max(dep_delay, na.rm = TRUE),
    q95 = quantile(dep_delay, 0.95, na.rm = TRUE),
    .groups = "drop"
  )

# two functions commonly used for finding the spread of a dataset
# sd() and IQR(), which calculate standard deviation and interquartile range
# IQR(x) = quantile(x, 0.75) - quantile(x, 0.25), range of middle 50% of data
flights |> 
  group_by(origin, dest) |> 
  summarize(
    distance_iqr = IQR(distance),
    n = n(),
    .groups = "drop"
  ) |> 
  filter(distance_iqr > 0)

# summary statistics are fundamentally reductive, picking wrong summary
# can result in missing important differences between groups
# visualize distribution before picking summary functions to test

# also check if the distributions for subgroups resemble that of the whole

# common shape between frequency polygons of dep_delay for each day
flights |> 
  filter(dep_delay < 120) |> 
  ggplot(aes(x = dep_delay, group = interaction(day, month))) + 
  geom_freqpoly(binwidth = 5, alpha = 0.2)

# can always create custom summaries for groups and separately summarizing them
# also include number of observations in each group if possible

# extract value at specific position of vector with first(), last(), nth(x, n)
# note that dplyr uses na_rm instead of na.rm
flights |> 
  group_by(year, month, day) |> 
  summarize(
    first_dep = first(dep_time, na_rm = TRUE),
    fifth_dep = nth(dep_time, 5, na_rm = TRUE),
    last_dep = last(dep_time, na_rm = TRUE)
  )

# three reasons to use extraction functions:
# can specify a default value with default argument if position does not exist
# order_by argument can locally override order of rows
# na_rm argument allows missing values to be dropped

# extracting at positions is complementary to filtering on ranks
# filtering gives all variables each in a separate row, unlike extracting
flights |> 
  group_by(year, month, day) |> 
  mutate(r = min_rank(sched_dep_time)) |> 
  filter(r %in% c(1, max(r)))

# -------------------------------------------------------------------------

# 1. Brainstorm at least 5 different ways to assess the typical delay
# characteristics of a group of flights. When is mean() useful? When is 
# median() useful? When might you want to use something else? Why might you
# want to use data from the planes dataset?

# 2. Which destinations show the greatest variation in air speed?

# 3. Create a plot to further explore the adventures of EGE. Can you find any
# evidence that the airport moved locations? Can you find another variable
# that might explain the difference?
