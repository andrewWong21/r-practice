# two types of tables possible in Quarto document
# Markdown tables created via Insert Table in visual editor
# tables created from code chunks

# Quarto prints tables as shown in console
mtcars[1:5, ]

# can add formatting with knitr::kable() function
knitr::kable(mtcars[1:5, ])

# other packages for formatting tables:
# gt, huxtable, kableExtra, xtable, stargazer, pander, tables, ascii

# -------------------------------------------------------------------------

# 1. Open diamond-sizes.qmd in the visual editor, add a code chunk, and
# add a table with knitr::kable() that shows the first 5 rows of the
# diamonds data frame.

# 2. Display the same table with gt::gt() instead.

# 3. Add a chunk label that starts with the prefix tbl- and add a caption to
# the table with the chunk option tbl-cap. Then, edit the text above the code 
# chunk to add a cross-reference to the table with Insert > Cross Reference.
