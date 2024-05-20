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


# -------------------------------------------------------------------------


