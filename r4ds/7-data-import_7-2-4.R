{
  library("tidyverse")
  library("janitor")
}

# files can be read from relative path or URL
students <- read_csv("data/students.csv")
# students <- read_csv("https://pos.it/r4ds-students-csv")
# output of read_csv() provides number of rows and columns, delimiter used,
# and column specifications, 

# read_csv() recognizes empty strings as missing values by default
# use the na argument to specify additional strings that should be treated as missing values

students <- read_csv("data/students.csv", na = c("N/A", ""))

# non-syntactic names break R's rules for variable numbers and require backticks for reference
students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# can also use janitor::clean_names() to convert non-syntactic names into snake_case
students |> 
  janitor::clean_names()

# variable types should be considered after reading in data
# categorical variables in R with a known set of possible values should be represented as a factor 