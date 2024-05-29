{
  library("DBI")
  library("dplyr")
  library("tidyverse")
}

# a database is a collection of data frames called tables
# data tables are stored on disk (frames in memory), can be arbitrarily large
# data tables have indexes for finding rows, unlike data frames and tibbles
# classical databases are optimized for collecting data rather than analyzing

# databases are run by database management systems, three types
# client-server (central server) - PostgreSQL, SQL Server, Oracle
# cloud (for extremely large datasets) - Snowflake, RedShift, BigQuery
# in-process (runs entirely on computer) - SQLite, duckdb

# use DBI package to connect to SQL database and retrieve data with SQL query
# DBI is short for DataBase Interface, low-level interface for executing SQL
# need another package for specific DBMS type to translate DBI commands for
# given DBMS, usually one package for each, or use odbc package if not found

# dbplyr translates dplyr code to SQL queries, executes with DBI
# SQL - structured query language

# create database connection using DBI::dbConnect()
# first argument selects DBMS, second argument describes how to connect to it

# duckdb is an in-process DBMS that lives entirely in an R package
# by default, temporary database is created, deleted when quitting R
con <- DBI::dbConnect(duckdb::duckdb())

# supply dbdir argument to create a persistent database location
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")

# use DBI::dbWriteTable() to load data into database
# three arguments - DB connection, name of data table to create, and data frame
dbWriteTable(con, "mpg", ggplot2::mpg)
dbWriteTable(con, "diamonds", ggplot2::diamonds)

# duckdb_read_csv() and duckdb_register_arrow() allow loading data
# directly into duckdb without having to load data into R first

# check data is loaded correctly with dbListTables() to list tables in db
dbListTables(con)

# retrieve contents of table with dbReadTable(), returns data.frame
# convert output into tibble with as_tibble()
con |> 
  dbReadTable("diamonds") |> 
  as_tibble()

# use dbGetQuery() to get results of running SQL query on database
sql <- "
  SELECT carat, cut, clarity, color, price
  FROM diamonds
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))

# dbplyr is dplyr backend that is translated to SQL
# other backends are available like dtplyr and multidplyr

# first step is using tbl() to create table from source
diamonds_db <- tbl(con, "diamonds")
diamonds_db

# option to supply schema or catalog using in_schema() or in_catalog()
# to navigate hierarchy in larger (e.g. corporate) databases
# or use SQL query as starting point
diamonds_db <- tbl(con, sql("SELECT * FROM diamonds"))
diamonds_db

# dplyr verbs do not do any work on tbl objects
# operations are first recorded and only performed when needed (lazy)
big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price)
big_diamonds_db

# resulting object is a database query - prints DBMS at top
# shows number of columns but not full number of rows - requires execution
big_diamonds_db |> 
  show_query()

# get data back into R by running collect() to execute query on data
# and convert results into tibble for analysis
big_diamonds <- big_diamonds_db |> 
  collect()
big_diamonds

# dbplyr has function for copying nycflights13 tables into database
dbplyr::copy_nycflights13(con)
flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

# top-level components of SQL are statements - CREATE, INSERT, SELECT
# statements with SELECT are called queries, made up of clauses
# SELECT, FROM, WHERE, ORDER BY, GROUP BY
# queries involving data must contain SELECT and FROM

# simplest query is "SELECT * FROM table"
flights |> show_query()
planes |> show_query()

# WHERE, ORDER BY control inclusion and ordering of rows
flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |> 
  show_query()

# GROUP BY applies aggregation with summaries
flights |> 
  group_by(dest) |> 
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) |> 
  show_query()

# case does not matter in SQL, but convention is to capitalize keywords
# order matters - must follow the order SELECT, FROM, WHERE, GROUP BY, ORDER BY
# evaluation order is different - FROM, WHERE, GROUP BY, SELECT, ORDER BY

# SELECT performs the same tasks as the dplyr verbs
# select(), mutate(), rename(), relocate(), summarize()

# select(), rename(), relocate() translate directly
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  rename(year_built = year) |> 
  show_query()

planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  relocate(manufacturer, model, .before = type) |> 
  show_query()

# renaming is called aliasing in SQL, done using the keyword AS
# in SQL the new name is on the right, in rename() the new name is on the left

# year and type are reserved words in duckdb, wrapped in double quotes
# other databases may have all columns quoted to avoid reserved words
# some systems may use double quotes or backticks to escape reserved words
