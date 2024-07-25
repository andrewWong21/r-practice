# can set output of Quarto document by modifying YAML header
# format: html

# or calling quarto::quarto_render() and setting output_format argument
quarto::quarto_render("diamond-sizes.qmd", output_format = "docx")

# output_format can take a list of values, producing multiple output types
quarto::quarto_render(
  "diamond-sizes.qmd",
  output_format = c("html", "docx", "pdf")
)

# list of output formats supported by Quarto available at
# https://quarto.org/docs/output-formats/all-formats.html

# options may be shared between formats or format-specific

# override default format options by using expanded format field
# format:
#   html:
#     toc: true
#     toc_float: true

# can supply list of formats in header
# use [format]: default to keep default options
# format:
#   html: 
#     toc: true
#     toc_float: true
#   pdf: default
#   docx: default

# use output_format = "all" to render formats specified in YAML header
quarto::quarto_render("diamond-sizes.qmd", output_format = "all")
