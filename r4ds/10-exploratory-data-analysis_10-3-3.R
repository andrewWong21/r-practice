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


# 2. Explore the distribution of price. Do you discover anything unusual or
# surprising? (Try a wide range of values for binwidth.)


# 3. How many diamonds are 0.99 carat? How many are 1 carat?
# What do you think is the cause of the difference?


# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming
# in on a histogram. What happens if you leave binwidth unset? What happens if
# you try and zoom so only half a bar shows?
