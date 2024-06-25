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
# write_csv(gapminder, "data/gapminder.csv")

# when working in a project, put preparation code into file with 0 as prefix
# indicating it should be run first (e.g. 0-cleanup.R)

# if additional tidying is needed after loading files, best approach is to
# consider all files at once  with simple iterations of tidying functions

# writing one function to do all tidying steps
process_file <- function(path){
  df <- read_csv(path)
  df |> 
    filter(!is.na(id)) |> 
    mutate(id = tolower(id)) |> 
    pivot_longer(jan:dec, names_to = "month")
}
paths |> 
  map(process_file) |> 
  list_rbind()

# performing each step of tidying and cleaning process on every file
# results in holistic approach, higher quality result
paths |> 
  map(read_csv) |> 
  map(\(df) df |> filter(!is.na(id))) |> 
  map(\(df) df |> mutate(id = tolower(id))) |> 
  map(\(df) pivot_longer(jan:dec, names_to = "month")) |> 
  list_rbind()

# alternatively, bind data frames earlier before using dplyr verbs
paths |> 
  map(read_csv) |> 
  list_rbind() |> 
  filter(!is.na(id)) |> 
  mutate(id = tolower(id)) |> 
  pivot_longer(jan:dec, names_to = "month")

# data frames to combine may not be homogeneous
# list_rbind() may either fail or produce data frame that is not very useful

# start by loading files
files <- paths |> 
  map(readxl::read_excel)

# use df_types function to capture structure of data frame
# displaying column name, type, and number of missing values
df_types <- function(df){
  tibble(
    col_name = names(df),
    col_type = map_chr(df, vctrs::vec_ptype_full),
    n_miss = map_int(df, \(x) sum(is.na(x)))
  )
}

df_types(gapminder)

# apply function to all files and perform pivoting to find differences
files |> 
  map(df_types) |> 
  list_rbind(names_to = "file_name") |> 
  select(-n_miss) |> 
  pivot_wider(names_from = col_name, values_from = col_type)

# heterogeneous formats will require more processing with other tools
# map_if() selectively modifies list elements based on values
# map_at() selectively modifies list elements based on names

# map() either succeeds or fails as a whole
# if structure of files is sufficiently wild, map() may not read any files
# failure in one file should not prevent access to successfully read files

# purr provides helper for this problem in the form of possibly()
# function operator: takes function and returns function with modified behavior
# changes function from erroring to returning user-specified value
files <- paths |> 
  map(possibly(\(path) readxl::read_excel(path), NULL))

# list_rbind ignores NULLs so successfully read files can be accessed
data <- files |> list_rbind()
data

# get paths that failed and diagnose problem
# call import function on each file individually to find out what went wrong
failed <- map_vec(files, is.null)
paths[failed]
