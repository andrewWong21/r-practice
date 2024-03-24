library("tidyverse")

# bar charts, histograms, and frequency polygons plot counts of data
# after separating them into bins, counts are not pre-existing data variables
ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

# smoothers fit model to data and plot predictions
ggplot(diamonds) +
  geom_smooth(aes(x = carat, y = price))

# box plots calculate five-number summary (min, median, max, quartiles)
ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_boxplot()

# these graphs use algorithms called stats (statistical transformations)
# to calculate these new values, identified by default value of stat argument

# every geom has a default stat, every stat has a default geom
# graphs that do not calculate new values use stat = "identity" by default


# three possible reasons for overriding stat argument: override default
diamonds |> 
  count(cut) |> 
  ggplot(aes(x = cut, y = n)) + 
  geom_bar(stat = "identity")
# computed variables section in help list the other variables the geom can use

# override mapping from transformed variables to aesthetics
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()

# bring attention to statistical transformation, e.g. plot stat summary
ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# -------------------------------------------------------------------------

# 1. What is the default geom associated with stat_summary()? How could you 
# rewrite the previous plot to use that geom function instead of stat?
# The default geom associated with stat_summary() is geom_pointrange().
ggplot(diamonds) + 
  geom_pointrange(
    aes(x = cut, y = depth),
    stat = "summary",
    fun.min = min,
    fun.max = max,
    fun = median
  )


# 2. What does geom_col() do? How is it different from geom_bar()?
# geom_bar() only allows specification of one of x or y aesthetic
# geom_col() requires specifying both x and y aesthetics
# as geom_col() bar heights are mapped to variables instead of counts
ggplot(diamonds) + 
  geom_bar(aes(x = carat))
ggplot(diamonds) + 
  geom_col(aes(x = x, y = y))

# 3. Most geoms and stats come in pairs that are almost always used in concert.
# Make a list of all the pairs. What do they have in common?
# stat_align: geom_ribbon and geom_area
# stat_bin:	geom_histogram, geom_freqpoly
# stat_bin2d:	geom_bin2d
# stat_binhex:	geom_binhex
# stat_bin_2d:	geom_bin_2d
# stat_bin_hex:	geom_hex
# stat_boxplot:	geom_boxplot
# stat_contour:	geom_contour
# stat_contour_filled: geom_contour_filled
# stat_count: geom_bar, geom_col
# stat_density: geom_density
# stat_density2d: geom_density_2d
# stat_density2d_filled:	geom_density_2d_filled
# stat_density_2d: geom_density_2d
# stat_density_2d_filled:	geom_density_2d_filled
# stat_function: geom_function
# stat_qq: geom_qq
# stat_qq_line: geom_qq_line
# stat_quantile: geom_quantile
# stat_sf: geom_sf
# stat_smooth: geom_smooth
# stat_spoke: geom_spoke
# stat_sum: geom_count
# stat_ydensity: geom_violin

# Most stat-geom pairs have the same suffixes.


# 4. What variables does stat_smooth() compute?
# What arguments control its behavior?
# stat_smooth computes the predicted value of y or x,
# the upper and lower pointwise confidence intervals around the means,
# and the standard error of the model.
# the orientation argument determines which of x or y is predicted
# the method and formula arguments determine how the smoothing is calculated


# 5. In our proportion bar chart, we needed to set group = 1. Why?
# In other words, what is the problem with these two graphs?
ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
  geom_bar()

# The previous two graphs treat each cut as its own separate group,
# instead of considering their % contribution to the total number of rows.
ggplot(diamonds) +
  geom_bar(aes(x = cut, y = after_stat(prop), group = 1))
# This fixed second plot properly shows the groupwise proportion of each cut,
# as well as the proportion of color occurrences for each cut.
ggplot(diamonds, 
       aes(
         x = cut, 
         y = after_stat(count)/sum(after_stat(count)),
         fill = color)
       ) + 
  geom_bar()

