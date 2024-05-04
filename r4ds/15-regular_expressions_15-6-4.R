{
  library(tidyverse)
  library(babynames)
}

# flags control details of regular expressions
# wrap pattern in call to regex()
# set ignore_case = TRUE to match different cases
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

# dotall makes . match everything, including newline characters
x <- "Line1\nLine2\nLine3"
str_view(x, ".Line")
str_view(x, regex(".Line", dotall = TRUE))

# multiline = TRUE makes ^ and $ work per line instead of on the entire string
str_view(x, "^Line")
str_view(x, regex("^Line", multiline = TRUE))

# use comments = TRUE to use comments and whitespace to separate characters
# and break up expression into lines with with comments marked by #
# match spaces, newlines, and # with \ as needed
phone <- regex(
  r"(
    \(?     # optional opening parens
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)
str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)

# opt out of regular expression rules with fixed()
str_view(c("", "a", "."), fixed("."))

# ignoring case with fixed()
str_view("x X", "X")
str_view("x X", fixed("X", ignore_case = TRUE))

# use coll() with non-English text instead, allows specifying locale
str_view("i İ ı I", fixed("İ", ignore_case = TRUE))
str_view("i İ ı I", coll("İ", ignore_case = TRUE, locale = "tr"))


# three techniques for solving problems
# 1. check work with simple positive and negative controls
# 2. combine regular expressions with Boolean algebra
# 3. create complex patterns with string manipulation

# finding all sentences that start with the word "The"
str_view(sentences, "^The\\b")

# finding all sentences that begin with a pronoun
str_view(sentences, "^(She|He|It|They)\\b")

# create some positive/negative matches to test pattern works as expected
pos <- c("He is a boy", "She had a good time")
neg <- c("Shells come from the sea", "Hadley said 'It's a great day'")
pattern <- "^(She|He|It|They)\\b"
str_detect(pos, pattern)
str_detect(neg, pattern)

# find words that only contain consonants
str_view(words, "^[^aeiou]+$")

# simpler: find words that do not contain vowels
str_view(words[!str_detect(words, "[aeiou]")])

# finding all words that contain "a" and "b"
str_view(words, "a.*b|b.*a")

# simpler: combine results of two str_detect() calls
words[str_detect(words, "a") & str_detect(words, "b")]

# checking for a word that contains all vowels
words[
  str_detect(words, "a") &
  str_detect(words, "e") &
  str_detect(words, "i") &
  str_detect(words, "o") &
  str_detect(words, "u")
]

# -------------------------------------------------------------------------
