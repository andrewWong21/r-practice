library("tidyverse")

# exploratory data analysis (EDA) is an iterative cycle
# generate questions, search for answers by visualizing, transforming, and 
# modeling data, use what was learned to refine questions or generate new ones

# start by investigating any ideas, seeing if they lead to anything
# investigate quality of data for answering questions

# goal of EDA is to develop an understanding of data
# to generate quality questions, generate a large quantity of questions first
# follow up each question with a new question based on findings

# two types of questions are most useful for making discoveries within data
# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?

# variation - tendency of values to change from measurement to measurement
# to best understand pattern, visualize distribution of values

ggplot(diamonds, aes(x = carat)) + 
  geom_histogram(binwidth = 0.5)

# good follow-up questions involve curiosity and skepticism

# look for the unexpected - common/uncommon values, distribution patterns

smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)
# follow-up questions come from the following observations:
# more diamonds at whole carats and common fractions of carats (why?)
# more diamonds slightly to the right of each peak than to the left

# visualization can also reveal clusters or subgroupings in data
# try asking questions about similarities within subgroups,
# differences between subgroups, how to explain or describe clusters,
# and whether appearance of clusters may be misleading

# outliers in data may be data entry errors or happenstance occurrences,
# or they may be the clue to important discoveries
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)

# outliers may be difficult to see in large datasets
# coord_cartesian() allows zooming in on axes with xlim() and ylim()
ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) + 
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |> 
  arrange(y)

# 7 observations with values of 0 for x, y, and z
# these cannot be correct, so they must be missing values
# 2 observations of widths over 30 mm, possibly misplaced decimal point
unusual

# outliers with minimal effect on the data can be omitted in reports
# if they have a notable effect, explanations for removal should be provided


# -------------------------------------------------------------------------

# 1. Explore the distribution of each of the x, y, and z variables in diamonds.
# What do you learn? Think about a diamond and how you might decide which
# dimension is the length, width, and depth.
ggplot(diamonds, aes(x = x)) + 
  geom_histogram()

ggplot(diamonds, aes(x = x)) + 
  geom_histogram(binwidth = 0.01)

ggplot(diamonds, aes(x = x)) + 
  geom_histogram(binwidth = 0.01) + 
  coord_cartesian(ylim = c(0, 50))

diamonds |> count(x, sort = TRUE)
# The most common length is around 4.37 mm, but there are
# about 5 common values for length.

ggplot(diamonds, aes(x = y)) + 
  geom_histogram()

ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.05)

ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.01) + 
  coord_cartesian(ylim = c(0, 50))

diamonds |> count(y, sort = TRUE)
# The most common width is close to the most common length at around 4.34 mm.

ggplot(diamonds, aes(x = z)) + 
  geom_histogram()

ggplot(diamonds, aes(x = z)) + 
  geom_histogram(binwidth = 0.05)

ggplot(diamonds, aes(x = z)) + 
  geom_histogram(binwidth = 0.05) + 
  coord_cartesian(ylim = c(0, 50))

diamonds |> count(z, sort = TRUE)
# The most common depth is about 2.7 mm.
# The shape of the distribution for depth is very similar to that of width.


# 2. Explore the distribution of price. Do you discover anything unusual or
# surprising? (Try a wide range of values for binwidth.)
ggplot(diamonds, aes(x = price)) + 
  geom_histogram()
# The price distribution is heavily right skewed,
# with most prices less than $5000.

ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 50)
# Using a smaller binwidth reveals a gap in the data.

ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 10) + 
  coord_cartesian(xlim = c(0, 2500), ylim = c(0, 500))
#There appear to be no diamonds with prices around $1500.

diamonds|> filter(price >= 1450 & price <= 1550) |> count(price)
# There are no diamonds with prices from $1455 to $1545.


# 3. How many diamonds are 0.99 carat? How many are 1 carat?
# What do you think is the cause of the difference?

diamonds|> filter(carat >= 0.99 & carat <= 1) |> count(carat)
# There are 23 diamonds that are 0.99 carat and 1558 diamonds that are 1 carat.
# Doing some research reveals that diamonds are priced per carat,
# so diamonds that are at least 1 carat will be more expensive.


# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming
# in on a histogram. What happens if you leave binwidth unset? What happens if
# you try and zoom so only half a bar shows?
ggplot(diamonds, aes(x = price)) + 
  geom_histogram()

ggplot(diamonds, aes(x = price)) + 
  geom_histogram() + 
  coord_cartesian(xlim = c(0, 1000), ylim = c(0, 5000))

ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 100)

ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = 100) + 
  coord_cartesian(xlim = c(0, 1000), ylim = c(0, 2000))
# using coord_cartesian zooms in on the graph without affecting
# or removing the data that is outside given limits for axes
# histogram binning is applied before changing the plot scale

ggplot(diamonds, aes(x = price)) + 
  geom_histogram() + 
  xlim(0, 1000)
ggplot(diamonds, aes(x = price)) + 
  geom_histogram() + 
  ylim(0, 5000)
# using xlim or ylim removes all data outside the given limits
# histogram binning is then applied to this filtered data
