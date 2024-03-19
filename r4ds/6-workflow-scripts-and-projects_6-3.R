library("dplyr")
library("nycflights13")

# Ctrl+Shift+N to create new script
# Ctrl+Enter executes current R expression in console
# Ctrl+Shift+S executes entire script

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))

# scripts should start with their required packages, but not install.packages()
# filenames should be machine-readable, e.g. not case sensitive, no special characters
# filenames should be human-readable, with descriptive names
# filenames should work well with default ordering

# keep R scripts as source of truth for analyses, not workspace environment
# configure RStudio to not save workspace in between sessions
# and make a habit of storing calculation results in code

# Ctrl+Shift+F10 to restart R, clearing workspace if config is set correctly
# print current working directory with getwd()
# manually setting wd is not recommended

