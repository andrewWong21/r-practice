library("tidyverse")

# review: facet_wrap() splits single plot into subplots representing
# data for each possible value of categorical variable
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)

# plots can be faceted with a combination of two variables using facet_grid()
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

# by default, facets use same scale and range for both axes
# this behavior can be changed by specifying scales argument
# e.g. scales = "free"/"free_x"/"free_y"
# when an axis is specified as free, its scales will vary across rows/columns
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free")
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_x") # y always ranges from 10 to 45
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y") # x always ranges from 1.5 to 7


# -------------------------------------------------------------------------

# 1. What happens if you facet on a continuous variable?
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cty)
# One subplot is created for each distinct value of the continuous variable.
# This can cause performance issues when there are many distinct values.


# 2. What do the empty cells in the plot with facet_wrap(drv ~ cyl) mean?
# Run the following code. How do they relate to the resulting plot?
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))
# The empty cells indicate that there are no rows with that combination of
# values for drv and cyl.
# No row with drv = 4 has cyl = 5, and no row with drv = r has cyl = 4 or 5,
# so the subplots with those particular values for those variables are empty.


# 3. What plots does the following code make? What does . do?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .)
# plots hwy vs displ, faceted by drv with each subplot on a different row
# similar to faceting using facet_wrap(~drv, ncol = 1) but with
# facet labels on the right instead of at the top of each subplot
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~drv, ncol = 1)

# plots hwy vs displ with one row of subplots faceted by cyl
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

# faceting using facet_wrap(~cyl) creates a grid of subplots faceted by cyl
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~cyl)

# specifying nrow = 1 provides identical output as facet_grid(. ~ cyl)
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~cyl, nrow = 1)


# 4. Take the first faceted plot in this section.
# What are the advantages/disadvantages to using faceting instead of the
# color aesthetic? How might the balance change if you had a larger dataset?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = class))
# Faceting separates the data into multiple plots, which makes it easier to
# see trends for a subset of data but not the overall trend of the full dataset.
# With a larger dataset, color may become less useful if there are too many
# possible values for the variable mapped to it, and points may also overlap.


# 5. Read ?facet_wrap. What does nrow do? What does ncol do?
# What other options control the layout of the individual panels?
# Why doesn't facet_grid() have nrow and ncol arguments?

# nrow and ncol determine the output's number of rows and columns, respectively.
# as.table also affects the panel layout, changing the order they are laid out.
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~cty, ncol = 3, as.table = FALSE)

# facet_grid() uses the distinct values of the faceted variables to
# determine the number of rows and columns in the outputted plot.
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ class)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ .)


# 6. Which of the following plots makes it easier to compare engine size (displ)
# across cars with different drive trains? What does this say about when to
# place a faceting variable across rows or columns?
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(. ~ drv)

# It is easier to compare the histograms when the drive trains are on different
# rows with facet_grid(drv ~ .), as the histograms are stacked on top of each
# other, and the x-axis showing engine size is not duplicated.

# A faceting variable should be placed across rows when comparing with a
# variable mapped to the x-axis, and across columns when comparing with a 
# variable mapped to the y-axis.
ggplot(mpg, aes(y = displ)) + 
  geom_histogram() + 
  facet_grid(. ~ drv)


# 7. Recreate the following plot using facet_wrap() instead of facet_grid().
# How do the positions of the facet labels change?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ .)

# The facet labels are located at the top by default when using facet_wrap().
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~drv, nrow = 3)
