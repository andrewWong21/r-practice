library("tidyverse")
library("palmerpenguins")

ggplot(penguins, aes(x = species)) + 
  geom_bar()

# reorder bars by transforming categorical variable into factor
ggplot(penguins, aes(x = fct_infreq(species))) + 
  geom_bar()

# histogram for visualizing distributions of continuous numerical variables
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)
  # geom_histogram(binwidth = 2000)
  # geom_histogram(binwidth = 20)

# density plot for smoothed density estimate of histogram
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# --------------------------------------------------------------------------------

# 1. Make a bar plot of species of penguins, where you assign species to the y aesthetic.
# How is this bar plot different?
ggplot(penguins, aes(y = species)) + 
  geom_bar()
# This bar plot has horizontal bars, with the species listed on the y-axis.


# 2. How are the following two plots different? Which aesthetic, color or fill,
# is more useful for changing the color of bars?
ggplot(penguins, aes(x = species)) + 
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
# fill is more useful for changing bar colors, as changing color only affects bar outlines


# 3. What does the bins argument of geom_histogram do?
?geom_histogram
# Determines how many bins to split the observations of the dataset into.


# 4. Make a histogram of the carat variable in the diamonds dataset when you load the tidyverse package.
# Experiment with different binwidths. What binwidth reveals the most interesting patterns?
ggplot(data = diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.2)
ggplot(data = diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.02)
# binwidth = 0.2 provides a good balance for seeing the overall distribution of the data 
# binwidth = 0.02 shows an interesting pattern in the distribution 