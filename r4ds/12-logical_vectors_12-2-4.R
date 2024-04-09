{
  library("tidyverse")
  library("nycflights13")
}

# transformations to free-floating vectors can also be
# performed on variables within dataframes
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

df <- tibble(x)
df |> 
  mutate(y = x * 2)

# filter() uses a transient logical vector to find rows with conditions
# find all daytime flights that arrived roughly on time
flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

# mutate can create explicit logical variables
flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  )

# showing intermediate steps can make for better readability and error checking

flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used"
  ) |> 
  filter(daytime & approx_ontime)



# -------------------------------------------------------------------------

# 1. How does dplyr::near() work? Type near to see the source code.
# Is sqrt(2)^2 near 2?

# 2. Use mutate(), is.na(), and count() together to see how the missing values
# in dep_time, sched_dep_time, dep_delay are connected.
