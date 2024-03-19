library("tidyverse")
library("palmerpenguins")

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()
ggsave(filename = "./penguin-plot_720p.png", width = 1280, height = 720, units = "px")

# + cannot be at the start of a line
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# --------------------------------------------------------------------------------

# 1. Run the following lines of code. Which one is saved as mpg-plot.png? Why?
ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")
# The hwy vs. cty plot is saved as mpg-plot.png because it is the last plot to be drawn.


# 2. What do you need to change in the code above to save the plot as a PDF instead of a PNG?
# How could you find out what types of image files would work in ggsave()?
?ggsave
# ggsave() supports specifying device = "eps", "ps", "tex", "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf"
# by default, ggsave() guesses based on the extension in the filename argument.