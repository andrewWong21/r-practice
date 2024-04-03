{
  library("tidyverse")
  library("scales")
  library("ggrepel")
  library("patchwork")
}

# observations or groups of observations can be labeled
# geom_text() is similar to geom_point() with additional label aesthetic

# get cars with highest engine size for each drive type
# and label their drive type with an additional column in a new dataframe
label_info <- mpg |> 
  group_by(drv) |> 
  arrange(desc(displ)) |> 
  slice_head(n = 1) |> 
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |> 
  select(displ, hwy, drv, drive_type)

label_info

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point(alpha = 0.3) + 
  geom_smooth(se = FALSE) + 
  geom_text(
    data = label_info,
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) + 
  theme(legend.position = "none") # disables legend

# fontface and size are used to customize label appearances
# hjust and vjust controls the alignment of the label

# using geom_label_repel() from ggrepel package
# to fix labels overlapping points and other labels
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point(alpha = 0.3) + 
  geom_smooth(se = FALSE) + 
  geom_label_repel(
    data = label_info,
    aes(label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

# geom_text_repel() can be used to highlight points on a plot

potential_outliers <- mpg |> 
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_text_repel(data = potential_outliers, aes(label = model)) + 
  geom_point(data = potential_outliers, color = "red") + 
  geom_point( # add second layer of hollow points to further highlight labels
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

# geom_hline() and geom_vline() add reference lines
# combine them with linewidth = 2 and color = "white" and draw underneath data
# to make them easy to see without drawing attention away from primary data

# use geom_rect() to draw a line around points of interest
# boundaries are defined by the four aesthetics xmin, xmax, ymin, ymax
# ggforce package allows annotating subsets of points with hulls

# arrows can be drawn using geom_segment() with arrow argument
# aesthetics x and y define start, xend and yend define end of arrow

# annotate() adds one or few annotations to plot, while
# geoms highlight a subset of the data

# stringr::str_wrap() adds line breaks to long string given specified width
trend_text <- "Larger engine sizes tend to have lower fuel economy." |> 
  stringr::str_wrap(width = 30)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "label", x = 3.5, y = 38, 
    label = trend_text,
    hjust = "left", color = "red"
  ) + 
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )


# -------------------------------------------------------------------------

# 1. Use geom_text() with infinite positions to place text
# at the four corners of the plot.

corners <- tibble(
  cty = c(-Inf, Inf, -Inf, Inf),
  hwy = c(Inf, Inf, -Inf, -Inf),
  label = c("top left", "top right", "bottom left", "bottom right"),
  vjust = c("top", "top", "bottom", "bottom"),
  hjust = c("left", "right", "left", "right")
)

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_text(
    data = corners,
    aes(label = label, vjust = vjust, hjust = hjust)
  )


# 2. Use annotate() to add a point geom in the middle of your last plot
# without having to create a tibble. Customize the point's shape, size, color.

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "point",
    x = 30, y = 40, color = "blue", size = 3, shape = "triangle"
  )


# 3. How do labels with geom_text() interact with faceting? How can you add
# a label to a single facet? How can you put a different label in each facet?
# (Hint: think about the dataset that is being passed to geom_text()).

# labels with geom_text() are duplicated for each facet
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_text(
    label = "year label",
    x = 30, y = 40,
    color = "blue", size = 4
    ) + 
  facet_wrap(~year)

subset <- tibble(
  cty = 30,
  hwy = 40,
  year = 1999,
)

# unless faceted variable is specified within dataset used by geom_text()
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_text(
    data = subset,
    aes(label = "1999 only"),
    color = "blue", size = 4
  ) + 
  facet_wrap(~year)


# 4. What arguments to geom_label() control
# the appearance of the background box?

# fill changes the color of the box
# label.padding changes how large the surrounding box is
# label.r changes the roundness of the corners of the box

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_label(
    label = "this is a label",
    x = 20, y = 15, color = "purple", fill = "gray",
    label.padding = unit(0.5, "lines"), label.r = unit(0.75, "lines")
  )


# 5. What are the four arguments to arrow()? How do they work?
# Create a series of plots that demonstrate the most important options.

# The four arguments to arrow are angle, length, ends, and type.
# angle determines the angle of the arrow head, which affects its width
# length determines how long the arrow should be
# ends determines which end should have an arrow head, if not both
# type determines whether the arrow head should be open or closed

# angle
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "segment",
    arrow = arrow(angle = 45),
    x = 20, y = 15, xend = 30, yend = 30, color = "blue"
  )

# length
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "segment",
    arrow = arrow(length = unit(2, "cm")),
    x = 20, y = 15, xend = 30, yend = 30, color = "blue"
  )

# ends
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "segment",
    arrow = arrow(ends = "both"),
    x = 20, y = 15, xend = 30, yend = 30, color = "blue"
  )

# type
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  annotate(
    geom = "segment",
    arrow = arrow(type = "closed"),
    x = 20, y = 15, xend = 30, yend = 30, color = "blue"
  )
