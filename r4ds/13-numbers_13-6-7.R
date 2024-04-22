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
flights |> 
  group_by(year, month, day) |> 
  summarize(
    max = max(dep_delay, na.rm = TRUE),
    q95 = quantile(dep_delay, 0.95, na.rm = TRUE),
    .groups = "drop"
  )
  

# -------------------------------------------------------------------------

# 1. Brainstorm at least 5 different ways to assess the typical delay
# characteristics of a group of flights. When is mean() useful? When is 
# median() useful? When might you want to use something else? Why might you
# want to use data from the planes dataset?

# 2. Which destinations show the greatest variation in air speed?

# 3. Create a plot to further explore the adventures of EGE. Can you find any
# evidence that the airport moved locations? Can you find another variable
# that might explain the difference?
