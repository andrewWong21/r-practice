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

# filtering joins filters out rows of data frames
# semi_join() keeps all rows in x that have a match in y

# filtering airports to show only origin airports in flights2
airports |> 
  semi_join(flights2, join_by(faa == origin))

# filtering airports to show only destination airports in flights2
airports |> 
  semi_join(flights2, join_by(faa == dest))

# anti_join() return all rows in x that do not have a match in y
# useful for finding implicit missing values

# find rows missing from airports
flights2 |> 
  anti_join(airports, join_by(dest == faa)) |> 
  distinct(dest)

# find tailnums missing from planes
flights2 |> 
  anti_join(planes, join_by(tailnum)) |> 
  distinct(tailnum)

# -------------------------------------------------------------------------

# 1. Find the 48 hours (over the course of the whole year) that have the worst
# delays. Cross-reference it with the weather data. Can you see any patterns?

# worst delays occur between March 7-8, 2013
delayed <- flights |>
  group_by(year, month, day) |> 
  summarize(
    delay_daily = sum(dep_delay, na.rm = TRUE)
  ) |> 
  mutate(
    delay_48hrs = delay_daily + lead(delay_daily)
  ) |> 
  arrange(desc(delay_48hrs))


# 2. Imagine you've found the top 10 most popular destinations using the
# following code. How can you find all flights to those destinations?
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

top_dest |> 
  left_join(flights2, join_by(dest))


# 3. Does every departing flight have corresponding weather data for that hour?

# There are 1,556 flights with no corresponding weather data.
flights2 |> 
  anti_join(weather)

# 48 hours are missing weather data in the weather dataset.
flights2 |> 
  anti_join(weather) |> 
  distinct(time_hour)


# 4. What do the tail numbers that don't have a matching record in planes
# have in common?

# Most planes in flights with no matching tailnumbers in the planes data frame
# belong to the carriers AA (American Airlines) and MQ (Envoy Air).
flights2 |> 
  anti_join(planes, join_by(tailnum)) |> 
  count(carrier)


# 5. Add a column to planes that lists every carrier that has flown that plane.
# Confirm or reject the hypothesis that there is an implicit relationship
# between plane and airline since each plane is flown by a single airline.

# Out of 4,044 planes, only 17 are flown by more than 1 carrier.
flights2 |> 
  group_by(tailnum) |> 
  summarize(num_carriers = n_distinct(carrier)) |> 
  filter(num_carriers > 1 & !is.na(tailnum))

flight_carriers <- flights2 |> 
  group_by(tailnum) |> 
  distinct(carrier) |> 
  summarize(carriers = paste(carrier, collapse = ", "))

flights2 |> 
  left_join(flight_carriers, join_by(tailnum))
  

# 6. Add the latitude and longitude of the origin and destination airport to
# flights. Is it easier to rename the columns before or after the join?
flights2 |> 
  left_join()


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



# On June 13, 2013, two windstorms occurred over the
# Midwest and Mid-Atlantic regions of the United States.

