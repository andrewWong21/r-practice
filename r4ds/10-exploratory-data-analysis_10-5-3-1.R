library("tidyverse")
library("hexbin")

smaller <- diamonds |> 
  filter(carat < 3)

# scatterplots become less useful with larger datasets due to overplotting
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_point()

# using alpha aesthetic to add transparency works for smaller datasets
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_point(alpha = 0.01)

# binning was previously done in 1D with geom_histogram() and geom_freqpoly()
# binning can be done in 2D with geom_bin2d() and hexbin::geom_hex()
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_bin2d()

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_hex()

# one continuous variable can be binned into a categorical variable
# and then visualized in the format of categorical vs. continuous
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

# cut_width(x, w) divides variable x into bins of width w
# specifying varwidth = TRUE in geom_boxplot() changes widths of box plots
# to be proportional to the number of points summarized by that box plot
ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)), varwidth = TRUE)

# systematic relationships between variables will show up as patterns in data
# questions to ask about these relationships:
# Is the pattern due to a coincidence?
# How can the relationship implied by the pattern be described?
# How strong is this relationship implied by the pattern?
# What other variables might affect the relationship?
# Does the relationship change when looking at individual data subgroups?

# patterns reveal clues to variable relationships, i.e. covariation

# treat variation as a phenomenon that creates uncertainty,
# and covariation as one that reduces it

# covariation allows predictions to be made about values of one variable
# using its relationship with the other, or controlling it with causation

# models are a tool for extracting patterns out of data, and can be used to
# remove strong relationships between variables to explore remaining subtleties
library("tidymodels")

# log transform carat and price
diamonds_log <- diamonds |> 
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

# fit model to log-transformed values predicting price from carat
diamonds_fit <- linear_reg() |> 
  fit(log_price ~ log_carat, data = diamonds_log)

# exponentiate residuals to scale back to raw prices
diamonds_aug <- augment(diamonds_fit, new_data = diamonds_log) |> 
  mutate(.resid = exp(.resid))

# relationship between carat and price:
# better quality diamonds are more expensive
ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
  geom_point()

ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()

# boxplots of raw price for comparison, with built-in effects of carat
ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_boxplot()

# models should be researched in another book

# -------------------------------------------------------------------------

# 1. Instead of summarizing the conditional distribution with a boxplot, you
# could use a frequency polygon. What do you need to consider when using
# cut_width() vs. cut_number()? How does that impact a visualization of the
# 2D distribution of carat and price?

# cut_width and cut_number() are dependent on careful selection of 
# interval range (width) or number of intervals (n), respectively

# if too many bins are specified for cut_number(), it will throw an error
# stating that there are insufficient values to produce that many bins
ggplot(smaller, aes(x = price)) + 
  geom_freqpoly(aes(color = cut_number(carat, 10)))

# specifying intervals for cut_width that are too small creates many
# frequency polygons, making it difficult to see and compare distributions
ggplot(smaller, aes(x = price)) + 
  geom_freqpoly(aes(color = cut_width(carat, 0.125)), binwidth = 1000)

# if the interval is too large, only one polygon is created
# similar to geom_density without grouping
ggplot(smaller, aes(x = price)) + 
  geom_freqpoly(aes(color = cut_width(carat, 0.25)), binwidth = 1000)


# 2. Visualize the distribution of carat, partitioned by price.
ggplot(smaller, aes(x = carat)) + 
  geom_freqpoly(aes(color = cut_width(price, 1000)))


# 3. How does the price distribution of very large diamonds compare to small
# diamonds? Is it as you expect, or does it surprise you?

# treating subset of diamonds with carat >= 2 as very large
diamonds |> 
  ggplot(aes(x = carat)) + 
  geom_density()

larger <- diamonds |> 
  filter(carat >= 2)

# larger diamonds tend to have higher prices, which is expected
ggplot(larger, aes(x = carat)) + 
  geom_freqpoly(aes(color = cut_width(price, 1000)))


# 4. Combine two of the techniques you've learned to visualize
# the combined distribution of cut, carat, and price.
# cut is categorical, carat and price are numerical and continuous

# visualize distribution of price vs. carat, faceted by cut
ggplot(diamonds, aes(x = carat)) + 
  geom_freqpoly(aes(color = cut_width(price, 1000))) +
  facet_wrap(~cut, scales = "free_y")

ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() +
  facet_wrap(~cut)

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_bin2d(binwidth = c(0.1, 500)) +
  facet_wrap(~cut)


# 5. Two dimensional plots reveal outliers that are not visible in 
# one dimensional plots. For example, some points in the following plot have
# an unusual combination of x and y values, which makes the points outliers
# even though their x and y values appear normal when viewed separately.
# Why is a scatterplot a better display than a binned plot for this case?
diamonds |> 
  filter(x >= 4) |> 
  ggplot(aes(x = x, y = y)) + 
  geom_point() + 
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

diamonds |> 
  filter(x >= 4) |> 
  ggplot(aes(x = x, y = y)) + 
  geom_bin2d() + 
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

# A scatterplot is a better display for this case because it more clearly
# shows the correlation between the two variables and does not group outliers
# into bins with non-outliers like a 2D bin heatmap does.


# 6. Instead of creating boxes with equal width with cut_width(), we could 
# create boxes that contain roughly equal number of points with cut_number().
# What are the advantages and disadvantages of this approach?

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 20)))

# The advantage of using cut_number() ensures that each boxplot handles an
# equal number of observations, but the disadvantage is that the different 
# widths of the boxplots can make it difficult to see and compare 
# quartile values between the plots in different groups

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.2)))
