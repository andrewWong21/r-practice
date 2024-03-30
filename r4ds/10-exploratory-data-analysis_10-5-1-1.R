library("tidyverse")

# covariation describes relationship between two or more variables

# plot showing how diamond price varies with quality
ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)
# ordered color scale is used due to cut being defined as ordered factor in data

# height is marked by count, which differs too much between cuts
# replacing count with density makes comparison between cuts easier
ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

# fair (lowest quality) diamonds appear to have the highest average price
diamonds |> 
  group_by(cut) |> 
  summarize(
    mean_price = mean(price, na.rm = TRUE),
    median_price = median(price, na.rm = TRUE)
  )

# boxplots are a more compact and less informative version of
# viewing the price distribution of diamonds
ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_boxplot()

# fct_reorder() is useful for (re)organizing categorical variables
ggplot(mpg, aes(x = class, y = hwy)) + 
  geom_boxplot()

# fct_reorder(factor, value, summary function)
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) + 
  geom_boxplot()

ggplot(diamonds, aes(x = fct_reorder(cut, price, median), y = price)) + 
  geom_boxplot()

# long variable numbers work better on the y-axis
ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) + 
  geom_boxplot()


# -------------------------------------------------------------------------

# 1. Use what you've learned to improve the visualization of departure times
# of cancelled vs. non-cancelled flights.
flights_status <- nycflights13::flights |>
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  )
ggplot(flights_status, aes(x = sched_dep_time, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 0.25)

ggplot(flights_status, aes(x = sched_dep_time, y = cancelled)) + 
  geom_boxplot()


# 2. Based on EDA, what variable in the diamonds dataset appears to be most
# important for predicting the price of a diamond? How is that variable
# correlated with cut? Why does the combination of those two relationships lead
# to lower quality diamonds being more expensive?

# correlation matrix for numerical columns of diamonds shows that
# price is most positively correlated with carat (covariance of 0.921)
cor(diamonds |> select(where(is.numeric)))

# boxplot of carat vs. cut shows that the lowest quality diamonds have the
# highest carat values, which is positively correlated with price
# thus, lowest quality diamonds have the highest average price
ggplot(diamonds, 
       aes(
         x = fct_reorder(cut, carat, median, .desc = TRUE),
         y = carat)
       ) + 
  geom_boxplot()


# 3. Instead of exchanging the x and y variables, add coord_flip() as a new
# layer to the vertical boxplot to create a horizontal one.
# How does this compare to exchanging the variables?
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) + 
  geom_boxplot()

# exchanging x and y variables
ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) + 
  geom_boxplot()

# using coord_flip()
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) + 
  geom_boxplot() + 
  coord_flip()

# coord_flip is faster to use and less error-prone
# compared to manually reordering variables


# 4. One problem with boxplots is that they were developed in an era of much
# smaller datasets and tend to display a prohibitively large number of
# "outlying values". One approach to fix this problem is the letter value plot.
# Install the lvplot package, and try using geom_lv() to display the 
# contribution of price vs. cut. What do you learn?
# How do you interpret the plots?
library("lvplot")

ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_boxplot()

# geom_lv() shows that most diamonds of each cut are priced at $5000 or below
# and that each of the price distributions are right-skewed
ggplot(diamonds, aes(x = cut, y = price)) + 
  lvplot::geom_lv()

ggplot(diamonds, aes(x = fct_reorder(cut, price, median), y = price)) + 
  lvplot::geom_lv()


# 5. Create a visualization of diamond prices vs. a categorical variable from
# the diamonds dataset using geom_violin(). then a faceted geom_histogram(),
# then a colored geom_freqpoly(), and then a colored geom_density().
# Compare and contrast the four plots. What are the pros and cons of each
# method of visualizing the distribution of a numerical variable based on the
# levels of a categorical variable?

# prices vs. clarity using geom_violin()
# provides overall distribution and easy comparison between categories
# but less commonly known and cannot display a large number of categories
ggplot(diamonds, aes(x = clarity, y = price)) + 
  geom_violin()

# prices vs. clarity using faceted geom_histogram()
# shows overall shape of distribution
# but comparison is not as easy due to rarer categories and different scales
ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 100) + 
  facet_wrap(~clarity, scales = "free_y")

# prices vs. clarity using colored geom_freqpoly()
# makes comparison easy with color
# but can be hard to compare with a high number of categories
ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = clarity), linewidth = 0.75)
ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = clarity), linewidth = 0.75)

# prices vs. clarity using colored geom_density()
# normalizes occurrences of categories for easy comparison
# but specific data points in each distribution are hard to see
ggplot(diamonds, aes(x = price, color = clarity)) + 
  geom_density(linewidth = 0.75)


# 6. If you have a small dataset, it's sometimes useful to use geom_jitter() to
# avoid overplotting to more easily see the relationship between a continuous
# and categorical variable. The ggbeeswarm package provides a number of methods
# similar to geom_jitter(). List them and briefly describe what each one does.

# ggbeeswarm provides the following functions:
# geom_beeswarm() and geom_quasirandom() offsets points within categories
# to prevent overplotting, using the "swarm" and "quasirandom" methods
# position_beeswarm() and position_quasirandom() can be used for the position
# arguments of other geom methods
lsf.str("package:ggbeeswarm")

diamonds_mini <- diamonds |> 
  filter(price <= 2500 & carat <= 0.5)

ggplot(diamonds_mini, aes(x = carat, y = price)) + 
  geom_point()

ggplot(diamonds_mini, aes(x = carat, y = price)) + 
  geom_point(position = position_quasirandom())

ggplot(diamonds_mini, aes(x = carat, y = price)) + 
  geom_jitter()

ggplot(diamonds_mini, aes(x = carat, y = price)) + 
  geom_quasirandom()

ggplot(diamonds_mini, aes(x = cut, y = price)) + 
  geom_beeswarm()
