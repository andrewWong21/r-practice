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

# use collect() to perform computation with arrow
# takes some time to run, can be made faster with different data format
seattle_csv |> 
  group_by(CheckoutYear) |> 
  summarize(Checkouts = sum(Checkouts)) |> 
  arrange(CheckoutYear) |> 
  collect()

# parquet is a custom binary format for handling big rectangular data
# has more efficient encodings compared to csv files, making them smaller
# can store data type along with data (csv files must guess string or date)
# column-oriented like data frames in R, improving data analysis performance
# files are "chunked" - can work on different parts at the same time

# disadvantage - no longer human-readable

# best partitioning depends on data, access patterns, and reading systems
# do experimenting to find which process works best
# arrow recommends file sizes >20 MB and <2 GB, avoid producing 10,000+ files
# additionally, partition by variables to be filtered by
# to avoid reading irrelevant files

# partitioning large dataset across many files
# partition seattle_csv by CheckoutYear, producing 18 chunks
# define partition with dplyr::group_by() and saving partitions
# to directory with arrow::write_dataset(path, format)

# pq_path <- "data/seattle-library-checkouts"
# seattle_csv |> 
#   group_by(CheckoutYear) |> 
#   write_dataset(pq_path, format = "parquet")

# rewrote 9GB csv file into 18 parquet files of 100-300 MB each, ~4GB total
tibble(
  files = list.files(pq_path, recursive = TRUE),
  size_MB = file.size(file.path(pq_path, files)) / 1024^2
)
