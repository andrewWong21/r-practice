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
