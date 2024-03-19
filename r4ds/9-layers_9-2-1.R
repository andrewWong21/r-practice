library("tidyverse")

# plots showing relationship between engine size (displacement), highway fuel efficiency, and type of car
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()
# ggplot represents first 6 values with shapes by default, leaving other values unplotted
# provides warning with number of rows with unplotted characteristics

# size and alpha are not recommended for discrete variables like class
# since they are better suited for representing ranked values
ggplot(mpg, aes(x = displ, y = hwy, size = class)) + 
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

# visual properties of geom can be specified outside of aes(), i.e. independent of variables
# color, size of points, and shape can be specified (25 shapes with different color/fill interactions)
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

# -------------------------------------------------------------------------

# 1. Create a scatterplot of hwy vs displ where the points are filled in pink triangles.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "pink", shape = 17)
# shape 17 is solid triangle filled with color
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(fill = "pink", shape = 24)
# shape 24 is filled triangle with color border


# 2. Why did the following code not result in a plot with blue points?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))
# color is specified within aes(), so it is mapped to the variable "blue"
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy), color = "blue")


# 3. What does the stroke aesthetic do? What shapes does it work with?
?geom_point
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class), shape = 4, stroke = 2)
# stroke changes the border thickness, works for all shapes
# but best used with hollow shapes 0-14 or filled shapes 21-24 when fill argument is specified


# 4. What happens if you map an aesthetic to something other than a variable name,
# like aes(color = displ < 5)? Note, you'll also need to specify x and y.
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = displ < 5))
# aesthetics like color and shape can be mapped to booleans
# mapping x or y to a boolean reduces that axis to True and False
