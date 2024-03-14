library("tidyverse")

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "data/diamonds.csv")
# use relative paths inside a project
# project can be launched from .Rproj file

# multiple library calls can be wrapped in brackets to run all calls with Ctrl+Enter

# R diagnostics can be configured to warn of incorrect number of arguments, mismatched arguments,
# undefined variables within scope, and defined but unused variables