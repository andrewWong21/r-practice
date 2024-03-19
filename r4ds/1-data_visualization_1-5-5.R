library("tidyverse")
library("palmerpenguins")

# box plot for comparing one numerical and one categorical variable
ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot()

# specifying linewidth of density plot to increase visibility
ggplot(penguins, aes(x = body_mass_g, color = species)) + 
  geom_density(linewidth = 0.75)

# specifying fill aesthetic and increasing transparency of curves via alpha argument
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + 
  geom_density(alpha = 0.5)
# aesthetics are mapped to variables or set to specified values

# stacked bar charts for visualizing the relationship between two categorical variables
# showing frequencies of species on each island
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar()

# relative frequency plot for comparing species distributions across islands
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar(position = "fill")

# scatterplots for visualizing relationship between two numerical variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()

# when comparing three or more variables, map them to additional aesthetics like color or shape
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island))

# plots with categorical variables can be split into facets to avoid clutter
# pass categorical argument to facet_wrap()
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island)) + 
  facet_wrap(~island)


# --------------------------------------------------------------------------------

# 1. The mpg data frame that is bundled with the ggplot2 package contains 234 observations
# collected by the US Environmental Protection Agency on 38 car models.
# Which variables in mpg are categorical? Which variables are numerical?
# How can you see this information when you run mpg?
mpg
# Categorical: manufacturer, model, trans, drv, fl, class
# Numerical: displ, cyl, cty, hwy
# The class of the column, denoted in brackets, indicates whether a variable is categorical or numerical.


# 2. Make a scatterplot of hwy vs. displ using the mpg data frame.
# Next, map a third, numerical variable to color, then size, then color and size, then shape.
# How do these aesthetics behave differently for categorical vs numerical variables?
ggplot(mpg, aes(x = displ, y = hwy, shape = model)) +
  geom_point()
# continuous variables cannot be mapped to the shape aesthetic unless using scale_shape_binned()
# size is not recommended for use with discrete variables
# color maps continuous variables on a spectrum, while categorical variables get distinct colors in the legend
# shape can automatically handle up to 6 discrete variables unless manual shapes are specified for more


# 3. In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?
ggplot(mpg, aes(x = displ, y = hwy, linewidth = cty)) + 
  geom_point()
# If linewidth is mapped to a variable within geom_point, a warning is issued
# as geom_point does not use the linewidth aesthetic.
# Mapping linewidth globally does not issue a warning but has no visible effect on the scatterplot.


# 4. What happens if you map the same variable to multiple aesthetics?
ggplot(mpg, aes(x = displ, y = hwy, color = hwy, size = hwy)) + 
  geom_point()
# Mapping the same variable to multiple aesthetics increases visual noise and adds redundant information.
# Variables should be mapped to at most one aesthetic to keep plots concise.


# 5. Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species.
# What does adding coloring by species reveal about the relationship between these two variables?
# What about faceting by species?
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point()
# Coloring by species shows a noticeable positive correlation between the two variables, common across all species.
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  facet_wrap(~species)
# Faceting by species allows the correlation to be seen even when the color aesthetic is removed.


# 6. Why does the following yield two separate legends? How would you fix it to combine the two legends?
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm,
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species")
# Specifying the 
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm,
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species", shape = "Species")
# Specifying the legend label for shape within labs()
# combines the two legends showing both color and shape in a single legend.


# 7. Create the two following stacked bar plots.
# Which question can you answer with the first one?
# Which question can you answer with the second one?
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) + 
  geom_bar(position = "fill")
# The first plot answers the question, "What is the percentage distribution of different penguin species on each island?"
# The second plot answers the question, "What percentage of a penguin species population can be found on each island?"
