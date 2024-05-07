library("tidyverse")

relig_summary <- gss_cat |> 
  group_by(relig) |> 
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

# resulting plot of religion and mean hours of TV watched is difficult to read
# due to y-axis being unordered
ggplot(relig_summary, aes(x = tvhours, y = relig)) +
  geom_point()

# fct_reorder(.f, .x) reorders factor .f given numerical values in vector .x
# optional argument .fun, can be specified if multiple values of .x correspond
# to a factor in .f, default is median()

# people who answered "Don't know" watch the most TV
ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) + 
  geom_point()

# more complicated transformations may require
# specifications in mutate() instead of aes()
relig_summary |> 
  mutate(
    relig = fct_reorder(relig, tvhours)
  ) |> 
  ggplot(aes(x = tvhours, y = relig)) + 
  geom_point()


# viewing variation of average age and reported income
rincome_summary <- gss_cat |> 
  group_by(rincome) |> 
  summarize(
    age = mean(age, na.rm = TRUE),
    n = n()
  )

# rincome has principled order, so reordering is not recommended
# fct_reorder() should be used on arbitrarily-ordered factors instead
ggplot(rincome_summary, aes(x = age, y = fct_reorder(rincome, age))) + 
  geom_point()

ggplot(rincome_summary, aes(x = age, y = rincome)) + 
  geom_point()

# fct_relevel() moves specified levels to front
# takes factor .f and any number of factors to move to front
ggplot(
  rincome_summary, 
  aes(x = age, y = fct_relevel(rincome, "Not applicable"))
) +
  geom_point()

# fct_reorder2(.f, .x, .y) is useful for coloring lines on plot, 
# reordering factor .f by .y values for largest .x values
# results in legend colors matching with lines on the right of the plot
by_age <- gss_cat |> 
  filter(!is.na(age)) |> 
  count(age, marital) |> 
  group_by(age) |> 
  mutate(
    prop = n / sum(n)
  )

ggplot(by_age, aes(x = age, y = prop, color = marital)) +
  geom_line(linewidth = 1) + 
  scale_color_brewer(palette = "Set1")

ggplot(
  by_age, 
  aes(x = age, y = prop, color = fct_reorder2(marital, age, prop))
) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") + 
  labs(color = "marital") 

# bar plots can be ordered by decreasing frequency with fct_infreq()
# or by increasing frequency by combining fct_infreq() and fct_rev()
gss_cat |>
  mutate(marital = marital |> fct_infreq()) |>
  ggplot(aes(x = marital)) +
  geom_bar()

gss_cat |>
  mutate(marital = marital |> fct_infreq() |> fct_rev()) |>
  ggplot(aes(x = marital)) +
  geom_bar()

# -------------------------------------------------------------------------

# 1. There are some suspiciously high numbers in tvhours.
# Is mean a good summary?

# The mean is not a good summary statistic for tvhours due to outliers. 
gss_cat |> 
  count(tvhours) |> 
  arrange(desc(tvhours))

ggplot(gss_cat, aes(x = tvhours)) + 
  geom_boxplot()

# # # Graphing median hours of TV watched by religion shows that people who
# answered "Don't know" have the lowest median hours.
gss_cat |> 
  group_by(relig) |> 
  summarize(
    med_hours = median(tvhours, na.rm = TRUE),
    n = n()
  ) |> 
  ggplot(aes(x = med_hours, y = fct_reorder(relig, med_hours))) + 
  geom_point()


# 2. For each factor in gss_cat determine whether the order of the levels is
# arbitrary or principled.

# factor columns: marital, race, rincome, partyid, relig, denom
# marital: principled (never married -> married)
gss_cat |> count(marital)

# race: principled. ordered by number of occurrences
gss_cat |> count(race)

# rincome: principled, ordered by quantity when applicable
gss_cat |> count(rincome)

# partyid: principled, ordered by party affiliation when applicable
gss_cat |> count(partyid)

# relig: arbitrary
gss_cat |> count(relig)

# denom: arbitrary
gss_cat |> count(denom)


# 3. Why did moving "Not applicable" to the front of the levels move it to
# the bottom of the plot?

# factors on the y-axis are plotted bottom-to-top,
# so factors at the front are plotted near the bottom
gss_cat |> 
  count(fct_relevel(rincome, "Not applicable"))
