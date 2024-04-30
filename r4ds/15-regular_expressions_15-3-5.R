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

# -------------------------------------------------------------------------


