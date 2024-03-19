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

students |> 
  janitor::clean_names() |> 
  mutate(meal_plan = factor(meal_plan))

# fixing age column due to non-numeric value
students <- students |> 
  janitor::clean_names() |> 
  mutate(meal_plan = factor(meal_plan),
         age = parse_number(if_else(age == "five", "5", age)) # test, yes, no
  )

# read_csv() can read text strings formatted like a CSV file
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

# metadata in files can be skipped using skip argument to skip n lines
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

# comment argument drops lines with given start
read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

# setting col_names argument to FALSE treats first row as data,
# using default column names of X1, X2, X3, ..., Xn
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

# can also pass a character vector to col_names to manually specify column names
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

# other functions include read_csv2() for semicolon-delimited files,
# read_tsv() for tab-separated files,
# read_delim() for automatically-guessed or specified delimiters,
# read_table() for columns separated by whitespace

# readr guesses column types using a heuristic,
# which generally works well for clean datasets
# but can break down for missing values

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

# automatically classifies columns as logical, numeric, dates, or strings

simple_csv <- "
  x
  10
  .
  20
  30"

read_csv(simple_csv)
# the column x is numeric with . for missing values, but readr classifies it as a character column
# readr expects NA for missing values by default

# if dataset encounters unexpected value with specified column type, it will report a parsing issue
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

# specifying how the dataset represents missing values fixes the issue
read_csv(simple_csv, na = ".")

# reader has 9 column types
# col_logical() and col_double() for logicals (T, F) and real numbers respectively, usually guessed
# col_integer() can be useful to save space compared to col_double()
# col_character() is used for strings
# col_factor() for columns with a limited number of values, will be covered later
# col_date() and col_datetime() for dates and date-times
# col_number() ignores non-numeric components within field
# col_skip() indicates that a column will not be included in the final result

# cols_only() allows explicit specification of columns to be read 

# read_csv() can read multiple files at once
sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)

read_csv(sales_files, id = "file")
# id argument can be used to identify which file the row originates from

# list.files() function can be used to generate a list of existing files matching filename pattern
sales_files2 <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
sales_files2

students

# write data back to disk with write_csv() and write_tsv() with arguments x (dataframe) and file (location)
# when data is written back to disk, column information is lost, can be troublesome with factor columns

# write_rds() and read_rds() store data in the form RDS, R's custom binary format
# which maintains column types and groupings

# arrow package can be used to save data as parquet files, which are faster and can be used outside of R
library("arrow")
write_parquet(students, "students.parquet")

# tibble() and tribble() allow manual specification of tibble objects, best for small datasets
# tibble() assembles tibbles by column
tibble(
  x = c(1, 2, 5),
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# tribble() lays out data row by row as a transposed tibble
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)

# if issues arise, build a minimal reproducible example
# using library() and necessary objects directly related to problem
# reprex::reprex() formats code in Markdown format that can be copy-pasted and immediately run
reprex::reprex()
mtcars <- dput(mtcars)

# make sure to include packages with library(), smallest useful subset of data with dput(), and concise code

# -------------------------------------------------------------------------

# 1. What function would you use to read a file where fields were separated by "|"?
read_delim(
  "a|b|c
  1|2|3
  4|5|6",
  delim = "|"
)


# 2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?

# col_names = TRUE,
# col_types = NULL,
# col_select = NULL,
# id = NULL,
# locale = default_locale(),
# na = c("", "NA"),
# quoted_na = TRUE,
# quote = "\"",
# trim_ws = TRUE,
# n_max = Inf,
# guess_max = min(1000, n_max),
# name_repair = "unique",
# num_threads = readr_threads(),
# progress = show_progress(),
# show_col_types = should_show_types(),
# skip_empty_rows = TRUE,
# lazy = should_read_lazy()


# 3. What are the most important arguments to read_fwf()?
# file and col_positions
# col_positions uses fwf_empty(), fwf_widths(), fwf_positions(), or fwf_cols()
# to describe the field structure of the fixed-width file
text3 <- 
"1 2 3
4 5 6"

read_fwf(text3, fwf_empty(text3, col_names = c("x", "y", "z")))
read_fwf(text3, fwf_widths(c(2, 2, 2), c("x", "y", "z")))
read_fwf(text3, fwf_cols(x = c(1, 2), y = c(3, 4), z = c(5, 6)))


# 4. To read the following text into a data frame, what argument do you need to specify to read_csv()?
text4 <- "x,y\n1,'a,b'"
read_csv(
  text4,
  quote = "'"
)
# specify the quote argument as the character '
# to correctly treat a,b as a string surrounded by single quotes


# 5. Identify what is wrong with each of the following inline CSV files.
read_csv("a,b\n1,2,3\n4,5,6") |> problems()
# 2 columns in header row, but data rows have 3 columns
read_csv("a,b,c\n1,2\n1,2,3,4") |> problems()
# 3 columns in header row, but one data row has 2 columns and one data row has 4 columns
read_csv("a,b\n\"1")
# 2 columns in header row, but data row has 1 column with unclosed escaped quote
read_csv("a,b\n1,2\na,b")
# first data row suggests numeric columns but second data row suggests character columns
read_csv("a;b\n1;3")
# fields delimited by semicolons so read_csv2() should be used here


# 6. Practice referring to non-syntactic names in the following data frame.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# Extract the variable called 1.
select(annoying, `1`)

# Plot a scatterplot of 1 vs 2.
annoying |> 
  ggplot(aes(x = `2`, y = `1`)) +
  geom_point()

# Create a new column called 3, which is 2 divided by 1.
annoying <- annoying |> 
  mutate(
    "3" = `2` / `1`
  )

# Rename the columns to one, two, and three.
annoying |> 
  rename(
    one = `1`,
    two = `2`,
    three = `3`
  )
