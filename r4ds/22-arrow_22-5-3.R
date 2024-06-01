{
  library("tidyverse")
  library("arrow")
  library("dbplyr", warn.conflicts = FALSE)
  library("duckdb")
}

# csv format is simple and human-readable, but not very efficient for reading
# parquet format is widely used by big data systems
# use Apache Arrow via arrow package to utilize dplyr backend
# 

dir.create("data", showWarnings = FALSE)

# get 9GB CSV file with over 40 million rows
# detailing item checkouts from Seattle libraries
# from April 2005 to October 2022

# curl::multi_download(
#   "https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv",
#   "data/seattle-library-checkouts.csv",
#   resume = TRUE
# )

# ideally have at least twice much memory as the size of the data
# use arrow::open_dataset() instead of read_csv()

# open_dataset() scans a few thousand rows to figure out dataset structure
# need to specify column type for ISBN as it is blank for first 80k rows
seattle_csv <- open_dataset(
  sources = "data/seattle-library-checkouts.csv",
  col_types = schema(ISBN = string()),
  format = "csv"
)
# print metadata of dataset
seattle_csv

# 41 million rows, 12 columns, and some values in each column
# 3 int64 columns, 9 string columns
seattle_csv |> glimpse()
