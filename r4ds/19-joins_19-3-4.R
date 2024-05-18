{
  library("tidyverse")
  library("nycflights13")
}

# dplyr provides six join functions that operate on a pair of data frames:
# left_join(), inner_join(), right_join(), full_join(), semi_join(), anti_join()
# output is primarily dependent on the left data frame x

# mutating join allows combining variables from two data frames
# match observations by keys and copy across variables
# additional variables are added to the right

# using narrower dataset to see additional variables added with left_join()
flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)

# left_join() almost always has the same rows as x
# used to append additional metadata

# add full airport name to flights2
flights2 |> 
  left_join(airlines)

# view temperature and wind speed at departure
flights2 |> 
  left_join(weather |> select(origin, time_hour, wind_speed, temp))

# view size of plane
flights2 |> 
  left_join(planes |> select(tailnum, type, engines, seats))

# left_join() will fill new variables with NA for rows in x with no match
flights2 |> 
  filter(tailnum == "N3ALAA") |> 
  left_join(planes |> select(tailnum, type, engines, seats))

# left_join() uses all common variables in x and y as the join key by default
# known as a natural join between data frames x and y
# sometimes causes issues when variables with the same name
# mean different things in each data frame
# e.g. year of flight in flights vs. year manufactured in planes
flights2 |> 
  left_join(planes)

# specify which columns to join on with join_by()
# common variables will be distinguished with .x and .y
# disambiguation suffix can be overridden with suffix argument
flights2 |> 
  left_join(planes, join_by(tailnum))

# join_by(tailnum) is shorthand for join_by(tailnum == tailnum)
# equi join: keys must be equal in both columns

# join_by() also allows specifying different join keys in each table
# can join flights2 and airports by dest or origin
flights2 |> 
  left_join(airports, join_by(dest == faa))
flights2 |> 
  left_join(airports, join_by(origin == faa))

# join_by() is a clearer and more flexible specification
# compared to older code usage of character vectors, 
# e.g. by = "x" (join_by(x)), by = c("a" = "x") (join_by(a == x))

# left_join() keeps rows in x, right_join() keeps rows in y,
# full_join() keeps all rows in either x or y,
# inner_join() only keeps rows that occur in both x and y

# -------------------------------------------------------------------------

# 1. Find the 48 hours (over the course of the whole year) that have the worst
# delays. Cross-reference it with the weather data. Can you see any patterns?

# 2. Imagine you've found the top 10 most popular destinations using the
# following code. How can you find all flights to those destinations?
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

# 3. Does every departing flight have corresponding weather data for that hour?

# 4. What do the tail numbers that don't have a matching record in planes
# have in common?

# 5. Add a column to planes that lists every carries that has flown that plane.
# Confirm or reject the hypothesis that there is an implicit relationship
# between plane and airline since each plane is flown by a single airline.

# 6. Add the latitude and longitude of the origin and destination airport to
# flights. Is it easier to rename the columns before or after the join?

# 7. Compute the average delay by destination, then join on the airports data
# frame to show the spatial distribution of delays.
airports |>
  semi_join(flights, join_by(faa == dest)) |>
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 8. What happened on June 13, 2013? Draw a map of the delays, and then
# use Google to cross-reference with the weather.