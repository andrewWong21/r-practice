{
  library("tidyverse")
  library("repurrrsive")
  library("jsonlite")
}

# JSON is short for JavaScript Object Notation
# main format in which web APIs return data
# designed to be easily read by machines

# six key data types, of which four are scalars
# null acts like NA in R
# string also works like a string in R, requires double quotes
# number can be written in integer, decimal, or scientific notation
# JSON does not support Inf, -Inf, or NaN values
# boolean is written as lowercase true or false

# JSON scalars can only represent single values
# use arrays and objects to represent multiple values

# arrays are like unnamed lists in R, written with []
# e.g. [1, 2, 3] or [null, 1, "string", false]
# objects are like named lists, written with {}
# names are strings, which must be surrounded with quotes
# e.g. {"x": 1, "y": 2}

# JSON does not have a native way to represent dates or date-times
# so they are usually stored as strings, will need to use
# readr::parse_date() or readr::parse_datetime() to convert them

# floating point numbers are also sometimes stored as strings
# due to imprecision in JSON floating point representation
# so use readr::parse_double() to convert when necessary

# use jsonlite package to convert JSON into R data structures
# read_json() is used for reading JSON files from disk
# parse_json() is for parsing JSON structure from a string

# path to json file
gh_users_json()

# convert json file into list
gh_users2 <- read_json(gh_users_json())

# check if data is identical to the gh_users list provided by the package
identical(gh_users, gh_users2)

# parse_json() is useful for generating simple examples
# one number
str(parse_json('1'))
# numbers in array
str(parse_json('[1, 2, 3]'))
# numbers in array within object
str(parse_json('{"x": [1, 2, 3]}'))

# jsonlite package also provides fromJSON(), which does automatic 
# simplification of vectors, which works well in simple cases but
# it's best to understand the process of rectangling nested structures

# most JSON files contain a single top-level array: data about multiple things
json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}
]'

# start rectangling of JSON array with tibble(json)
df <- tibble(json = parse_json(json))
df
df |> 
  unnest_wider(json)

# some JSON files may consist of a single top-level object - one thing
# start by wrapping object in list before putting it in a table
json2 <- '{
  "status": "OK",
  "results": [
    {"name": "John", "age": 34},
    {"name": "Susan", "age": 27}
  ]
}'

df2 <- tibble(json = list(parse_json(json2)))
df2
df2 |> 
  unnest_wider(json) |> 
  unnest_longer(results) |> 
  unnest_wider(results)

# alternatively, reach inside parsed JSON and extract relevant portion
df3 <- tibble(results = parse_json(json2)$results)
df3 |> 
  unnest_wider(results)

# -------------------------------------------------------------------------

# 1. Rectangle the df_col and df_row below.
# They represent the two ways of coding a data frame in JSON.

json_col <- parse_json('
  {
    "x": ["a", "x", "z"],
    "y": [10, null, 3]
  }                     
'
)

# wrap object in list before putting it in a tibble
# turn each element into a row containing a named list
# unnest named list to put elements into columns with unnest_wider()
# unnest unnamed lists to put elements into rows with unnest_longer()
tibble(json = list(json_col)) |> 
  unnest_wider(json) |> 
  unnest_longer(c(x, y))

json_row <- parse_json('
  [
    {"x": "a", "y": 10},
    {"x": "x", "y": null},
    {"x": "z", "y": 3}
  ]
')

# single top-level array, turn each element into a row containing a named list
# unnest named list to put elements into columns with unnest_wider()
tibble(json = json_row) |> 
  unnest_wider(json)
