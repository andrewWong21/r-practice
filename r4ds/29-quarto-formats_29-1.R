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

# other formats supported by Quarto:
# pdf, for Portable Document Format documents, requires installing LaTeX
# docx, for Microsoft Word documents
# odt, for OpenDocument Text documents
# rtf, for Rich Text Format documents
# gfm, for GitHub Flavored Markdown documents (.md)
# ipynb, for Jupyter Notebooks

# when outputting to html, option override with code: true 
# to hide code chunks by default but make them visible with a click
# format:
#   html:
#     code: true

# Quarto can be used to create presentations
# content of document is divided into slides separated by headers
# new slides begin at second level header ##
# first level header # indicate sections with centered section title slide

# Quarto supports presentation formats including
# revealjs (HTML), pptx (PowerPoint), beamer (PDF with LaTeX Beamer)
# read more at https://quarto.org/docs/presentations/
