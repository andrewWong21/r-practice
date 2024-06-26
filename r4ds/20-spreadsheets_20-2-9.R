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

# instead, read as text first and then make change to value after loading
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
penguins_torgersen <- read_excel(
  "data/penguins.xlsx",
  sheet = "Torgersen Island",
  na = "NA"
)
penguins_torgersen

# alternatively, use excel_sheets() to get info on all worksheets
# and read only the ones to be used for data analysis
excel_sheets("data/penguins.xlsx")

penguins_biscoe <- read_excel(
  "data/penguins.xlsx",
  sheet = "Biscoe Island",
  na = "NA"
)
penguins_dream <- read_excel(
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

# all values in .csv files are strings
# cells in Excel spreadsheets may hold one of four things:
# a boolean: TRUE, FALSE, NA
# a number: 10 or 10.5
# a datetime: "11/1/21" or "11/1/21 3:00 PM"
# a text string: "ten"

# Excel has no notion of integers, stores all numbers as floating points
# numbers can be displayed with customizable number of decimal places
# dates are stored as numbers (seconds since midnight of Jan 1, 1970)
# some cell contents look like numbers but are actually strings: e.g. '10

# readxl will guess data types for given columns
# first let readxl guess, then reimport with specified col_types if needed
# columns may mix data types, set data type to "list" to load as vectors

# data may be stored in other cell properties besides content
# e.g. cell background color or text formatting
# tidyxl package provides tools for handling non-tabular data
# https://nacnudus.github.io/tidyxl/

# data can be written back to disk as Excel file using write_xlsx()
bake_sale <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
)

# column names in Excel are included and bolded by default
# set col_names and format_headers = FALSE to change this behavior
write_xlsx(bake_sale, path = "data/bake-sale.xlsx")

# data type info is lost when reading file back into R
# factor -> chr, integer -> dbl
read_xlsx("data/bake-sale.xlsx")

# openxlsx package has more features compared to writexl package
# additional features like writing to worksheets and styling
# https://ycphs.github.io/openxlsx

# different naming conventions compared to tidyverse, so
# running example functions in documentation is recommended
# when learning to work with coding style of unfamiliar packages

# -------------------------------------------------------------------------

# 1. Read survey.xlsx into R, with survey_id as a character variable and
# num_pets as a numeric variable.

survey <- read_xlsx(
  path = "data/survey.xlsx",
  col_types = c("text", "text"),
  na = c("N/A")
) |> 
  mutate(
    survey_id = str_sub(survey_id, 1, 1),
    n_pets = if_else(n_pets == "two", "2", n_pets),
    n_pets = parse_number(n_pets)
  )
survey


# 2. Read roster.xlsx into R and call the resulting data frame roster.

roster <- read_xlsx(
  path = "data/roster.xlsx"
) |> 
  fill(everything()) # or fill(group, subgroup)
roster


# 3. Read sales.xlsx into R and call the resulting data frame sales.
sales <- read_xlsx(
  path = "data/sales.xlsx",
  col_names = c("id", "n"),
  range = "A5:B13"
) |> 
  mutate(
    id = if_else(str_starts(id, "Brand"), id, str_sub(id, 1, -3)),
    n = str_sub(n, 1, 1)
  )
sales

# tidying sales into format with three columns - brand, id, n
# with brand as <chr>, id as <dbl>, n as <dbl>
sales <- sales |> 
  mutate(
    brand = if_else(str_starts(id, "Brand"), id, NA),
    .before = 1
  ) |> 
  fill(brand) |> 
  filter(!str_starts(id, "Brand")) |> 
  mutate(
    id = as.double(id),
    n = as.double(n)
  )
sales


# 4. Recreate the bake_sale data frame and write it to an Excel file using
# the write.xlsx() function from the openxlsx package.

library("openxlsx")
bake_sale2 <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
) 
bake_sale2 |> 
  write.xlsx("data/bake_sale2.xlsx")


# 5. Read students.xlsx and use the function janitor::clean_names()
# to "clean" the column names.
students2 <- read_xlsx("data/students.xlsx")
students2
students2 |> janitor::clean_names()
