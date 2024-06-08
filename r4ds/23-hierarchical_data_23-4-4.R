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
