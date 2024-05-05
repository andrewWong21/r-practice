library("tidyverse")

# factors are used for categorical variables with a fixed set of possible values
# provides support for ordering character vectors in non-alphabetical order

# recording months in a string variable has two issues:
# no protection against typos, no meaningful sorting
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")
sort(x1)

# create a factor by specifying list of valid levels
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", 
  "May", "Jun", "Jul", "Aug", 
  "Sep", "Oct", "Nov", "Dec"
)

# displaying factor shows values 
y1 <- factor(x1, month_levels)
y1
sort(y1)

# values not in level are converted to NA
y2 <- factor(x2, month_levels)
y2

# sorting a factor drops NA
sort(y2)

# forcats::fct() throws an error if value does not exist in levels
y2 <- fct(x2, month_levels)

# omitting levels when using factor() orders variable in alphabetical order
factor(x1)

# forcats::fct() orders by earliest appearance instead
fct(x1)

# levels() provides access to set of values
levels(y1)

# readr provides col_factor() for creating a factor when reading in data
csv <- "
month,value
Jan,12
Feb,56
Mar,12"

df <- read_csv(csv, col_types=cols(month = col_factor(month_levels)))
df$month

# forcats::gss_cat contains sample of survey answers for General Social Survey
gss_cat

# view factor levels stored in a tibble with count()
gss_cat |> 
  count(marital)
gss_cat |> 
  count(race)
gss_cat |> 
  count(rincome)
gss_cat |> 
  count(partyid)
gss_cat |> 
  count(relig)
gss_cat |> 
  count(denom)


# -------------------------------------------------------------------------

# 1. Explore the distribution of rincome (reported income). What makes the 
# default bar chart hard to read? How could you improve the plot?

# The default bar chart is hard to read because the labels overlap.
ggplot(gss_cat, aes(x = rincome)) + 
  geom_bar()

# The plot can be made more readable by flipping the axes.
ggplot(gss_cat, aes(x = rincome)) + 
  geom_bar() +
  coord_flip()


# 2. What is the most common relig in this survey?
# What is the most common partyid?

# The most common religion in this survey is Protestant.
gss_cat |> 
  count(relig, sort = TRUE)

# The most common partyid in this survey is Independent.
gss_cat |> 
  count(partyid, sort = TRUE)


# 3. What relig does denom (denomination) apply to?
# How can you find out with a table?
# How can you find out with a visualization?

# values of denomination that are not in the set
# "Not applicable", "No denomination", "Don't know", "No answer"
# all belong to the religion "Protestant"

gss_cat |> 
  filter(!denom %in% c("Not applicable", "No answer")) |> 
  count(relig, denom, sort = TRUE) |> 
  print(n = Inf)

# all other values of denom not in the set
# "Not applicable", "No denomination", "Don't know", "No answer"
# correspond to the relig "Protestant" only
gss_cat |> 
  filter(denom != "Not applicable") |>
  ggplot(aes(x = relig)) + 
  geom_count(aes(y = denom))
