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
# params:
#   my_class: "suv"

# use params in code by treating params as named list
# ```r class <- mpg |> filter(class == params$my_class)```

# can run arbitrary R expressions with !expr prefix before parameter
# params:
#   start: !expr lubridate::ymd("2015-01-01")
#   snapshot: !expr lubridate::ymd_hms("2015-01-01 12:30:00")

# use visual editor to add citations and bibliographies
# Insert > Citation to add citations from various sources
# including DOI, Zotero, Crossref, DataCite, PubMed

# representation for citations is [@citation], e.g. [@doe99]
# visual editor creates and updates bibliography.bib file with citations
# bibliography field is also added to YAML header with path to file

# separate multiple citations with semicolon [@doe99; @smith04]
# add comments inside brackets [see @doe99, ch. 1, pp. 33-35]
# drop brackets for in-text citation: As mentioned in @doe99, ...
# prefix citation with - to suppress author name if mentioned in text [-@doe99]

# Quarto appends bibliography to end of document when rendering
# containing cited references from bibliography file without a section heading
# common practice to end document with custom section header for bibliography

# specify citation style with csl field (Citation Style Language)
# .csl file may or may not be in the same directory as the .qmd file
# get CSL style files from https://github.com/citation-style-language/styles
# bibliography: rmarkdown.bib
# csl: apa.csl
 