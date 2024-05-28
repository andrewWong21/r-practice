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

# check data is loaded correctly with dbListTables()
dbListTables(con)
