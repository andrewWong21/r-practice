# troubleshooting Quarto documents can be difficult
# due to differences from interactive R environment

# issues could be located in R code within document, or Quarto document itself

# duplicated chunk labels can cause issues after copying and pasting chunks
# rename duplicated label so all labels are unique

# recreate problems in interactive session to find problems in R code
# restart R then run all chunks with Ctrl + Alt + R shortcut

# explore working directory by calling getwd() within code chunk

# troubleshoot chunks by including error: true option
# and using print() and str() to verify expected code behavior

# Quarto uses YAML to control details of output document
# tweak parameters of YAML header to control other document settings
# YAML - YAML Ain't Markup Language, designed for 
# easily human-readable/writeable representations of hierarchical data

# HTML documents often have external dependencies in the form of
# images (JPG, PNG, etc.), stylesheets (CSS), and scripts (JS)
# Quarto places dependencies in _files folder in same directory as .qmd
# dependencies are published with document when published on hosting platform

# format:
#   html:
#     embed-resources: true
# creates a self-contained file that does not require external files
# or internet access to be displayed properly in a browser
# convenient form for sharing reports with others via email

# include parameters in report which set values for inputs when running code
# declare parameter using params field

# use params in code by treating params as named list

# params:
#   my_class: "suv"

# ```r class <- mpg |> filter(class == params$my_class)```