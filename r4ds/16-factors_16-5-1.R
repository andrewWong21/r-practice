library("tidyverse")

# fct_recode allows changing the value for each level (recoding level values)
gss_cat |> count(partyid)

# renaming partyid levels to be less abbreviated (new = old)
gss_cat |> 
  mutate(
    partyid = fct_recode(partyid,
      "Republican, strong"    = "Strong republican",
      "Republican, weak"      = "Not str republican",
      "Independent, near rep" = "Ind,near rep",
      "Independent, near dem" = "Ind,near dem",
      "Democrat, weak"        = "Not str democrat",
      "Democrat, strong"      = "Strong democrat"
    )
  ) |> 
  count(partyid)

# fct_recode() does not require renaming all existing levels
# provides warning if old level name does not exist

# combine groups by assigning them to the same level
# grouping "No answer", "Don't know", "Other party" into "Other"
gss_cat |> 
  mutate(
    partyid = fct_recode(
      partyid,
      "Republican, strong"    = "Strong republican",
      "Republican, weak"      = "Not str republican",
      "Independent, near rep" = "Ind,near rep",
      "Independent, near dem" = "Ind,near dem",
      "Democrat, weak"        = "Not str democrat",
      "Democrat, strong"      = "Strong democrat",
      "Other"                 = "No answer",
      "Other"                 = "Don't know",
      "Other"                 = "Other party"
    )
  ) |> 
  count(partyid)

# fct_collapse() is useful for collapsing a lot of levels
gss_cat |> 
  mutate(
    partyid = fct_collapse(
      partyid,
      "other" = c("No answer", "Don't know", "Other party"),
      "rep"   = c("Strong republican", "Not str republican"),
      "ind"   = c("Ind,near rep", "Independent", "Ind,near dem"),
      "dem"   = c("Not str democrat", "Strong democrat")
    )
  ) |> 
  count(partyid)

# fct_lump_*() functions combine small groups to simplify plot or table

# fct_lump_lowfreq() combines smallest groups into "Other" category
# while keeping "Other" as the smallest category
# can result in oversimplification in extreme cases
gss_cat |> 
  mutate(relig = fct_lump_lowfreq(relig)) |> 
  count(relig)

# fct_lump_n() allows specifying number of groups
gss_cat |> 
  mutate(relig = fct_lump_n(relig, n = 10)) |> 
  count(relig, sort = TRUE)
  
# fct_lump_min() lumps levels appearing fewer than min times
# fct_lump_prop() lumps levels that appear in at most prop * n rows

# ordered factors imply strict ordering and equal distance between factors
# identified by < between factor levels when printing
ordered(c("a", "b", "c"))

# ordered factors mostly behave like regular factors aside from two areas:
# mapping ordered factor to color or fill in ggplot uses either
# scale_color_viridis() or scale_fill_viridis(), ranking-implied color scales
# using ordered factor in linear model uses polynomial contrasts

# consult https://forcats.tidyverse.org/reference/index.html
# for functions useful for factor analysis

# -------------------------------------------------------------------------

# 1. How have the proportions of people identifying as Democrat, Republican,
# and Independent changed over time?

parties <- gss_cat |> 
  select(year, partyid) |> 
  mutate(
    partyid = fct_collapse(
      partyid,
      "Other"       = c("No answer", "Don't know", "Other party"),
      "Republican"  = c("Strong republican", "Not str republican"),
      "Independent" = c("Ind,near rep", "Independent", "Ind,near dem"),
      "Democrat"    = c("Not str democrat", "Strong democrat")
    ),
  ) |> 
  count(year, partyid) |> 
  group_by(year) |> 
  mutate(
    prop = n / sum(n)
  )

parties |> 
  ggplot(
    aes(
      x = year, 
      y = prop, 
      color = fct_reorder2(partyid, year, prop)
    )
  ) + 
  geom_point() + 
  geom_line() + 
  labs(color = "partyid")


# 2. How could you collapse rincome into a small set of categories?

gss_cat |> count(rincome)

# collapsing rincome into ranges of $5000
rincomes_5k <- gss_cat |> 
  mutate(
    rincome = fct_collapse(
      rincome,
      "Less than $5000" = c(
        "Lt $1000", 
        "$1000 to 2999", 
        "$3000 to 3999",
        "$4000 to 4999"
      ),
      "$5000 to 9999" = c(
        "$5000 to 5999", 
        "$6000 to 6999",
        "$7000 to 7999",
        "$8000 to 9999"
      ),
      "Unknown" = c(
        "No answer",
        "Don't know",
        "Refused",
        "Not applicable"
      )
    )
  )

rincomes_5k |> count(rincome)

ggplot(rincomes_5k, aes(y = rincome)) + 
  geom_bar()

# collapsing rincome into ranges of $10000
rincomes_10k <- gss_cat |> 
  mutate(
    rincome = fct_collapse(
      rincome,
      "Less than $10,000" = c(
        "Lt $1000", 
        "$1000 to 2999", 
        "$3000 to 3999",
        "$4000 to 4999",
        "$5000 to 5999", 
        "$6000 to 6999",
        "$7000 to 7999",
        "$8000 to 9999"
      ),
      "$10,000 to 19,999" = c(
        "$10000 - 14999",
        "$15000 - 19999"
      ),
      "$20,000 or more" = c(
        "$20000 - 24999",
        "$25000 or more"
      ),
      "Unknown" = c(
        "No answer",
        "Don't know",
        "Refused",
        "Not applicable"
      )
    )
  )

rincomes_10k |> count(rincome)

ggplot(rincomes_10k, aes(y = rincome)) + 
  geom_bar()


# 3. Notice there are 9 groups (excluding other) in the fct_lump example above.
# Why not 10?

# 15 groups before lumping
gss_cat |> 
  count(relig, sort = TRUE)

# fct_lump_n() keeps the n most frequent, and lumps all other levels together
# under a new "Other" level for a total of n + 1 groups
# "Other" already exists in the data as one of the n most frequent levels
# so they are combined together (458 rows)
gss_cat |> 
  mutate(
    relig = fct_lump_n(relig, n = 10)
  ) |> 
  count(relig, sort = TRUE)

# changing the name of the level containing the levels lumped together
# shows that the "Other" level has 224 rows, while the new level created
# from the least frequent lumped levels contains the remaining 234 rows
gss_cat |> 
  mutate(
    relig = fct_lump_n(
      relig, n = 10, 
      other_level = "Least frequent levels combined")
  ) |> 
  count(relig, sort = TRUE)
