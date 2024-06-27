library("tidyverse")

# map() can be used to read multiple files into a single object

# in some cases, may need to write multiple objects into one or more outputs
# e.g. one database, multiple .csv files, multiple .png files

# working with multiple files may involve more data than can fit into memory
# one solution is to load data into database and access portions with dplyr
paths <- list.files("data/gapminder", pattern = "[.]xlsx$", full.names = TRUE)

# duckdb_read_csv() has function to take vector of paths and load into
# database, but gapminder folder contains .xlsx files, not .csv
#con <- DBI::dbConnect(duckdb::duckdb())
#duckdb::duckdb_read_csv(con, "gapminder", paths)

# start with template, dummy data frame that contains desired columns
# but only sampling of desired data
template <- readxl::read_excel(paths[[1]])
template$year <- 1952
template

# use DBI::dbCreateTable() to turn template into database table
con <- DBI::dbConnect(duckdb::duckdb())
DBI::dbCreateTable(con, "gapminder", template)

# dbCreateTable() only uses variable names and types, not data
# resulting table is empty but has specified variables and types
con |> tbl("gapminder")

# combine read_excel() with DBI::dbAppendTable()
# to create function that reads file path into R and adds result to table
append_file <- function(path){
  df <- readxl::read_excel(path)
  df$year <- parse_number(basename(path))
  DBI::dbAppendTable(con, "gapminder", df)
}

# walk() does the same thing as map() but does not provide output
paths |> walk(append_file)

# view gapminder table to check if data was added properly
con |> 
  tbl("gapminder") |> 
  count(year)
