library("tidyverse")

# bind_rows can get tedious if many files need to be combined
# data2019 <- readxl::read_excel("data/y2019.xlsx")
# data2020 <- readxl::read_excel("data/y2020.xlsx")
# data2021 <- readxl::read_excel("data/y2021.xlsx")
# data2022 <- readxl::read_excel("data/y2022.xlsx")
# data <- bind_rows(data2019, data2020, data2021, data2022)

# automate task with 3 steps
# list.files() to list files in directory
# purrr::map() to read files into list
# purrr::list_rbind() to combine files into data frame

# usually specify 3 arguments for list.files()
# path is directory to search
# pattern filters file names by regex, usually by extension
# full.names specifies whether directory should be part of output, usually TRUE
paths <- list.files("data/gapminder", pattern = "[.]xlsx$", full.names = TRUE)
paths

# collect files into list
# map() works like across(), applies function to every element of vector
files <- map(paths, readxl::read_excel)
length(files)
files[[1]]

# combine list of data frames into single data frame
list_rbind(files)

# pipeline combining steps
paths |> 
  map(readxl::read_excel) |> 
  list_rbind()

# pass extra arguments with lambda function
# missing year column since value is stored in path
paths |> 
  map(\(path) readxl::read_excel(path, n_max = 1)) |> 
  list_rbind()

# to record year as column, name vector of paths with set_name()
# and use names_to argument in list_rbind()

files <- paths |> 
  set_names(basename) |> 
  map(readxl::read_excel)
files

files[["1962.xlsx"]]

# parse year from string values in year column after combining data frames
paths |> 
  set_names(basename) |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year") |> 
  mutate(year = parse_number(year))

# if filename contains multiple bits of data, use setnames() without arguments
# and separate_wider_delims() to create columns from parts of filename
paths |> 
  set_names() |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year") |> 
  separate_wider_delim(year, delim = "/", names = c(NA, "dir", "file")) |> 
  separate_wider_delim(file, delim = ".", names = c("file", "ext"))

# save tidy data frame to .csv file or .parquet for larger datasets
gapminder <- paths |> 
  set_names(basename) |> 
  map(readxl::read_excel) |> 
  list_rbind(names_to = "year")
write_csv(gapminder, "data/gapminder.csv")

# when working in a project, put preparation code into file with 0 as prefix
# indicating it should be run first (e.g. 0-cleanup.R)
