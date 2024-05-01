{
  library(tidyverse)
  library(babynames)
}

# regular expressions are used to describe patterns within strings

# str_view(string, reg_exp) shows elements in string vector that match reg_exp, 
# surrounding matched pattern with <> and highlighting match in blue
str_view(fruit, "berry")

# literal characters, e.g. letters and numbers, match exactly

# metacharacters, e.g. characters like .+*[]? have special functions
# . matches any character

# match the character 'a' followed by any character
str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

# match 'a', any three characters, then 'e'
str_view(fruit, "a...e")

# quantifiers control match numbers
# ? indicates optional pattern (match 0 or 1 times)
# + indicates repeating pattern (match 1 or more times)
# * combines both ? and + (match 0 or more times)

# match 'a' followed by 'b' 0 or 1 times
str_view(c("a", "ab", "abb"), "ab?")

# match 'a' followed by 'b' at least once
str_view(c("a", "ab", "abb"), "ab+")

# match 'a' followed by 'b' any number of times
str_view(c("a", "ab", "abb"), "ab*")

# character classes are marked by [] and allow matching within a character set
# invert match by starting with ^, e.g. [^abcd] matches not('a', 'b', 'c', 'd')

# match 'x' surrounded by vowels
str_view(words, "[aeiou]x[aeiou]")

# match 'y' surrounded by consonants
str_view(words, "[^aeiou]y[^aeiou]")

# specify alternation with | to pick between one or more patterns
str_view(fruit, "apple|melon|nut")

# match repeated vowels
str_view(fruit, "aa|ee|ii|oo|uu")

# str_detect() returns logical vector of the same length as the 
# character vector input, TRUE if pattern matched in string
str_detect(c("a", "b", "c"), "[aeiou]")

# str_detect() pairs well with filter()
babynames |> 
  filter(str_detect(name, "x")) |> 
  count(name, wt = n, sort = TRUE)

# can also be used with summarize() when paired with sum() or mean()
# sum(str_detect(x, pattern)) returns number of values with matching patterns
# mean(str_detect(x, pattern)) returns proportion of matches

# visualize proportion of names containing "x", by year
babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()

# str_subset() and str_which() are similar to str_detect()
# str_subset() returns a vector of strings in x that match the pattern
# str_which() returns a vector of positions of the strings that match

# str_count() returns the number of matches in each string
x <- c("apple", "banana", "pear")
str_count(x, "p")

# regex matches never overlap
str_count("abababa", "aba")
str_view("abababa", "aba")

# using str_count() to count vowels and consonants in each name
babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

# regular expressions are case sensitive, can fix behavior by
# fix matches by adding uppercase vowels to character class "[AEIOUaeiou]"
# specifying ignore_case = TRUE within str_count()
# convert names to lowercase with str_to_lower(name)
babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

# modify matches with str_replace() to replace first match
# str_replace_all() replaces all matches in string
str_replace_all(x, "[aeiou]", "-")

# str_remove() and str_remove_all() are similar to their
# replace versions but replace matches with blank strings
str_remove_all(x, "[aeiou]")

# separate_wider_regex() extracts data from one column into multiple columns
# takes a character vector and a sequence of regular expressions to match 
# named pieces in sequence will appear as columns in output
df <- tribble(
  ~str,
  "<Sheryl>-F_34",
  "<Kisha>-F_45",
  "<Brandon>-N_33",
  "<Sharon>-F_38",
  "<Penny>-F_58",
  "<Justin>-M_41",
  "<Patricia>-F_84"
)

# if match fails, use too_few = "debug" as with separate_wider_delim/position()
df |> 
  separate_wider_regex(
   str,
   patterns = c(
    "<",
    name = "[A-Za-z]+",
    ">-",
    gender = "[A-Z]",
    "_",
    age = "[0-9]+"
   )
  )

# -------------------------------------------------------------------------

# 1. what baby name has the most vowels? 
# What name has the highest proportion of vowels?

babynames |> 
  distinct(name) |>
  mutate(
    vowel_count = str_count(name, "[AEIOUaeiou]"),
    vowel_prop = vowel_count / length(name)
    ) |> 
  arrange(desc(vowel_prop))

# Mariaguadalupe and Mariadelrosario have the highest vowel count at 8
# and the highest vowel proportion at 0.0000822


# 2. Replace all forward slashes in "a/b/c/d/e" with backslashes. What happens
# if you attempt to undo the transformation by replacing all backslashes with
# forward slashes?

slashes <- "a/b/c/d/e"

backslashes <- str_replace_all(slashes, "/", "\\\\")
backslashes
str_view(backslashes)

forward_slashes <- str_replace_all(backslashes, "\\\\", "/")
forward_slashes
str_view(forward_slashes)


# 3. Implement a simple version of str_to_lower() using str_replace_all().
mixed <- "MiXeDcAsEsTrInG"
str_replace_all(
  mixed, 
  c(
    "A" = "a",
    "B" = "b", 
    "C" = "c",
    "D" = "d",
    "E" = "e",
    "F" = "f",
    "G" = "g",
    "H" = "h", 
    "I" = "i", 
    "J" = "j",
    "K" = "k", 
    "L" = "l",
    "M" = "m", 
    "N" = "n",
    "O" = "o", 
    "P" = "p",
    "Q" = "q", 
    "R" = "r",
    "S" = "s", 
    "T" = "t",
    "U" = "u", 
    "V" = "v",
    "W" = "w", 
    "X" = "x",
    "Y" = "y", 
    "Z" = "z"
  )
)


# 4. Create a regular expression that will match telephone numbers
# as commonly written in your country.

phone_number <- "The number is written 555-867-5309 in the phone book."
str_view(phone_number, "[0-9]{3}-[0-9]{3}-[0-9]{4}")
