library("tidyverse")
library("palmerpenguins")

1 / 200 * 30

(59 + 73 + 2) / 3

sin(pi / 2)

# use Alt + - (minus) to quickly write assignment operator <-
x <- 3 * 4
# enter variable name into console to view value
x

# c() combines elements into vector or list
primes <- c(2, 3, 5, 7, 11)

# basic arithmetic is applied elementwise to vectors
primes * 2

# snake_case is recommended for variable names

exponent <- 2^3

# seq() works like range() in python with inclusive end
seq(from = 1, to = 10)
seq(1, 10)

# RStudio provides paired quotation marks
x <- "hello world"

# assigned variables and their values are visible in environment tab, similar to MATLAB

# --------------------------------------------------------------------------------

# 1. Why does this code not work?
my_variable <- 10
# my_varıable
# dotless i symbol used in place of i on second line


# 2. Tweak each of the following R commands so they run correctly:
library(tidyverse)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(method = "lm")


# 3. Press Alt+shift+K. What happens? How can you get to the same place using the menus?
# Alt+Shift+K opens the keyboard shortcuts menu. This menu can also be accessed from the Help tab in the toolbar.


# 4. Let's revisit an exercise from Section 1.6. Which of the two plots is saved as mpg-plot-2-5.png? Why?
my_bar_plot <- ggplot(mpg, aes(x = class)) + 
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()
ggsave(filename = "mpg-plot-2-5.png", plot = my_bar_plot)
# The bar plot is saved with the given filename because the plot argument for ggsave()
# was specified with my_bar_plot, which was assigned the bar plot showing frequencies of car types.
# ggsave() defaults to the last plot displayed unless specified.
