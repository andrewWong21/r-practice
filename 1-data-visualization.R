# instantiate a plot using the penguins dataset from palmerpenguins,
# mapping features to the x-axis, y-axis, and data point colors 
# and specify the plot as a scatter plot
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) + 
  geom_point()
