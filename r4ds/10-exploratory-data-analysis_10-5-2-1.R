library("tidyverse")

# size of circles in geom_count() indicates
# how common the occurrence of a combination of values is
ggplot(diamonds, aes(x = cut, y = color)) + 
  geom_count()

# counts of variable value combinations can also be computed with dplyr
# and visualized with geom_tile and fill aesthetic
diamonds |> 
  count(color, cut) |> 
  ggplot(aes(x = color, y = cut)) + 
  geom_tile(aes(fill = n))

# use seriation package to reorder rows and columns for revealing patterns
# heatmaply package provides interactive plots for larger datasets

# -------------------------------------------------------------------------

# 1. How could you rescale the count dataset above to more clearly show the 
# distribution of cut within color, or color within cut?

# create a proportion column showing distribution of variable within another

# grouping by color and showing proportional distribution of cut within color
diamonds |> 
  count(color, cut) |> 
  group_by(color) |> 
  mutate(prop = n / sum(n)) |> 
  ggplot(aes(x = color, y = cut)) + 
  geom_tile(aes(fill = prop))

# grouping by cut and showing proportional distribution of color within cut
diamonds |> 
  count(color, cut) |> 
  group_by(cut) |> 
  mutate(prop = n / sum(n)) |> 
  ggplot(aes(x = color, y = cut)) + 
  geom_tile(aes(fill = prop)) + 
  coord_flip() # view plot as vertical slices


# 2. What different data insights do you get with a segmented bar chart if  
# color is mapped to the x aesthetic and cut is mapped to the fill aesthetic?
# Calculate the counts that fall into each of the segments.
# segmented bar chart shows % proportions of each cut within each color

# easier to see exact percentages compared to using geom_tile()
diamonds |> 
  ggplot(aes(x = color, fill = cut)) +
  geom_bar(position = "fill")

# counts of each color-cut combination
diamonds |> 
  summarize(count = n(), .by = c(color, cut))


# 3. Use geom_tile() together with dplyr to explore how
# average flight departure delays vary by destination and month of year.
# What makes the plot difficult to read? How could you improve it?
nycflights13::flights |> 
  select(month, dep_delay, dest) |> 
  group_by(month, dest) |> 
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) |> 
  ggplot(aes(x = factor(month), y = dest)) +
  geom_tile(aes(fill = avg_delay))

# high number of destinations makes it difficult to see distributions
# missing values - some destinations have no flights on certain months

# considering only destination airports with flights all year round
year_round_flights <- nycflights13::flights |> 
  select(month, dep_delay, dest) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    .by = c(month, dest)
  ) |> 
  filter(
    n() == 12, 
    .by = dest
  )

year_round_flights |> 
  ggplot(aes(x = factor(month), y = dest)) +
  geom_tile(aes(fill = avg_delay))

# 84 destination airports is difficult to fit on one graph without cluttering
year_round_flights |> 
  distinct(dest)
