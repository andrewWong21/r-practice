library("tidyverse")
library("nycflights13")

# one option for handling unusual values is to drop the row entirely
# however, this is not recommended as the other observations in the row
# may still be valid, and dataset may become too small after row removal
diamonds2 <- diamonds |> 
  filter(between(y, 3, 20))

# alternatively, unusual values can be replaced with missing values
# which will not be plotted with ggplot, though outputs will warn of removals
diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point()

# removed row warnings can be suppressed with na.rm = TRUE
ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

# compare scheduled departure times for cancelled and non-cancelled flights
flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 0.25)

# -------------------------------------------------------------------------

# 1. What happens to missing values in a histogram? What happens to missing 
# values in a bar chart? Why is there a difference in how missing values are
# handled in histograms and bar charts?
cancelled_flights <- flights |> 
  filter(is.na(air_time))

ggplot(cancelled_flights, aes(x = dep_time)) + 
  geom_histogram()

ggplot(cancelled_flights, aes(x = dep_time)) + 
  geom_bar()

# Histograms and bar charts both remove missing values regardless of na.rm
# being TRUE or FALSE, resulting in empty bins or bars of zero height.


# 2. What does na.rm = TRUE do in mean() and sum()?
vals <- c(1, 2, 3, NA, 5, 6, 7)

sum(vals)                # NA
sum(vals, na.rm = TRUE)  # 24

mean(vals)               # NA
mean(vals, na.rm = TRUE) # 24 / 6 = 4

# specifying na.rm = TRUE removes all missing values before computation
# sum() and mean() will evaluate to NA if na.rm = FALSE and there is a
# missing value in the group of numbers provided


# 3. Recreate the frequency plot of scheduled_dep_time colored by whether the
# flight was cancelled or not. Also facet by the cancelled variable. Experiment
# with different values of the scales variable in the faceting function to 
# mitigate the effect of more non-cancelled flights than cancelled flights.
flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 0.25) + 
  facet_wrap(~cancelled, scales = "free_y")

