{
  library("tidyverse")
  library("nycflights13")
}

# function names should be understandable by humans
# better to be clear than short, R's auto-complete is useful for long names

# generally, function names should be verbs and argument names should be nouns
# nouns are acceptable if very well known, e.g. mean()
# or if accessing object property, e.g. coef()

# function() should always be followed by curly braces
# contents should be indented by an additional two spaces
# put extra spaces within {{ }} to more clearly indicate embracing
density <- function(color, facets, binwidth = 0.1){
  diamonds |> 
    ggplot(aes(x = carat, y = after_stat(density), color = {{ color }})) + 
    geom_freqpoly(binwidth = binwidth) + 
    facet_wrap(vars({{ facets }}))
}
density(color, cut)

# -------------------------------------------------------------------------

# 1. Read the source code for each of the following functions, puzzle out
# what they do, and then brainstorm better names.

# returns TRUE if substring containing the first (len(prefix)) characters
# of string is the same string as prefix, else returns FALSE
# is_prefix(string, prefix)
f1 <- function(string, prefix){
  str_sub(string, 1, str_length(prefix)) == prefix
}
f1("hello", "123")
f1("world", "wo")

# recycle values in y until it is as long as x
# match_length(x, y)
f2 <- function(x, y){
  rep(y, length.out = length(x))
}
f2(c("a", "b", "c", "d", "e", "f", "g"), c(1, 4, 5))
f2(1:7, c("x", "y", "z"))


# 2. Take a function you've written recently and spend 5 minutes brainstorming
# a better name for it and its arguments.

# Function written for exercise at end of section 25.4 Plot functions
# generating a scatterplot for a given dataframe and x and y variables

# custom_plot -> titled_scatterplot
# y -> indep (independent variable)
# x -> dep (dependent variable)
titled_scatterplot <- function(df, dep, indep){
  label <- rlang::englue("Scatterplot of {{ y }} vs. {{ x }}")
  df |> 
    ggplot(aes(x = {{ dep }}, y = {{ indep }})) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) + 
    labs(title = label)
}


# 3. Make a case for why norm_r(), norm_d(), etc. would be better than
# rnorm(), dnorm(). Make a case for the opposite.
# How could you make the names even clearer?

# norm_*() standardizes the names with a prefix
# so they can be easily auto-completed from the same prefix norm

# keeping the names as is allows auto-completing for other distributions
# q* to specify quantile, auto-complete with gamma, norm, binom, etc.

# names could be made more clearer by fully writing them out as
# norm_density(), norm_distribution(), norm_quantile(), norm_random()
