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

# group_next() nests tibbles, resulting in one row per value combination
# of grouping variables, with last column being a list column of tibbles
by_clarity <- diamonds |> 
  group_nest(clarity)
by_clarity

by_clarity$data[[1]]

# create column that gives name of output file
by_clarity <- by_clarity |>
  mutate(path = str_glue("data/diamonds-{clarity}.csv"))
by_clarity

# map() cannot be used since two arguments change for write_csv()
# use map2() to vary first and second arguments, or walk2() without output
walk2(by_clarity$data, by_clarity$path, write_csv)

# create function for drawing plot from dataframe
carat_histogram <- function(df){
  ggplot(df, aes(x = carat)) + geom_histogram(binwidth = 0.1)
}

carat_histogram(by_clarity$data[[1]])

by_clarity <- by_clarity |> 
  mutate(
    plot = map(data, carat_histogram),
    plot_path = str_glue("data/clarity-{clarity}.png")
  )
by_clarity

# save each plot by combining walk2() with ggsave()
walk2(
  by_clarity$plot_path,
  by_clarity$plot,
  \(path, plot) ggsave(path, plot, width = 6, height = 6)
)

# recap: explicit iteration can be used to manipulate multiple columns, 
# read multiple files, and save multiple outputs without repetitive code

# R's orientation towards data analysis means that there is often an 
# existing idiom or functional programming tool to handle iterative tasks

# recommended reading for learning more about iteration: 
# Functionals chapter of Advanced R https://adv-r.hadley.nz/functionals.html
# documentation for purrr package https://purrr.tidyverse.org/
