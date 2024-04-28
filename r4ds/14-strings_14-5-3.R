{
  library("tidyverse")
  library("babynames")
}

# four tidyr functions for extracting multiple variables from a single string
# df |> separate_longer_delim(col, delim)
# df |> separate_longer_position(col, width)
# df |> separate_wider_delim(col, delim, names)
# df |> separate_wider_position(col, widths)

# _longer makes data frames longer by creating new rows
# _wider makes data frames wider by creating new columns
# delim splits up string with given delimiter, e.g. ", " or " "
# position splits at specified widths, e.g. c(3, 5, 2)

# separating into rows is most useful when number of components
# varies from row to row, commonly splitting on a delimiter
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")

# use of separate_longer_position is less common
# can be used with older datasets where each character encodes a value
df2 <- tibble(x = c("1211", "131", "121"))
df2 |> 
  separate_longer_position(x, width = 1)

# separating string into columns is useful when each string has
# a fixed number of components that can be spread into columns
# the columns to be created require names
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )

# can use NA to omit components from results
df3 |> 
  separate_wider_delim(
    x, 
    delim = ".",
    names = c("code", NA, "year")
  )

# separate_wider_position() takes a named integer vector
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA"))
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )

# omit columns by not giving names to components
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, 2, state = 2)
  )

# separate_wider_delim() provides debugging mode when rows do not have the
# expected number of components to fit 

df5 <- tibble(x= c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))

# error provides suggestions to diagnose problem or suppress message
df5 |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

# debug mode provides three extra columns - input vector suffixed with 
# _ok, _pieces, _remainder
debug <- df5 |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "debug"
  )
debug

# filtering to col_ok = FALSE shows problem rows
# col_pieces shows number of found inputs, different from expected
# col_remainder is not useful when there are too few
debug |> filter(!x_ok)

# too_few = "align_start" and too_few = "align_end" change position of NAs
df5 |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
  )

df5 |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_end"
  )

df6 <- tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))
df6 |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z")
  )

# debugging when there are too many pieces shows purpose of col_remainder
# extra pieces are shown in col_remainder
df6 |> 
  separate_wider_delim(
    x, 
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "debug"
  )

# options for handling too many pieces:
# drop extra pieces
df6 |> 
  separate_wider_delim(
    x, 
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "drop"
  )

# merge extra pieces into last column
df6 |> 
  separate_wider_delim(
    x, 
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"
  )

# str_length() gives the number of letters in a string
str_length(c("a", "R for data science", NA))

# combine with count() to find the distribution of lengths of US babynames
# and with filter() to find the longest names
babynames |> 
  count(length = str_length(name), wt = n)

babynames |> 
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)

# extract parts of a string using str_sub(string, start, end)
# returns string of length end - start + 1
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

# use negative values to count back from end
str_sub(x, -3, -1)

# str_sub() will return as much as possible instead of failing on short strings
str_sub("a", 1, 5)

# use str_sub() and mutate() to find first and last letter of each name
babynames |> 
  mutate(
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )

# -------------------------------------------------------------------------

# 1. When computing the distribution of the length of babynames,
# why did we use wt = n?

# wt = n sums up the values in the column n to count the number of times
# a name was used in each year to get a more accurate view of distribution

# not specifying wt only counts the number of rows with names of a given length
# without counting how many times the names occurred in each year

babynames |> 
  count(str_length(name) == 2)

babynames |> 
  filter(str_length(name) == 2) |> 
  summarize(sum(n))

babynames |> 
  count(length = str_length(name))

babynames |> 
  count(length = str_length(name), wt = n)


# 2. Use str_length() and str_sub() to extract the middle letter from each
# baby name. What will you do if the string has an even number of characters?

# if name has even number of characters, extract middle 2 letters

babynames |> 
  mutate(
    length = str_length(name),
    middle = if_else(
      length %% 2 == 0, 
      str_sub(name, length %/% 2, length %/% 2 + 1), 
      str_sub(name, length %/% 2 + 1, length %/% 2 + 1)
    ),
    .keep = "used"
  )

# 3. Are there any trends in the length of babynames over time? 
# What about the popularity of first and last letters?

babynames |> 
  group_by(year) |> 
  summarize(
    avg_len = mean(str_length(name))
  ) |> 
  ggplot(aes(x = year, y = avg_len)) + 
  geom_line()

first <- babynames |> 
  group_by(year) |> 
  count(str_sub(name, 1, 1), wt = n)
