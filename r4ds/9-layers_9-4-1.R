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


