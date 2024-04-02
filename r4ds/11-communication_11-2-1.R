{
  library("tidyverse")
  # scales for overriding default breaks, labels,
  # transformations, and palettes for graphs
  library("scales")
  # extension packages for ggplot
  library("ggrepel")
  library("patchwork")
}

# plots should be as self-explanatory as possible to properly communicate
# findings within them and quickly build mental models, since audience may not
# share background knowledge or be as invested in the data

# turn exploratory graphic into expository graphic by adding labels with labs()
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) + 
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type", 
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = 
    "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

# plot title should summarize main findings rather than describe the plot
# subtitle adds detail in a smaller font below title
# caption is usually used to describe data source
# axis and legend titles should be replaced with more detailed descriptions
# instead of short variable names, and include units when possible



# -------------------------------------------------------------------------

# 1. Create one plot on the fuel economy with customized title, subtitle,
# caption, x, y, and color labels.
ggplot(mpg |> filter(), aes(x = factor(cyl))) + 
  geom_bar(aes(group = drv, fill = drv), position = "dodge2") + 
  labs(
    x = "Number of engine cylinders",
    y = "Count",
    fill = "Type of drive train",
    title = "4WD and FWD are more common as the number of cylinders increases"
  )

# 2. Recreate the following plot using the fuel economy data. Note that both
# the colors and shapes of points vary by drive train.
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point(aes(color = drv, shape = drv)) + 
  labs(
    x = "City MPG",
    y = "Highway MPG",
    color = "Type of drive train",
    shape = "Type of drive train"
  )

# 3. Take an exploratory graphic you've created in the last month, and add
# informative titles to make it easier to understand.
palmerpenguins::penguins |> 
  ggplot(aes(x = flipper_length_mm, y = body_mass_g, color = species)) + 
  geom_point(na.rm = TRUE) + 
  geom_smooth(na.rm = TRUE) + 
  facet_wrap(~species, scales = "free") + 
  labs(
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species",
    title = "Penguin body mass generally increases with flipper length",
    caption = "Data collected by Dr. Kristen Gorman
    and the Palmer Station Long Term Ecological Research (LTER) Program"
  )
