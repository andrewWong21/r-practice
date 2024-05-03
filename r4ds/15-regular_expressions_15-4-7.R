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

# parentheses also create capturing groups that can be back-referenced
# \1 refers to first captured group, \2 is second, etc.

# find all fruits with repeated pairs of letters
str_view(fruit, "(..)\\1")

# find all words that start and end with the same pair of letters
str_view(words, "^(..).*\\1$")

# using back-references in str_replace() to swap 2nd and 3rd words in sentences
sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

# str_match() returns matches in the form of a matrix
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  head()

# converting to tibble and naming columns effectively recreates
# the function of separate_wider_regex()
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  as_tibble(.name_repair = "minimal") |> 
  set_names("match", "word1", "word2")

# use parentheses without creating capturing group by using (?:)
g <- c("a gray cat", "a grey dog")
str_match(g, "gr(e|a)y")
str_match(g, "gr(?:e|a)y")

# -------------------------------------------------------------------------

# 1. How would you match the following literal strings?

# ".\
qdb <- r"{aaa".\bbb}"
str_view(qdb, "\"\\.\\\\")
str_view(qdb, r"{".\\}")

# $^$
dcd <- "aaa$^$bbb"
str_view(dcd, "\\$\\^\\$")
str_view(dcd, r"{\$\^\$}")


# 2. Explain why each of these patterns don't match a literal backslash:

backslash <- "\\"
str_view(backslash, "\\\\")

# "\"
# invalid string, backslash escapes ending quote

# "\\"
# invalid regex, escaped backslash is read as metacharacter in regex

# "\\\"
# invalid string, third backslash escapes ending quote


# 3. Given the corpus of common words in stringr::words,
# create regular expressions to find words that match the following patterns:

# start with y
str_view(words, "^y")

# don't start with y
str_view(words, "^[^y]")

# end with x
str_view(words, "x$")

# are exactly 3 letters long (without using str_length)
str_view(words, "^\\w{3}$")

# have seven letters or more
str_view(words, "^\\w{7,}$")

# contain a vowel-consonant pair
str_view(words, "[aeiou][^aeiou]")

# contain at least two vowel-consonant pairs in a row
str_view(words, "([aeiou][^aeiou])\\1")

# only consist of repeated vowel-consonant pairs
str_view(words, "^([aeiou][^aeiou])\\1*$")


# 4. Create 11 regexps that match the British or American spellings for:

# airplane/aeroplane
str_view(c("airplane", "aeroplane"), "a(ir|ero)plane")

# aluminum/aluminium
str_view(c("aluminum", "aluminium"), "alumini?um")

# analog/analogue
str_view(c("analog", "analogue"), "analog(ue)?")

# ass/arse
str_view(c("ass", "arse"), "a(ss|rse)")

# center/centre
str_view(c("center", "centre"), "cent(er|re)")

# defense/defence
str_view(c("defense", "defence"), "defen(s|c)e")

# donut/doughnut
str_view(c("donut", "doughnut"), "do(ugh)?nut")

# gray/grey
str_view(c("gray", "grey"), "gr(a|e)y")

# modeling/modelling
str_view(c("modeling", "modelling"), "defen(s|c)e")

# skeptic/sceptic
str_view(c("skeptic", "sceptic"), "s(k|c)eptic")

#summarize/summarise
str_view(c("summarize", "summarise"), "summari(z|s)e")


# 5. Switch the first and last letters in words.
# Which of those strings are still words?

words[words %in% str_replace(words, "^(.)(.*)(.)$", "\\3\\2\\1")]


# 6. Describe what the following regular expressions match:

# <^.*$>
# matches any character 0 or more times (any string)
str_view(c("", "a", "aa", "ab", "aaa"), r"{^.*$}")

# "\\{.+\\}"
# matches curly brackets surrounding at least one or more characters
str_view(c("{}", "{abc}", "{ab}", "{def}{gh}"), "\\{.+\\}")

# <\d{4}-\d{2}-\d{2}>
# matches group of 4 digits, 2 digits, 2 digits separated by dashes
str_view(
  c("1234-56-78", "123-45-67", "111111-11-11-111-11-1"), 
  r"{\d{4}-\d{2}-\d{2}}"
)

# "\\\\{4}"
# matches four literal backslashes
str_view(c(r"{\\\\}", r"{\\\\\\}", "\\\\\\\\\\"), "\\\\{4}")

# <\..\..\..>
# matches three dots each followed by one character
str_view(c(".a.b.c", "d.e.f.gh.i.j.k" ), r"{\..\..\..}")

# <(.)\1\1>
# matches any character that is repeated three times
str_view(c("aaa", "bb", "ccccc", "dddddd", "abc"), r"{(.)\1\1}")

# "(..)\\1"
# matches a group of any two characters repeated twice
str_view(c("aaaa", "abab", "abcd", "1212121212"), "(..)\\1")


# 7. Solve the beginner regexp crosswords at
# https://regexcrosswords.com/challenges/beginner

# HELP, BOBE, OOOO, **//, 1984
