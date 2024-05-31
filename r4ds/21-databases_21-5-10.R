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

# variables created in mutate() are translated as new expressions in SELECT
flights |> 
  mutate(
    speed = distance / (air_time / 60)
  ) |> 
  show_query()

# FROM is straightforward when working with single tables - one data source
# becomes more important when combined with join functions

# group_by() is translated to GROUP BY clause
# summarize() is translated to SELECT clause
diamonds_db |> 
  group_by(cut) |> 
  summarize(
    n = n(),
    avg_price = mean(price, na.rm = TRUE)
  ) |> 
  show_query()

# filter is translated to WHERE clause
flights |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  show_query()

# in SQL, | is translated to "or", & is translated as "and"
# SQL uses = for comparison as assignment is not possible
# SQL uses single quotes for strings and double quotes for variables

# SQL also has keyword IN, similar to %in%
flights |> 
  filter(dest %in% c("IAH", "HOU")) |> 
  show_query()

# SQL uses NULL compared to R's NA, are also infectious in comparisons and 
# arithmetic, but are always silently dropped in summaries
# dbplyr provides warnings about this behavior
flights |> 
  group_by(dest) |> 
  summarize(delay = mean(arr_delay))

# NULLs can be handled in SQL the same way NA is handled in R
flights |> 
  filter(!is.na(dep_delay)) |> 
  show_query()
# SQL translation will be correct but not always the simplest

# filtering a variable created with summarize will generate HAVING clause
# in SQL, filtering (WHERE) is evaluated before SELECT and GROUP BY
# HAVING is evaluated after SELECT and GROUP BY
diamonds_db |> 
  group_by(cut) |> 
  summarize(n = n()) |> 
  filter(n > 100) |> 
  show_query()

# arrange() is translated into ORDER BY clause
flights |> 
  arrange(year, month, day, desc(dep_delay)) |> 
  show_query()
# desc() in dplyr is another SQL-inspired function, based on keyword DESC

# a dplyr pipeline may require a subquery within a SELECT statement
# a subquery is a query used as a data source for the FROM clause

# subqueries are used to handle limitations of SQL,
# such as the inability to reference newly-created columns

# dplyr can create column and then reference it again within mutate()
# SQL requires two steps to replicate, compute year1 and then compute year2
flights |> 
  mutate(
    year1 = year + 1,
    year2 = year1 + 1
  ) |> 
  show_query()

# inner query is computed before the outer query

# filtering by newly-created variable results in subquery in SQL translation
# due to evaluation order of WHERE before SELECT
flights |> 
  mutate(year1 = year + 1) |> 
  filter(year1 == 2014) |> 
  show_query()

# joins in SQL are similar to those in dplyr
# add subclause to FROM clause to specify additional tables
# and use ON to define relation between tables for joining
flights |> 
  left_join(planes |> rename(year_built = year), by = "tailnum") |> 
  show_query()

# clear SQL equivalents for inner_join(), right_join(), full_join()

# database tables are often stored in highly normalized form
# to reduce redundancies and dependencies in data, creating complex networks
# use dm package https://cynkra.github.io/dm/ to determine table connections,
# provide visualizations for connections, and generate joins

# other dplyr verbs like distinct(), slice_*(), and intersect()
# can be translated, dbplyr updates continue to add translations
# for functions, as well as further optimize SQL queries

# some summary functions have simple translations while others are more complex
summarize_query <- function(df, ...){
  df |> 
    summarize(...) |> 
    show_query()
}
mutate_query <- function(df, ...){
  df |> 
    mutate(...) |> 
    show_query()
}

# mean() is simple, median() is complex
# complexity is usually higher for operations that are
# common in statistics but rare in databases
flights |> 
  group_by(year, month, day) |> 
  summarize_query(
    mean = mean(arr_delay, na.rm = TRUE),
    median = median(arr_delay, na.rm = TRUE)
  )

# using summary functions within mutate functions
# requires turning them into window functions in SQL
# SQL aggregations are converted into window functions with OVER keyword
flights |> 
  group_by(year, month, day) |> 
  mutate_query(
    mean = mean(arr_delay, na.rm = TRUE)
  )

# GROUP BY is used exclusively for summaries in SQL,
# so summary grouping in dplyr is done with PARTITION BY

# SQL tables have no intrinsic order, so arrange() is needed sometimes
# ordering function is repeated in window functions
# since ORDER BY in main query does not automatically apply to them
flights |> 
  group_by(dest) |> 
  arrange(time_hour) |> 
  mutate_query(
    lead = lead(arr_delay),
    lag = lag(arr_delay)
  )

# if_else() and case_when() are translated into SQL with keywords CASE WHEN
flights |> 
  mutate_query(
    description = if_else(arr_delay > 0, "delayed", "on-time")
  )

flights |> 
  mutate_query(
    description = 
      case_when(
        arr_delay < -5 ~ "early",
        arr_delay < 5 ~ "on-time",
        arr_delay >= 5 ~ "late"
      )
  )

# CASE WHEN is also used for other functions without direct translations
flights |> 
  mutate_query(
    description = cut(
      arr_delay,
      breaks = c(-Inf, -5, 5, Inf),
      labels = c("early", "on-time", "late")
    )
  )

# -------------------------------------------------------------------------

# 1. What is distinct() translated to? How about head()?
flights |> 
  distinct(dest) |> 
  show_query()
# distinct() is translated using the DISTINCT keyword before a column

flights |> 
  head(5) |> 
  show_query()
# head(n) is translated using the LIMIT keyword followed by the number of rows

# 2. Explain what each of the following SQL queries do and try
# recreating them using dplyr.

# SELECT *
# FROM flights
# WHERE dep_delay < arr_delay

# show rows from flights with departure delays less than arrival delays
flights |> 
  filter(dep_delay < arr_delay) |> 
  show_query()

# SELECT *, distance / (air_time / 60) AS speed
# FROM flights

# add column "speed" calculated from "distance" and "air_time" columns
flights |> 
  mutate(
    speed = distance / (air_time / 60)
  ) |> 
  show_query()
