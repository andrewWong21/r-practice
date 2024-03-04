library("tidyverse")
library("palmerpenguins")
library("ggthemes")

# instantiate a plot using the penguins dataset from palmerpenguins,
# mapping features to the x-axis and y-axis,
# and specify the plot as a scatter plot
# with points colored and shaped based on species
# and a line of best fit drawn for the entire dataset
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) + 
  geom_point(mapping = aes(color = species, shape = species)) + 
  geom_smooth(method = "lm") + 
  labs(
    title = "Body mass vs. flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) + 
  scale_color_colorblind()

# --------------------------------------------------------------------------------

# 1. How many rows and columns does the penguins dataframe have?
tibble(penguins) # 344 (rows) x 8 (columns)


# 2. What does the bill_depth_mm variable in the penguins dataframe describe?
?penguins # a number denoting bill depth (millimeters)


# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm.
# Describe the relationship between these two variables.
ggplot(penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point()
# possible clustering but no strong correlation


# 4. What happens if you make a scatterplot of species vs bill_depth_mm?
# What might be a better choice of geom?
ggplot(penguins, mapping = aes(species, bill_depth_mm)) +
  geom_point()
# species is categorical, while bill_depth_mm is numerical,
# so a box-and-whisker plot would be a better choice
ggplot(penguins, mapping = aes(species, bill_depth_mm)) +
  geom_boxplot()


# 5. Why does the following give an error and how would you fix it?
# ggplot(data = penguins) + geom_point()
# Aesthetics for the x and y axes are required to set up the scatterplot with geom_point().
# Specifying the variables for x and y within ggplot() will fix the issue.


# 6. What does the na.rm argument do in geom_point()? What is the default value of the argument?
# Create a scatterplot where you successfully use this argument set to TRUE.
# na.rm indicates whether missing values are removed silently or with a warning.
# The default value of the argument is FALSE, i.e., a warning message is shown when missing values are removed.
ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) + geom_point(na.rm = TRUE)


# 7. Add the following caption to the plot you made in the previous exercise: 
# "Data come from the palmerpenguins package."
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) + 
  geom_point(mapping = aes(color = species, shape = species)) + 
  geom_smooth(method = "lm") + 
  labs(
    title = "Body mass vs. flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    caption = "Data come from the palmerpenguins package.",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) + 
  scale_color_colorblind()


# 8. Recreate the visualization. What aesthetic should bill_depth_mm be mapped to?
# And should it be mapped at the global level or the geom level?
ggplot(
  penguins, aes(flipper_length_mm, body_mass_g)
) + 
  geom_point(aes(color = bill_depth_mm)) + 
  geom_smooth()
# The bill depth aesthetic should be mapped at the geom level,
# since the color mapping is only applied to the point geom and not the smooth geom.


# 9. Predict the output of the following code.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

# Scatterplot depicting body mass vs. flipper length
# point and smooth geoms are colored by island due to global color mapping
# smooth conditional mean lines are displayed without confidence intervals


# 10. Will these two graphs look different? Why/why not?
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )
# The two graphs will not look different since the geoms in both graphs use the same data and aesthetics.
# The first graph applies them globally, while the second graph applies them locally, but the output is the same.
