library("tidyverse")
library("palmerpenguins")

nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", color = "black")

# coord_quickmap() sets aspect ratio correctly
ggplot(nz, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", color = "black") + 
  coord_quickmap()

# map_data includes county, france, italy, nz, state, usa, world, world2
ggplot(map_data("state"), aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "green", color = "black") + 
  coord_quickmap()

# polar coordinates can be used instead of Cartesian coordinates
ggplot(map_data("state"), aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "green", color = "black") + 
  coord_polar()

bar <- ggplot(diamonds) + 
  geom_bar(
    aes(x = clarity, fill = clarity),
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

# vertical bars
bar
# horizontal bars
bar + coord_flip()
# radial bars
bar + coord_polar()

# seven parameters for grammar of graphics, not all need to be specified
# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>,
#     position = <POSITION>
#   ) + 
#   <COORDINATE_FUNCTION> + 
#   <FACET_FUNCTION>


# -------------------------------------------------------------------------

# 1. Turn a stacked bar chart into a pie chart using coord_polar.
bar_penguins <- ggplot(penguins) + 
  geom_bar(
    aes(x = "", fill = species)
  )

bar_penguins
bar_penguins + coord_polar(theta = "y")


# 2. What's the difference between coord_quickmap() and coord_map()?

ggplot(nz, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", color = "black") + 
  coord_quickmap()
ggplot(nz, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", color = "black") + 
  coord_map()

ggplot(nz, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill = "white", color = "black") + 
  coord_map()
# coord_map() projects a portion of earth onto a 2D plane
# using a given projection method, e.g. mercator, rectangular

# coord_quickmap() is an approximation of coord_map() that preserves
# straight lines, which works better for areas closer to the equator


# 3. What does the following plot tell you about
# the relationship between city and highway mpg?
# Why is coord_fixed() important?  What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_abline() + 
  coord_fixed()

# geom_abline() creates a diagonal reference line
# with a default slope of 1 and a default intercept of 0

# coord_fixed changes the aspect ratio to be 1:1 by default, making
# distance between each unit the same for both x and y axes
