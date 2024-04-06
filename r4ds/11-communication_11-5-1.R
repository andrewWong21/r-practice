{
  library(tidyverse)
  library(scales)
  library(ggrepel)
  library(patchwork)
  library(ggthemes)
}

# customize non-data parts of plot with theme
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) + 
  theme_bw()

# theme_gray() is default theme for plots

# individual components can be controlled
# change direction of legend and add border
# element_*() functions specify styling of non-data components
# title and caption are aligned to full plot area instead of plot panel
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  labs(
    title = "Larger engine sizes tend to have lower fuel economy",
    caption = "Source: https://fueleconomy.gov"
  ) + 
  theme(
    legend.position = "inside",
    legend.position.inside = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )

# -------------------------------------------------------------------------

# 1. Pick a theme offered by the ggthemes package
# and apply it to the last plot you made.

ggplot(diamonds, aes(x = cut)) + 
  geom_bar(aes(fill = color, group = color), position = "fill") + 
  theme_excel()
  # theme_gdocs()
  # theme_fivethirtyeight()


# 2. Make the axis labels of your plot blue and bolded.

ggplot(diamonds, aes(x = cut)) + 
  geom_bar(aes(fill = color, group = color), position = "fill") + 
  theme(
    axis.text.x = element_text(color = "blue", face = "bold"),
    axis.text.y = element_text(color = "blue", face = "bold")
  )
