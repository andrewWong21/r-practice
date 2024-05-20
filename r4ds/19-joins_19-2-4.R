{
  library("tidyverse")
  library("nycflights13")
}

# two types of joins - mutating joins and filtering joins
# mutating joins add variables to dataset from matching observations in another
# filtering joins filter to observations in dataset that match another

# every join involves a pair of keys - primary key and foreign key
# primary key uniquely identifies each observation in a dataset
# primary key may be made of multiple variables (compound key) or just one

# primary key of airlines is carrier
airlines

# primary key of airports is faa
airports

# primary key of planes is tailnum
planes

# weather has compound key - primary key is combination of origin and time_hour
weather

# foreign key - variable(s) that correspond to another table's primary key
# primary and foreign keys almost always have the same name,
# variable names used in multiple tables usually have the same meaning

# check primary keys by using count() and seeing if any entries have n > 1
planes |> 
  count(tailnum) |> 
  filter(n > 1)
weather |> 
  count(origin, time_hour) |> 
  filter(n > 1)

# primary keys cannot be missing - NA values cannot identify observation
planes |> 
  filter(is.na(tailnum))
weather |> 
  filter(is.na(origin) | is.na(time_hour))

# flights can be uniquely identified by three variables
flights |> 
  count(time_hour, carrier, flight) |> 
  filter(n > 1)

# absence of duplicates do not automatically guarantee a good primary key

# combination of altitude and latitude is not enough to identify an airport
airports |> 
  count(alt, lat) |> 
  filter(n > 1)

# simpler to use a numeric surrogate key with the row number for flights
# surrogate keys make data communication easier with other people
flights2 <- flights |> 
  mutate(id = row_number(), .before = 1)
flights2

# -------------------------------------------------------------------------

# 1. What is the relationship between weather and airports and
# how should it appear in the diagram?

# weather$origin is a foreign key that corresponds to
# the primary key airports$faa


# 2. weather only contains information for the three origin airports in NYC.
# If it contained weather records for all airports in the USA, what additional
# connection would it make to flights?

# weather would be able to make an additional connection to the columns
# year, month, day, hour, origin in flights to identify the weather at
# the departure times of all flights from their origin airports


# 3. The year, month, day, hour, and origin variables almost form a compound
# key for weather, but there's one hour that has duplicate observations.
# Can you figure out what's special about that hour?

# The hour is 1AM on November 3, 2013. This hour is special because clocks were
# turned one hour backward to this time due to DST ending.
weather |> 
  count(year, month, day, hour, origin) |> 
  filter(n > 1)


# 4. We know that some days of the year are special and fewer people than usual
# fly on them. How might you represent that data as a data frame? What would
# be the primary key? How would it connect to the existing data frames?

# Use primary key month and day
# connect to flights$month, flights$day, weather$month, weather$day
# columns: month, day, holiday_name


# 5. Draw a diagram illustrating the connections between the Batting, People,
# and Salaries data frames in the Lahman package. Draw another diagram that
# shows the relationship between People, Managers, and AwardsManagers.
# How would you characterize the relationship between the Batting, Pitching,
# and Fielding data frames?

library("Lahman")
head(Batting)
head(People)
head(Salaries)

# common column playerID between Batting and People, People and Salaries
colnames(Batting)[colnames(Batting) %in% colnames(People)]
colnames(People)[colnames(People) %in% colnames(Salaries)]

# common columns playerID, yearID, teamID, lgID between Batting and Salaries
colnames(Batting)[colnames(Batting) %in% colnames(Salaries)]

head(People)
head(Managers)
head(AwardsManagers)

# common column playerID between People and Managers, People and AwardsManagers
colnames(People)[colnames(People) %in% colnames(Managers)]
colnames(People)[colnames(People) %in% colnames(AwardsManagers)]

# common columns playerID, yearID, lgID between Managers and AwardsManagers
colnames(Managers)[colnames(Managers) %in% colnames(AwardsManagers)]

head(Batting)
head(Pitching)
head(Fielding)

# common columns playerID, yearID, stint, teamID, lgID
# between Batting, Pitching, and Fielding
colnames(Batting)[colnames(Batting) %in% colnames(Pitching)]
colnames(Batting)[colnames(Batting) %in% colnames(Fielding)]
colnames(Pitching)[colnames(Pitching) %in% colnames(Fielding)]

colnames(Batting)[
  colnames(Batting) %in% colnames(Pitching) &
    colnames(Batting) %in% colnames(Fielding)
]
