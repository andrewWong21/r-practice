{
  library("tidyverse")
  library("nycflights13")
}

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

# rows and columns of join output are primarily determined by x
# inner join matches rows between x and y with the same value for column key
inner_join(x, y)

# outer joins keep observations that appear in at least one data frame
# add additional "virtual" observation to data frame
# virtual key matches if no other key matches, value is NA

# left join keeps all rows of x
left_join(x, y)

#right join keeps all rows of y
right_join(x, y)

# full join has fallback row of NAs for both x and y
# output is all rows of x followed by unmatched rows of y
full_join(x, y)

# left/right/inner/full joins are equi-joins: match rows if keys are equal

# a row in x may have multiple matches in y
# if row has zero matches, row is dropped
# if row has one match, row is preserved
# if row has multiple matches, row is duplicated once for each match

df1 <- tibble(key = c(1, 2, 2), val_x = c("x1", "x2", "x3"))
df2 <- tibble(key = c(1, 2, 2), val_y = c("y1", "y2", "y3"))

# many-to-many joins can cause Cartesian explosion of rows in output
# dplyr outputs a warning if many-to-many behavior is not explicitly specified
df1 |> 
  inner_join(df2, join_by(key))

df1 |> 
  inner_join(
    df2, join_by(key),
    relationship = "many-to-many"
  )

# filtering joins do not duplicate rows as mutating joins do
# only the presence of a match, no matter how many, affects the output
semi_join(x, y)
anti_join(x, y)

semi_join(df1, df2)
anti_join(df1, df2)

# in equi joins, keys are always equal so only one copy is shown by default
# can specify keep = TRUE to show keys from both tables
x |> inner_join(y, join_by(key))
x |> inner_join(y, join_by(key), keep = TRUE)

# key values will often be different for non-equi joins
# dplyr will always show both keys when performing non-equi joins 

# dplyr provides four types of non-equi joins:
# cross joins match every pair of rows
# inequality joins use >, >=, <, <=
# rolling joins work like inequality joins but only find closest match
# overlap joins are inequality joins that work with ranges

# cross joins are useful for generating permutations
# output of cross_join(x, y) will have nrow(x) * nrow(y) rows

# cross-joining a data frame to itself is called a self-join
# generate every possible pair of names from a data frame
df <- tibble(name = c("John", "Simon", "Tracy", "Max"))
df |> cross_join(df)

# inequality joins are useful for restricting cross joins
# to generate combinations instead of permutations
df_1 <- tibble(id = 1:4, name = c("John", "Simon", "Tracy", "Max"))
df_1 |> inner_join(df_1, join_by(id < id))

# rolling joins return closest row that satisfies inequality
# turn inequality join into rolling join by using closest() within join_by()

# match smallest y >= x
x |> inner_join(y, join_by(closest(key <= key)))

# match largest y < x
x |> inner_join(y, join_by(closest(key > key)))

# useful in cases where two tables do not match up perfectly
# example: holding parties each quarter for birthdays
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03"))
)

set.seed(123)
employees <- tibble(
  name = sample(babynames::babynames$name, 100),
  birthday = ymd("2022-01-01") + sample(365, 100, replace = TRUE) - 1
)
employees

# find first party date that occurs on or before employee's birthday
employees |> 
  left_join(parties, join_by(closest(birthday >= party)))

# 2 employees have a birthday before first quarter's party
employees |> 
  anti_join(parties, join_by(closest(birthday >= party)))

# overlap joins provide three helper functions for interval shorthands
# between(x, y_lower, y_upper) is short for x >= y_lower, x <= y_upper
# within(x_lower, x_upper, y_lower, y_upper) is short for
# x >= x_lower, x <+ x_upper, y >= y_lower, y <= y_upper
# overlaps(x_lower, x_upper, y_lower, y_upper) is short for
# x_lower <= y_upper, x_upper >= y_lower

# more explicit definition of date ranges for parties
parties <- tibble(
  q = 1:4,
  party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
  start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
  end   = ymd(c("2022-04-03", "2022-07-10", "2022-10-02", "2022-12-31"))
)
parties

# check if party periods overlap and fix if needed
parties |> 
  inner_join(parties, join_by(overlaps(start, end, start, end), q < q)) |> 
  select(start.x, end.x, start.y, end.y)

# match employees to party
employees |>
  inner_join(
    parties, 
    join_by(between(birthday, start, end)), 
    unmatched = "error"
  )

# check if any employees were not matched to a party
employees |>
  anti_join(
    parties, 
    join_by(between(birthday, start, end))
  )

# -------------------------------------------------------------------------

# 1. Can you explain what's happening with the keys in this equi join?
# Why are they different?
x |> full_join(y, join_by(key == key))

# keeping both keys in the equi join reveals that
# the output row with key = 3 comes from x
# and the output row with key = 4 comes from y
x |> full_join(y, join_by(key == key), keep = TRUE)

# when keep = TRUE is not specified in an equi join,
# all keys are combined into the same column


# 2. When finding if any party period overlapped with another party period
# we used q < q in the join_by(). Why? What happens if you remove it?

# removing the inequality q < q detects matches with the same quarter
# which does not provide useful information,
# as an interval will always overlap with itself
parties |> 
  inner_join(parties, join_by(overlaps(start, end, start, end))) |> 
  select(start.x, end.x, start.y, end.y)

# using q < q allows identifying overlapping intervals
# only when they are in different quarters
parties |> 
  inner_join(parties, join_by(overlaps(start, end, start, end), q < q)) |> 
  select(start.x, end.x, start.y, end.y)
