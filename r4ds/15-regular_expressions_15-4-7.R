{
  library(tidyverse)
  library(babynames)
}

# escape metacharacters to treat them like literals
dot <- "\\."
dot
str_view(dot)

# match the character "."
str_view(c("abc", "a.c", "bef"), "a\\.c")

# \ is an escape character, match literal \ with regexp <\\>
# to write regexp <\\> backslashes must be escaped within string - "\\\\"
x <- "a\\b"
str_view(x)
str_view(x, "\\\\")

# regexp with literal backslashes can also be written with raw strings
# to reduce one layer of escaping
str_view(x, r"{\\}")

# instead of escaping with \ to match literal .+*|$?{}()
# use character class to match literal values by wrapping character with []
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

# anchors specify matching a pattern at the start or end of a string
# use ^ to match the start and $ to match the end
str_view(fruit, "^a")
str_view(fruit, "a$")

# use both ^ and $ to match entire string
str_view(fruit, "apple")
str_view(fruit, "^apple$")

# match boundary between words with \b, useful for find-and-replace in RStudio
y <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(y, "sum")
str_view(y, "\\bsum")
str_view(y, "sum\\b")
str_view(y, "\\bsum\\b")

# anchors produce zero-width match when used alone
str_view("abc", c("^", "$", "\\b"))

# this allows for prefixing/suffixing replacements
str_replace_all("abc", c("^", "$", "\\b"), "--")

# character classes allow for matching characters in a set
# wrap characters in a set with []
# - defines a range between two characters, e.g. [a-z] or [0-9]
# use \ to escape special characters within a set
# e.g. [\^\-\]] matches the literals ^ or - or ]
z <- "abcd ABCD 12345 -!@#%."

# greedy match characters a, b, c
str_view(z, "[abc]+")
# greedy match lowercase characters
str_view(z, "[a-z]+")
# greedy match non-lowercase and non-digits
str_view(z, "[^a-z0-9]+")

# use \ to escape special characters within []

# match lowercase letters a, b, c
str_view("a-b-c", "[a-c]")

# match the literal characters a, -, c
str_view("a-b-c", "[a\\-c]")

# some common character classes have their own shortcut
# \d matches any digit, \d matches any non-digit
str_view(z, "\\d+")
str_view(z, "\\D+")

# \s matches whitespace, \S matches non-whitespace
str_view(z, "\\s+")
str_view(z, "\\S+")

# \w matches word characters (alphanumeric), \w matches non-alphanumeric
str_view(z, "\\w+")
str_view(z, "\\W+")

# quantifiers specify how many times to match a pattern
# ?, +, and * specify 0 or 1, 1 or more, 0 or more matches respectively
# for more exact numbers, use {} to specify minimum/maximum numbers

dna <- "GCATCAAAATGGGGCCCCTAAGGAAACCTGGTTGTAAAAACCCT"

# {n} matches exactly n times
str_view(dna, "C{4}")

# {n,} matches at least n times
str_view(dna, "G{2}")

# {n, m} matches between n and m times
str_view(dna, "A{2,5}")

# operator precedence changes how regular expressions are evaluated
# quantifiers have high precedence and alternation has low precedence
# use () to override usual order, improve readability, reduce ambiguity
abc_strs <- c("a", "ab", "ac", "abb", "abc", "acb", "abab")

# "ab+" matches a followed by b 1 or more times, equivalent to "a(b+)"
str_view(abc_strs, "ab+")

# "(ab)+" matches ab 1 or times
str_view(abc_strs, "(ab)+")

# "^a|b$" matches strings starting with a or ending with b
# equivalent to "(^a)|(b$)"
str_view(abc_strs, "^a|b$")

# -------------------------------------------------------------------------

# 1. How would you match the following literal strings?

# ".\

# $^$


# 2. Explain why each of these patterns don't match a literal backslash:

# "\"

# "\\"

# "\\\"


# 3. Given the corpus of common words in stringr::words,
# create regular expressions to find words that match the following patterns:

# start with y

# don't start with y

# end with x

# are exactly 3 letters long (without using str_length)

# have seven letters or more

# contain a vowel-consonant pair

# contain at least two vowel-consonant pairs in a row

# only consist of repeated vowel-consonant pairs
