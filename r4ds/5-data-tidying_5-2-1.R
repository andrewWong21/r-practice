library("tidyverse")

table1
table2
table3

# tidy datasets follow 3 interrelated rules:
# 1. each variable is a column and each column is a variable
# 2. each observation is a row and each row is an observation
# 3. each value is a cell and each cell is a single value

# two main advantages of keeping data tidy
# consistent data structure has underlying uniformity that makes tools easier to learn
# placing variables in columns works well with R's vectorized approach to data transformation

# two main reasons why real data is untidy
# data is often organized for a goal other than analysis, such as making data entry easier
# most people are not familiar with the above concepts of tidy datasets unless experienced in working with data

# data is pivoted into tidy form using pivot_longer() and pivot_wider()
billboard
# billboard has 3 columns artist, track, date.entered that are variables
# columns wk1-wk76 correspond to a single variable (week) and the cell values are another variable (rank)

# use pivot_longer() to select columns that should be turned into observations (i.e. columns to be pivoted)
# names_to represents the name of the column to store observations under
# values_to represents the name of the column that stores the cell values of the pivoted column
# drop NA values that were forced to exist from previous dataset structure
# parse_number() extracts first number within string
billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()


# pivoting works by 

df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

# pivot df longer into a dataset with columns id, measurement, value
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

# values for existing columns are repeated once for each column pivoted
# pivoted column names become values for a new variable specified by names_to
# and are repeated once for each row in original dataset
# cell values become values under new variable specified by values_to
# and are unwound, row by row, but not repeated

# separating columns into new variables when they store multiple pieces of information
# names_sep indicates separator between values in original column name
who2 |> 
  pivot_longer(
    cols = !country:year,
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )
# column names are pivoted into multiple columns

# column headers may also contain variable names in addition to variable values
# .value sentinel uses first component of pivoted column name as variable name in output
# so column name contributes to both values and variable names of output
household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
    
  )

# pivot_longer() is used when values are in column names,
# pivot_wider() is used when observations are spread across multiple rows
cms_patient_experience
cms_patient_experience |> 
  distinct(measure_cd, measure_title)
# pivot_wider() requires existing columns to define values, as well as column name
# plus columns which uniquely identify each row
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

df2 <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

df2 |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df2 |> 
  distinct(measurement) |> 
  pull()
# new column names are taken from column specified by names_from

# output rows are determined by id_cols, variables not going into new name or values
df2 |> 
  select(-measurement, -value) |> 
  distinct()

# pivot_wider() combines column names and output rows to produce empty dataframe,
# then fills in missing values from data in input
df2 |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

# if multiple rows in input correspond to one cell in output,
# resulting output of pivot_wider() will contain list-columns
df3 <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)

df3 |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

#identify duplicates using summarize(), n(), and filter()
df3 |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)
# repair or summarize and group row and column values until each combination has a single row

# tidy data is more consistent, but transforming untidy data can be a challenge
# it may also be difficult to determine which of the longer or wider datasets is tidy


# -------------------------------------------------------------------------

# 1. For each of the sample tables, describe what each observation and what each column represents.

# table1 features 6 observations in total, providing data on 3 countries in the years 1999 and 2000
# the cases column lists the number of TB cases reported in that country on that year
# the population column lists the total number of people living in that country on the given year

# table2 has the same country and year columns as table1
# the type column indicates whether the value in the corresponding count column for that observation
# represents the number of TB cases reported or the total population of the country

# table3 also has country and year columns that represent the same data as in table1 and table2
# the rate column in table3 is stored in character form as (cases)/(population)
# so any planned numeric operations will need to separate the two figures in the column
# and convert them into numeric form first


# 2. Sketch out the process you'd use to calculate the rate for table2 and table3.
# Operations: extract TB cases per country per year, extract matching population per country per year,
# divide cases by population and multiply by 10000, store in appropriate place

# table2:
# map case and population in types column to new columns with corresponding values
# match rows with the same country and year and divide cases value by population value
# store resulting rates as new column in table

# table3:
# add additional columns cases, population, numeric_rates that store values in numeric form
# populate cases column with substring of rates column, all chrs before / and converted into numeric form
# populate population column with substring of rates column, all chrs after / and converted into numeric form
# populate numeric_cases column with calculation of value in cases column divided by value in population column
