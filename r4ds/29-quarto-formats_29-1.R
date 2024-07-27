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

# interactive components can be included within HTML documents
# htmlwidgets and Shiny are two options for providing these elements

# htmlwidgets is a package that provides functions
# for creating interactive visualizations

# details are wrapped inside package
# no prior experience with HTML or JavaScript is needed to use widgets

# dygraphs for interactive visualizations of time series data
# DT for interactive tables
# threeJS for interactive 3D plots
# DiagrammeR for graph diagrams like flow charts and node-link diagrams

# htmlwidgets provide client-side interactivity
# allows for HTML distribution without connections to R
# but limits capabilities to HTML and JavaScript

# Shiny allows for server-side interactivity via R
# add server: shiny to YAML header to call Shiny code
# use input functions to add interactive components

# requires a public-facing Shiny server to publish and run online
# private server is automatically set up when running on own computer
# read more about Shiny at https://mastering-shiny.org/
