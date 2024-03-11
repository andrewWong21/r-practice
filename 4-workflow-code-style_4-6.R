library("tidyverse")
library("nycflights13")

# make sure to consider n() when aggregating data to ensure
# sample size is large enough to draw accurate conclusions from data
library("Lahman")
batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
# baseball players with fewer at-bats have higher variation in performance
# generally as sample size increases, variation decreases (law of large numbers)

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) + 
  geom_point(alpha = 1 / 10) +
  geom_smooth(se = FALSE)
# positive correlation between skill and number of times at bat

batters |> 
  arrange(desc(performance))
# simply sorting by high performance does not provide accurate results
# the ones at the top are not necessarily the most skilled
# low sample sizes reduce reliability of measurements and conclusions

# use underscores to separate words within a variable name
short_flights <- flights |> filter(air_time < 60)

# put spaces on either side of mathematical operations
# z <- (a + b)^2 / d

# no spaces inside or outside () for function calls
# add spaces after commas separating function arguments
# mean(x, na.rm = TRUE)

# extra spaces may be added to improve alignment
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )

# pipe should be preceded by a space and should be the last thing on a line
flights |> 
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)

# put named arguments of a function on separate lines (e.g. for mutate(), summarize())
# if arguments are not named, keep them on a single line if they can fit
flights |> 
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
# indent lines by two spaces after first pipeline
# indent by another two spaces for named arguments separated 
# ) should be on a new line and match indentation of horizontal position of function name

# writing short pipelines on a single line is acceptable
# df |> mutate(y = x + 1)
# but increasing vertical space allows for easier pipeline extending

# break up long pipes into smaller subtasks or intermediate states with informative names

flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() +
  geom_line()
# watch for transition from dplyr's |> to ggplot's +

# Ctrl+Shift+R is keyboard shortcut for creating sectioning comments with headers

# -------------------------------------------------------------------------

# 1. Restyle the following pipelines following the guidelines above.
flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  ) |>
  filter(n > 10)

flights |> 
  filter(
    carrier == "UA",
    dest %in% c("IAH", "HOU"), 
    sched_dep_time > 0900,
    sched_arr_time < 2000
  ) |> 
  group_by(flight) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)),
    n = n()
  ) |> 
  filter(n > 10)
