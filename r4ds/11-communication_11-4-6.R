{
  library(tidyverse)
  library(scales)
  library(ggrepel)
  library(patchwork)
}

# ggplot automatically adds scales
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class))

# is equivalent to 
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) +
  scale_x_continuous() + 
  scale_y_continuous() + 
  scale_color_discrete()

# scales may be continuous, discrete, datetime, or date
# default values usually do a good job, but may want to override defaults
# to tweak default scale parameters or replace the scale entirely

# axes and legends are collectively called guides
# axes for x/y aesthetics, legends for everything else
# primary arguments are breaks and labels
# breaks control tick positions, i.e. values associated with keys
# labels control text label for ticks/keys

# override default scale for y with labeled ticks every 5 mpg from 15 to 40
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 

# labels can be set to NULL to suppress labels while maintaining ticks,
# useful for maps or plots where exact numbers cannot be shared
# discrete labels categorical variables can be specified with a list of
# desired labels corresponding to the existing labels
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  scale_x_continuous(labels = NULL) + 
  scale_y_continuous(labels = NULL) + 
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))

# labelling functions can be used with labels argument to format numbers

# using label_dollar() to represent currencies
ggplot(diamonds, aes(x = price, y = cut)) + 
  geom_boxplot(alpha = 0.05) + 
  scale_x_continuous(labels = label_dollar())

ggplot(diamonds, aes(x = price, y = cut)) + 
  geom_boxplot(alpha = 0.05) + 
  scale_x_continuous(
    labels = label_dollar(scale = 0.001, suffix = "K"),
    breaks = seq(1000, 19000, by = 6000)
  )

# using label_percent() so y axis displays as "Percentage" instead of "count"
ggplot(diamonds, aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill") + 
  scale_y_continuous(name = "Percentage", labels = label_percent())

# breaks can also be used in cases of few observations where showing 
# the beginning of each observation is important
presidential |> 
  mutate(id = 33 + row_number()) |> 
  ggplot(aes(x = start, y = id)) + 
  geom_point() + 
  geom_segment(aes(xend = end, yend = id)) + 
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

# dataframe$column format is used for specifying breaks
# as it is not an aesthetic mapping

# date_labels takes a format specification similar to parse_datetime()
# date_breaks() is superseded by breaks_width()

# theme() is used for controlling non-data parts of plot
# e.g. controlling overall position of legend with theme(legend.position)
base <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class))

base + theme(legend.position = "right")
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") + 
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") + 
  guides(color = guide_legend(nrow = 3))


# guides() with guides_legend() or guides_colorbar() can be used to
# control the display of individual legends

# changing number of rows and size of points in legend for scatterplot
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth(se = FALSE) + 
  theme(legend.position = "bottom") + 
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))


# legend should be placed at the top or bottom for short and wide plots,
# and placed to the left or right for tall and narrow plots

# scales can be replaced, often continuous position and color scales

# plotting raw carat and price values
ggplot(diamonds, aes(x - carat, y = price)) + 
  geom_bin2d()

# plotting log-transformed carat and price
ggplot(diamonds, aes(x = log10(carat), y = log10(price))) + 
  geom_bin2d()

# instead of transforming aesthetic mapping, transform the scale
# this keeps the original data scale instead of the transformed value scale
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

# default color scale picks evenly-spaced colors from color wheel
# ColorBrewer scales provide more colorblind-friendly schemes
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = drv)) + 
  scale_color_brewer(palette = "Set1")

# if only a few colors are used, adding a redundant shape mapping
# keeps the plot interpretable even without color
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = drv, shape = drv)) + 
  scale_color_brewer(palette = "Set1")

# RColorBrewer package documents color scales on https://colorbrewer2.org/
# provides sequential and diverging palettes, useful for ordered categories

# use scale_color_manual() for predefined color-value mappings
# hex color codes can be assigned manually
presidential |> 
  mutate(id = 33 + row_number()) |> 
  ggplot(aes(x = start, y = id, color = party)) + 
  geom_point() + 
  geom_segment(aes(xend = end, yend = id)) + 
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

# viridis color scales are perceptible to various types of color blindness
# as well as perceptually uniform in color and B/W
# provides support for binned, continuous, and discrete palettes for scales

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) + 
  geom_hex() + 
  coord_fixed() + 
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) + 
  geom_hex() + 
  coord_fixed() + 
  scale_fill_viridis_c() + 
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) + 
  geom_hex() + 
  coord_fixed() + 
  scale_fill_viridis_b() + 
  labs(title = "Viridis, binned", x = NULL, y = NULL)

# all color scales are provided in scale_color_*() and scale_fill_*() varieties