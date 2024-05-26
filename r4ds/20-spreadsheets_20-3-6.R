{
  library("tidyverse")
  library("googlesheets4")
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

# -------------------------------------------------------------------------

