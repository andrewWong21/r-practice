{
  library("tidyverse")
  library("babynames")
}

# str_c() returns a character vector given a list of arguments
str_c("x", "y")
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))
str_c(c("Here", "There"), " it is")

# str_c() obeys tidyverse rules for recycling and propagating missing values
df <- tibble(name = c("Flora", "David", "Terra", NA))
df |> mutate(greeting = str_c("Hi ", name, "!"))

# use coalesce() to change how missing values should be displayed
# can be used inside or outside str_c() depending on desired output
df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
  )

# using str_c() can require a lot of "s, making code less readable
# using str_glue() allows replacing values inside curly brackets {}
df |> mutate(str_glue("Hi {name}!"))

# specify .na = NULL to make missing value behavior consistent with str_c()
df |> mutate(str_glue("Hi {name}!", .na = NULL))

# to include curly brackets in string within str_glue(), double up {}
df |> mutate(str_glue("{{Hi {name}!}}", .na = NULL))

# output of str_c() and str_glue() is the same length as their inputs
# str_flatten() takes a character vector and combines them into a single string
str_flatten(c("x", "y", "z"))
str_flatten(c("x", "y", "z"), ", ")
str_flatten(c("x", "y", "z"), ", ", last = ", and ")

# str_flatten works well with summarize()
# while str_c() and str_glue work well with mutate()
df2 <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)

df2 |> 
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ", "))

# -------------------------------------------------------------------------

# 1. Compare and contrast the results of paste0() with str_c()
# for the following inputs:

# paste0() converts missing values to the string "NA"
# while str_c() propagates missing values to output
str_c("hi", NA)
paste0("hi", NA)

# str_c() uses tidyverse recycling rules, can only recycle single values
# paste0() uses base R recycling rules, recycling the shorter vector
str_c(letters[1:2], letters[1:3])
paste0(letters[1:2], letters[1:3])


# 2. What's the difference between paste() and paste0()? How can you recreate
# the equivalent of paste() with str_c()?

# paste separates each input with a space while paste0 does not
paste(c("1","2","3"), "apples")
paste0(c("1","2","3"), "apples")

# paste() can be recreated with str_c() by specifying sep = " "
str_c(c("1","2","3"), "apples", sep = " ")


# 3. Convert the following expressions from str_glue() to str_c() or vice versa:

food <- "bread"
price <- "$5"
c1 <- str_c("The price of ", food, " is ", price)
g1 <- str_glue("The price of {food} is {price}")

str_view(c1)
str_view(g1)

age <- 24
country <- "United States"
g2 <- str_glue("I'm {age} years old and live in {country}")
c2 <- str_c("I'm ", age, " years old and live in ", country)

str_view(c2)
str_view(g2)

title <- "R for Data Science"
c3 <- str_c("\\section{", title, "}")
g3 <- str_glue("\\section{{{title}}}")

str_view(c3)
str_view(g3)
