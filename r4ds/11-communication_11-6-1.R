{
  library("tidyverse")
  library("scales")
  library("ggrepel")
  library("patchwork")
}

p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")

# patchwork package allows combining multiple plots into one graphic
# by adding functionality to + operator
p1 + p2

p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
# | places plots next to each other, / moves following plot to next line
(p1 | p3) / p2

# patchwork allows collecting legends from multiple plots into one legend,
# customizing legend placement, plot dimensions, and common titles + captions
plot1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

plot2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

plot3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

plot4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

plot5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) + 
  labs(title = "Plot 5")

# guide_area() is space allocated for plot legends
(guide_area() / (plot1 + plot2) / (plot3 + plot4) / plot5) + 
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov"
  ) + 
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4) # customize heights of plots in each row
  ) &
  theme(legend.position = "top") # collect legends at top of plot
# & is used to modify patchwork plot instead of individual plots
# see https://patchwork.data-imaginist.com for more on patchwork package

# read Fundamentals of Data Visualization at https://clauswilke.com/dataviz/
# for a comprehensive understanding of what makes plots good, bad, or ugly

# -------------------------------------------------------------------------

# 1. What happens if you omit the parentheses in the following plot layout?
# Can you explain why this happens?
(p1 | p2) / p3

# Omitting the parentheses results in p1 spanning two rows,
# while p2 and p3 are stacked on top of each other.
p1 | p2 / p3

# This occurs because / is evaluated before |, so the above layout
# is equivalent to the following layout with parentheses added
p1 | (p2 / p3)


# 2. Using the three plots from the previous exercise,
# recreate the following patchwork.
p1 <- p1 + labs(tag = "Fig. A:")
p2 <- p2 + labs(tag = "Fig. B:")
p3 <- p3 + labs(tag = "Fig. C:")
(p1) / (p2 + p3)
