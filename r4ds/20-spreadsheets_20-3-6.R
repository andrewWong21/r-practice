{
  library("tidyverse")
  library("googlesheets4")
  library("readxl")
}

# Google Sheets is a free web-based spreadsheet program
# organizes data in worksheets within spreadsheet files, like with Excel

# use read_sheet() to read a Google sheet from a URL or file ID
# range_read() is a synonym function

# create new sheet with gs4_create(), write to existing sheet with sheet_write()

# gs4_deauth() is used to prevent authorization request
# view public resource using an API key instead of sending a token
gs4_deauth()

# first argument to read_sheet() takes a URL or file ID, best to alias ID first
students_sheet_id <- "1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w"
students <- read_sheet(students_sheet_id)
students

# column names, NA strings, and column types can be supplied to read_sheet()
students <- read_sheet(
  students_sheet_id,
  col_names = c("student_id", "full_name", "favorite_food", "meal_plan", "age"),
  skip = 1,
  na = c("", "NA"),
  col_types = "dcccc"
)
students

# column types are defined using short codes - "dcccc" is short for
# double, character, character, character, character

# reading individual sheets from penguins Google Sheet
penguins_sheet_id <- "1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY"
read_sheet(penguins_sheet_id, sheet = "Torgersen Island")

# get list of all sheets within Google Sheet using sheet_names()
sheet_names(penguins_sheet_id)
read_sheet(penguins_sheet_id, sheet = "Biscoe Island")
read_sheet(penguins_sheet_id, sheet = "Dream Island")

# read portion of Google Sheet by defining range within read_sheet()
deaths_url <- gs4_example("deaths")
deaths <- read_sheet(deaths_url, range = "A5:F15")
deaths

# write from R to Google Sheets using write_sheet()
# first argument is data frame to write
# second is name or identifier of sheet to write to
bake_sale <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
)
bake_sale
write_sheet(bake_sale, ss = "bake-sale-gs")
write_sheet(bake_sale, ss = "bake-sale-gs", sheet = "Sales")

# reading sheets can be done with gs4_deauth() to avoid authenticating, but
# writing to a sheet requires authentication with Google account

# specify Google account with gs4_auth(email = "mine@example.com")

# -------------------------------------------------------------------------

# 1. Read the students dataset from Excel and also Google Sheets with no 
# additional arguments supplied to the read_excel() and read_sheet() functions.
# Are the resulting dataframes exactly the same? If not, how are they different?

read_excel("data/students.xlsx")
read_sheet(students_sheet_id)

# reading from .xlsx file results in AGE column having type <chr>
# reading from Google Sheet results in AGE column having type <list>
# with four lists containing a double, one list containing a character variable,
# and one NULL object

# 2. Read the Google Sheet titled survey from https://pos.it/r4ds-survey
# with survey_id as a character variable and n as a numeric variable.
survey_sheet_id <- "1yc5gL-a2OOBr8M7B3IsDNX5uR17vBHOyWZq6xSTG2G8"
read_sheet(survey_sheet_id, col_types = "cd") # character, double


# 3. Read the Google Sheet titled roster from https://pos.it/r4ds-roster
# with all missing values filled in.
roster_sheet_id <- "1LgZ0Bkg9d_NK8uTdP2uHXm07kAlwx8-Ictf8NocebIE"
read_sheet(roster_sheet_id) |> 
  fill(group, subgroup)
