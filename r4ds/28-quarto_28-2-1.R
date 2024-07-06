# Quarto combines code, results, and writing into one document

# communicate with decision makers by providing conclusions
# collaborate with data scientists by providing code with conclusions
# use as an environment for performing data science

# command-line tool, refer to documentation at https://quarto.org/

# three types of content in Quarto document
# optional YAML header surrounded by ---
# R code chunks surrounded by ```
# text with simple text formatting 

# switch between inline and console chunk rendering if needed

# render document to produce report with code, results, and text

# rendering process:
# .qmd file is sent to knitr, executes code chunks and 
# creates .md file with code and output
# .md file is sent to pandoc, creates finished file
# which may be in different formats (.doc, .pdf, .html, etc.)

# create .qmd file via File > New File > New Quarto Document

# add #| echo: false to R chunk to suppress source code
# and only display output when rendering

# -------------------------------------------------------------------------

# 1. Create a new Quarto document using File > New File > New Quarto Document.
# Read the instructions. Practice running the chunks individually. Then render
# the document by clicking the appropriate button and then by using the 
# appropriate keyboard shortcut. Verify that you can modify the code,
# re-run it, and see modified output.

# Quarto works similar to Jupyter notebook, run chunks of code and edit text


# 2. Create one new Quarto document for each of the three built-in formats:
# PDF, HTML, and Word. Render each of the three documents.
# How do the inputs and outputs differ?

# .html output is also previewed in browser
# outputting to .pdf requires tinytex package and calling install_tinytex()

library("tinytex")
install_tinytex()
