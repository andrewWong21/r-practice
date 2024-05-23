{
  library("tidyverse")
  library("readxl")
  library("writexl")
}

# three functions for loading Excel spreadsheets into R
# read_xls() for .xls files, read_xlsx for .xlsx files
# read_excel() guesses filetype as .xls or .xlsx based on input

students <- read_excel("data/students.xlsx")
students

# rename columns into snake_case with col_names argument
students <- read_excel(
  "data/students.xlsx",
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age")
)
students

# previous header row will show up as first observation
# unless argument skip = 1 is specified
students <- read_excel(
  "data/students.xlsx",
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age"),
  skip = 1
)
students

# N/A value in favorite_food column should be replaced with missing value
# specify character string to be recognized as NA with argument na = c(...)
# by default, empty string "", empty cells, and formula =NA() become NA
students <- read_excel(
  "data/students.xlsx",
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A")
)
students

# fix type of age column - <chr> but should be <dbl>, problem is value "five"
# specify column types with argument col_types = c(...)
# supported column types: skip, guess, logical, numeric, data, text, list

# reading age column as numeric will coerce the value "five" into NA
# and results in a warning message
students <- read_excel(
  "data/students.xlsx",
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "numeric")
)
students

# instead, read as text first and then  make change to value after loading
students <- read_excel(
  "data/students.xlsx",
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "N/A"),
  col_types = c("numeric", "text", "text", "text", "text")
)
students <- students |> 
  mutate(
    age = if_else(age == "five", "5", age),
    age = parse_number(age)
  )
students

# trial-and-error process to load dataset in desired format
# iterative process: load, check results, make adjustments, repeat
# spreadsheets are used not just for storage but also sharing and communication

# Excel spreadsheets may have multiple worksheets
# read a single worksheet using the argument sheet = "title"
# default behavior is reading the first worksheet of the spreadsheet
penguins_torgersen <- 
  read_excel(
    "data/penguins.xlsx",
    sheet = "Torgersen Island",
    na = "NA"
  )
penguins_torgersen

# alternatively, use excel_sheets() to get info on all worksheets
# and read only the ones to be used for data analysis
excel_sheets("data/penguins.xlsx")

penguins_biscoe <- 
  read_excel(
    "data/penguins.xlsx",
    sheet = "Biscoe Island",
    na = "NA"
  )
penguins_dream <- 
  read_excel(
    "data/penguins.xlsx",
    sheet = "Dream Island",
    na = "NA"
  )

# each worksheet has the same number of columns but a different number of rows
dim(penguins_torgersen)
dim(penguins_biscoe)
dim(penguins_dream)

# combine worksheets together with bind_rows()
penguins <- bind_rows(penguins_torgersen, penguins_biscoe, penguins_dream)
penguins

# excel spreadsheets are used for presentation as well as storage
# cell entries may exist in spreadsheet that are not part of data to be read

# readxl_example() shows example spreadsheets provided by readxl
readxl_example()

deaths_path <- readxl_example("deaths.xlsx")
deaths <- read_excel(deaths_path)

# top 3 rows and bottom 4 rows are not part of data
deaths

# can supply range of cells to be read instead of using skip_n and max
# top left cell is A1, rows denoted by letters, columns denoted by numbers
read_excel(deaths_path, range = "A5:F15")

# -------------------------------------------------------------------------


