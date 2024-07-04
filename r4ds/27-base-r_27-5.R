library("tidyverse")

# apply and map families use for loops under the hood
# most straightforward use of for loops is to achieve same effect as walk()

paths |> walk(append_file)

# is equivalent to

for (path in paths){
  append_file(path)
}

# saving output of for loop requires additional steps
paths <- dir("data/gapminder", pattern = "\\.xlsx$", full.names = TRUE)
# files <- map(paths, readxl::read_excel)

# create list with same length as paths
files <- vector("list", length(paths))

# iterate over indices of paths instead of elements of paths
# generate one index for each element with seq_along()
seq_along(paths)

# link positions in input with corresponding position in output
for (i in seq_along(paths)){
  files[[i]] <- readxl::read_excel(paths[[i]])
}

# combine list of tibbles with do.call() and rbind()
# execute function call with list of arguments to pass to it
do.call(rbind, files)

# alternatively, build data frame iteratively
# this approach can be slow for long vectors
out <- NULL
for (path in paths){
  out <- rbind(out, readxl::read_excel(path))
}

# base R also provides plotting functions, concise plotting with vectors
# get columns from dataframe in vector form with [[]], $, or pull()
# create scatterplots with plot(), histograms with hist()
hist(diamonds$carat)
plot(diamonds$carat, diamonds$price)
