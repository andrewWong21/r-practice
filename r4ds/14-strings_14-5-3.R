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







# -------------------------------------------------------------------------

# 1. 
