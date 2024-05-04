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

# finding all sentences that contain the colors red, green, or blue
str_view(sentences, "\\b(red|green|blue)\\b")

# storing colors in vector that can be expanded as needed
# and creating full pattern using str_c() and str_flatten()
rgb <- c("red", "green", "blue")
str_c("\\b(", str_flatten(rgb, "|"), ")\\b")

# building a list of colors from non-numbered built-in colors in R
str_view(colors())
cols <- colors()
cols <- cols[!str_detect(cols, "\\d")]
str_view(cols)

color_pattern <- str_c("\\b(", str_flatten(cols, "|"), ")\\b")
str_view(sentences, color_pattern)

# tidyverse usages for regex:
# matches(pattern) selects all variables with pattern-matching names
# can be used with functions like select(), rename_with(), across()
# 
# pivot_longer() has a name_pattern argument that takes regex vectors
# 
# delim argument in separate_longer_delim() and separate_wider_delim()
# can be used with regex to match patterns

# base R uses for regex:
# apropos(pattern) searches global environment for objects matching pattern
apropos("replace")

# base R uses slightly different pattern language compared to stringr
# difference only becomes apparent with more advanced features

# -------------------------------------------------------------------------

# 1. For each of the following challenges, try solving it using both
# a single regular expression and a combination of str_detect() calls.

# Find all words that start or end with x.
str_view(words, "^x|x$")
words[str_detect(words, "^x") | str_detect(words, "x$")]

# Find all words that start with a vowel and end with a consonant.
str_view(words, "^[aeiou].+[^aeiou]$")
words[str_detect(words, "^[aeiou]") & !str_detect(words, "[aeiou]$")]

# Are there any words that contain at least one of each different vowel?
words[
  str_detect(words, "a") &
  str_detect(words, "e") &
  str_detect(words, "i") &
  str_detect(words, "o") &
  str_detect(words, "u")
]


# 2. Construct patterns to find evidence for and against the rule
# "i before e except after c".

# evidence for rule:
# words with c-e-i consecutively
str_view(words, "cei")
# words with i before e when not after c
str_view(words, "[^c]ie")

# evidence against:
# words with c-i-e consecutively
str_view(words, "cie")
# words with i after e  when not after c
str_view(words, "[^c]ei")


# 3. colors() contains a number of modifiers like "lightgray" and "darkblue".
# How could you automatically identify these modifiers?

modified <- c("pale", "medium", "light", "dark")
colors()[str_detect(colors(), str_flatten(modified, "|"))]


# 4. Create a regular expression that finds any base R dataset.
sets <- data(package = "datasets")$results[, "Item"]
# capture everything before " ("
stripped <- str_match(sets, "(.*) \\(")[,2]
stripped <- str_replace(stripped, "\\.", "\\\\.")

# 
dataset_regex <- str_flatten(
  c(
    stripped[!is.na(stripped)], 
    sets[!str_detect(sets, "\\(")]
  ),
  "|"
)

str_view("beaver2 freeny.y freeny state.x77 state.abb", dataset_regex)
