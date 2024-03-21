library("tidyverse")

# these two plots show the same data in different ways
# scatterplot vs. line of best fit
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

# shape does not affect geom_smooth()
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()
# use linetype instead to differentiate lines
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()

# overlaying lines on top of data points colored by drv shows trend more clearly
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(aes(linetype = drv))

# geom_smooth() displays multiple rows of data with a single geometric object
# setting group aesthetic to categorical variable results in multiple objects
# mapping aesthetic to discrete variable provides more distinguishing features
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth(aes(color = drv), show.legend = FALSE)

# -------------------------------------------------------------------------

# 1. What geom would you use to draw a line chart? 
# A boxplot? A histogram? An area chart?
# line chart: geom_smooth()
# boxplot:    geom_boxplot()
# histogram:  geom_histogram(binwidth = n)
# area chart: geom_density()


# 2. Earlier in the chapter we used show.legend without explaining it:
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth(aes(color = drv))#, show.legend = FALSE)
# What does show.legend = FALSE do here? What happens if you remove it?
# Why do you think we used it earlier?
# show.legend = FALSE hides the legend for the lines
# removing this argument 

# 3. What does the se argument to geom_smooth do?
# The se argument determines whether the confidence interval around the line
# is shown. Its default value is TRUE, showing the confidence interval.


# Recreate the R code necessary to generate the following plots.
# Note that wherever a categorical value is used in the plot, it's drv.
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point(aes(group = drv)) + 
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(group = drv, color = drv)) + 
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(group = drv, color = drv)) + 
  geom_smooth(aes(linetype = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(group = drv, fill = drv), 
             shape = 21,
             color = "white",
             size = 3,
             stroke = 3
             )
