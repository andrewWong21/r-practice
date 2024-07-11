# insert code block inside Quarto document by:
# keyboard shortcut Ctrl + Alt + I
# Insert button via visual editor
# typing chunk delimiters ```{r} ```

# run code in chunk with keyboard shortcut Ctrl + Shift + Enter
# chunk should be treated like a function -
# self-contained and focused on one task

# chunks can be given an optional label prefixed with #| label: [id]
# allows easy navigation via code navigator in script editor
# graphics produced by labeled chunks are given names for easier use
# chunks can be cached to avoid redoing expensive computations every time

# chunk label cannot contain spaces
# use dashes to separate words, avoid special characters

# label must be unique, chunk named setup has special behavior -
# chunk is run automatically once before all other code chunks

# customize chunk output with options
# full list of chunk options available at https://yihui.org/knitr/options/

# eval: false - disables evaluation of code
# useful for providing sample code or disabling a chunk

# include: false - runs code, does not output code or results to document 
# useful for setup code not meant to be read

# echo: false - only results of chunk will show up in final document
# useful for hiding code from audiences only interested in results

# message: false / warning: false
# suppress messages or warnings in final document

# results: hide - suppress printed output
# fig-show: hide - suppress plots

# error: true - continue running code even after error occurs in a chunk
# useful for debugging errors or teaching R with deliberate errors
# default setting is error: false - rendering fails on first error

# add chunk options on separate lines with #|
# e.g.
# | label: simple-multiplication
# | eval: false

# eval: false suppresses code evaluation, output, plots, messages, warnings
# include: false suppresses code display, output, plots, messages, warnings

# change default options for chunks by adding options under YAML header
# indented under execute: to set chunk options at document level

# title: "My report"
# execute:
#   echo: false

# Quarto uses different engines depending on programming language used
# can set global options for knitr under knitr: > opts_chunk:

# title: "Tutorial"
# knitr:
#   opts_chunk:
#     comment: "#>"
#     collapse: true

# can embed R code directly into text with `r `
# useful when mentioning data properties in text
# e.g. `r nrow(diamonds)`
# use format() to format numbers in text
# by setting precision with digits argument
# and making big numbers easier to read with big.mark argument

comma <- function(x) format(x, digits = 2, big.mark = ",")
comma(3452345)
comma(.12358124331)

# -------------------------------------------------------------------------

# 
