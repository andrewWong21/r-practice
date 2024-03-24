library("tidyverse")

# bar charts can be colored using color or fill aesthetic
ggplot(mpg, aes(x = drv, color = drv)) + 
  geom_bar()
ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()

# when fill is mapped to a variable, bars are automatically stacked
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar()

# position argument is "stack" by default, can be changed to
# "identity", "dodge", or "fill"

# "identity" is more useful for other geoms, as bars will overlap
# more suitable geoms include geom_point()
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "identity")

# to see all bars when they are stacked, lower alpha or set fill to NA
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(alpha = 0.2, position = "identity")

ggplot(mpg, aes(x = drv, color = class)) + 
  geom_bar(fill = NA, position = "identity")

# position = "fill" has consistent height for each bar, clear proportions
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

# position = "dodge" places bars next to each other for individual comparison
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")


# position = "jitter" is useful for scatterplots with high numbers of points
# overlapping points reduces visibility of distribution
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")

# jitter adds noise to each position to spread points out
# adding jitter makes plots less accurate at small scales,
# but more revealing at large scales

# shortcut for geom_point(position = "jitter") is geom_jitter()
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_jitter()

# -------------------------------------------------------------------------

# 1. What is the problem with the following plot? How could you improve it?
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()

# There are less than 100 points on the scatterplot, but there are
# 224 rows in the dataset, so there must be overlapping points.
# Using geom_jitter() instead reveals the full distribution of the points.
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter()


# 2. What, if anything, is the difference between the two plots? Why?
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "identity")
# There is no difference in the plots because the default value for the 
# position argument of geom_point() is "identity".

# 3. What parameters to geom_jitter() control the amount of jittering?
# width and height determine how much noise horizontally and vertically,
# respectively, is applied to the position of each point.
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter(width = 0.1, height = 0.1)
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter(width = 0.5, height = 0.5)
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter(width = 1, height = 1)
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter(width = 5, height = 5)

# 4. Compare and contrast geom_jitter() with geom_count().
# geom_jitter() applies noise to positions of each point,
# but keeps all points the same size
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter()

# geom_count() changes the size of points to show how often they occur,
# with more common points having larger sizes
# this keeps point positions accurate, but less common points
# can be hidden if neighboring points get too large
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_count()


# 5. What's the default position adjustment for geom_boxplot?
# Create a visualization of the mpg dataset that demonstrates it.
# the default position of geom_boxplot is "dodge2",
#so boxplots will be displayed side-by-side
ggplot(mpg, aes(x = drv, y = hwy, color = class)) + 
  geom_boxplot()

ggplot(mpg, aes(x = drv, y = hwy, color = class)) + 
  geom_boxplot(position = "identity", alpha = 0.5, fill = NA)
