# use option cache: true for saving results of long computations to speed up
# document rendering instead of starting from clean slate every time 

# cache can be enabled at document level to cache results from all chunks
# execute:
#   cache: true

# or at chunk level to save results from specific chunks only
# # | cache: true
# output of chunk will be saved to specially named file on disk
# knitr checks if code has changed since last run, else reuses cached results

# caching is by default based on code only, not dependencies

# consider chunk with label A that uses variable defined in chunk B
# if code in A changes, A is re-run
# changing variable in B does not result in A being re-run

# use option dependson for this behavior
# | label: processed-data
# | cache: true
# | dependson: "raw-data"

# list every chunk that cached chunk depends on
# as a character vector in dependson
# results of chunk are updated when change is detected in a dependency

# knitr caching only detects changes within .qmd
# use cache.extra option to track changes to files used by chunks
# file.mtime() returns when file was last modified

# | cache.extra: !expr file.mtime("large_file.csv")

# recommended to name chunks after the primary objects they create
# makes dependson more intuitive when viewing dependencies

# use knitr::clean_cache() to clear cache
# when working with and testing more complicated cache pipelines

# after renaming or removing cached code chunks, run within code chunk
# knitr::clean_cache(FALSE) to check possibly no longer needed files
# then run knitr::clean_cache(TRUE) to delete listed files

# -------------------------------------------------------------------------

