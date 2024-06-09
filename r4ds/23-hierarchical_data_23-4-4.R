{
  library("tidyverse")
  library("repurrrsive")
  library("jsonlite")
}

# real data typically contains multiple levels of nesting
# requiring multiple calls to unnest_longer() and unnest_wider()

# gh_repos is a list of 6 lists containing sublists of length 68
# five of the six lists contain 30 sublists, one contains 26 sublists
# the sublists of length 68 have elements of various types
View(gh_repos)

# gh_repos is a deeply nested list containing data about
# collection of GitHub repositories retrieved from GitHub API

# putting gh_repos into a tibble
repos <- tibble(json = gh_repos)

# tibble contains 6 rows, each containing an unnamed list of 26 or 30 rows
repos

# use unnest_longer() with unnamed columns to separate them into rows
repos |> 
  unnest_longer(json)

# elements of json column are now named lists
# use unnest_wider() to put each element in its own column
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json)

# view names of first 10 columns of resulting tibble
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  names() |> 
  head(10)

# select some of the first 10 columns to view their contents
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description)

# with this, the structure of gh_repos can be identified
# as a list of 6 GitHub users containing sublists of 
# up to 30 GitHub repositories created by them

# view values of list-column owner
# need to specify names_sep since the list-column contains an id column
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner, names_sep = "_")

# nested data is sometimes used to represent data which
# would normally be spread across multiple data frames
chars <- tibble(json = got_chars)
chars

# since json column contains named elements, use unnest_wider()
# and select some columns for better readability
characters <- chars |> 
  unnest_wider(json) |> 
  select(id, name, gender, culture, born, died, alive)
characters

# list-columns are also present in this dataframe
chars |> 
  unnest_wider(json) |> 
  select(id, where(is.list))

# unnest titles column into rows
chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles)

# saving title data in its own table for joining to characters data
# remove rows with empty strings and renaming titles to title
titles <- chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles) |> 
  filter(titles != "") |> 
  rename(title = titles)
titles

# tables can be created for each of the list-columns
# separated data can be joined as needed

# gmaps_cities is a two-column tibble of five cities and 
# results of Google's geocoding API as a very deeply nested list-column
gmaps_cities

# unnest named list-column json into columna
gmaps_cities |> 
  unnest_wider(json)

# status column has one distinct value, OK, so it can be dropped
# if status is not OK during real analysis, check what went wrong
gmaps_cities |> 
  unnest_wider(json) |> 
  distinct(status)

# unnest unnamed list-column results into separate rows 
# reveals multiple cities with the same name
gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results)

# unnesting results into more columns
# reveals Arlington matched cities in two different states
# and Washington matched District of Columbia and Washington state
locations <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |> 
  unnest_wider(results)
locations

# unnesting geometry column to find exact location of match
# bounds is a rectangular region, location is a point
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry)

# unnest location to see latitude and longitude
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  unnest_wider(location)

# extracting bounds
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  select(!location:viewport) |> 
  unnest_wider(bounds)

# renaming northeast and southwest for cleaner unnested names with names_sep
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |> 
  select(!location:viewport) |> 
  unnest_wider(bounds) |> 
  rename(ne = northeast, sw = southwest) |> 
  unnest_wider(c(ne, sw), names_sep = "_")

# can use tidyr to directly extract components after discovering access path
locations |> 
  select(city, formatted_address, geometry) |> 
  hoist(
    geometry, 
    ne_lat = c("bounds", "northeast", "lat"),
    ne_lng = c("bounds", "northeast", "lng"),
    sw_lat = c("bounds", "southwest", "lat"),
    sw_lng = c("bounds", "southwest", "lng")
  )

# -------------------------------------------------------------------------

# 1. Roughly estimate when gh_repos was created.
# Why can you only roughly estimate the date?

# latest repo update captured in gh_repos is at October 25, 2016
# so the info was created on or after that date
# gh_repos does not explicitly declare its creation date
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(updated_at) |> 
  arrange(desc(updated_at))


# 2. The owner column of gh_repo contains a lot of duplicate information since
# each owner can have many repos. Can you construct an owners data frame that
# contains one row for each owner?

# distinct() works with list-columns
owners <- repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  distinct(owner) |> 
  unnest_wider(owner, names_sep = "_")
owners


# 3. Follow the steps used for titles to create tables for the aliases,
# allegiances, books, and TV series for the Game of Thrones characters.

# titles contains id and title
titles

aliases <- chars |> 
  unnest_wider(json) |> 
  select(id, aliases) |> 
  unnest_longer(aliases) |> 
  filter(aliases != "")
aliases

allegiances <- chars |> 
  unnest_wider(json) |> 
  select(id, allegiances) |> 
  unnest_longer(allegiances)
allegiances

books <- chars |> 
  unnest_wider(json) |> 
  select(id, books) |>
  unnest_longer(books)
books

tvSeries <- chars |> 
  unnest_wider(json) |> 
  select(id, tvSeries) |> 
  unnest_longer(tvSeries)
tvSeries


# 4. Explain the following code line-by-line. Why is it interesting?
# Why does it work for got_chars but might not work in general?

# convert list of nested lists into tibble
tibble(json = got_chars) |> 
  # unnest named list-column json, one column for each named element of list
  unnest_wider(json) |> 
  # select id column and all list-columns
  select(id, where(is.list)) |> 
  # pivot list-columns, convert name of list-column to value of column "name"
  # and list as value of column "value"
  pivot_longer(
    where(is.list),
    names_to = "name",
    values_to = "value"
  ) |> 
  # unnest list-column value, one row for each element in list
  unnest_longer(value)

# The resulting code works because the list-columns created after
# unnesting json are all the same depth, allowing pivoting into simple
# character vectors. If some list-columns had greater levels of nesting, 
# pivot_longer would not work and further unnesting would be needed.


# 5. In gmaps_cities, what does address_components contain? Why does the length
# vary between rows? Unnest it appropriately to figure out.

cities <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |> 
  unnest_wider(results) |> 
  select(formatted_address, address_components)

# address_components contains up to 4 subcomponents, each a list
# these lists contain two sublists
# first sublist provides long and short names of address component
# second sublist indicates type of address component
# locality, administrative_level_2, administrative_level_1, country
# length of address_components varies depending on 
View(cities)

cities |> 
  unnest_wider(address_components, names_sep = "_") |> 
  pivot_longer(
    cols = -formatted_address,
    names_to = "component",
    values_to = "subcomponent"
  ) |> 
  unnest_wider(subcomponent) |> 
  unnest_wider(types, names_sep = "_") |> 
  select(-c(short_name, types_2)) |> 
  filter(!is.na(long_name)) |> 
  mutate(component = parse_number(component)) |> 
  rename(type = types_1)
