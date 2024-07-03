library("tidyverse")

# [] selects many elements, [[]]/$ extract a single element

# [[]] and $ can be used to extract columns from data frame
tb <- tibble(
  x = 1:4,
  y = c(10, 4, 1, 21)
)

# [[]] can access by position or name
tb[[1]]
tb[["x"]]

# $ is specialized for access by name
tb$x

# can use $ to create new columns, similar to mutate()
tb$z <- tb$x + tb$y
tb

# $ is convenient for getting quick summaries without using summarize()
max(diamonds$carat)
levels(diamonds$cut)

# dplyr provides equivalent to $ and [[]] in the form of pull()
# pull() takes variable name or position and returns column specified
diamonds |> pull(carat) |> max()
diamonds |> pull(cut) |> levels()

# data.frame matches prefix of variable after $
# returns NULL if column does not exist
df <- data.frame(x1 = 1)
df$x
df$z

# tibbles are more strict, only match variable names exactly
# returns NULL and generates warning if column does not exist
tib <- tibble(x1 = 1)
tib$x
tib$z

# [[]] and $ are important for working with lists
my_list <- list(
  a = 1:3,
  b = "a string",
  c = pi,
  d = list(-1, 5)
)

# [] (one pair) extracts a sublist, result is always a list
str(my_list[1:2])
str(my_list[1])
str(my_list[2])
str(my_list[4])

# can subset with a logical, character, or integer vector
str(my_list[c(TRUE, TRUE, TRUE, FALSE)])
str(my_list[c("c", "d")])
str(my_list[c(4, 2, 1, 3)])

# [[]] and $ extract a single component, removing a level of hierarchy
str(my_list[[1]])
str(my_list[[4]])
str(my_list$a)

# [[]] drills down into list while [] returns a smaller list


# -------------------------------------------------------------------------

# 1. What happens if you use [[]] with a positive integer
# that's bigger than the length of the vector?
# What happens when you subset with a name that doesn't exist?

# [[]] generates an error if the subscript is out of bounds
x <- c("one", "two", "three", "four", "five")
x[[6]]

# generates the same error if the name does not exist
z <- c(abc = 1, def = 2, xyz = 5)
z[["ghi"]]


# 2. What would pepper[[1]][1] be? What about pepper[[1]][[1]]?

# `pepper` is a pepper shaker containing pepper packets
# `pepper[[1]]` is the first packet
# `pepper[[1]][1]` is a pepper packet containing one granule
# `pepper[[1]][[1]]` is one granule in the first packet

pepper <- list(
  packet1 = list("pep11", "pep12", "pep13"), 
  packet2 = list("pep21", "pep22")
)
str(pepper)
str(pepper[[1]])
str(pepper[[1]][1])
str(pepper[[1]][[1]])
