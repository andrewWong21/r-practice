# can embed figures in Quarto document or generate them from a code chunk

# embed image from external file using visual editor
# Insert > Figure / Image, browse to image on disk
# adjust size and add alternative text or caption to image
# can also paste image from clipboard
# RStudio creates copy of image in project folder

# code chunks that generate figures will automatically 
# put figures in Quarto document once rendered

# five main options for controlling figure sizing
# fig-width, fig-height, fig-asp, out-width, out-height

# figures are more aesthetically pleasing with consistent width
# set fig-width: 6 and fig-asp: 0.618 in default settings
# all figures will have default width of 6 inches
# and default aspect ratio of 0.618 (golden ratio)
# adjust fig-asp in individual chunks

# control output size with out-width
# set out-width: 70% and fig-align: center
# width of output figures will be 70% of output document body width
# and figures will be aligned to center of document

# put n plots in a single row by setting layout-ncol: n
# equivalent to setting out-width: (100 / n)% for each plot

# tweak fig-width to change size of text in plots
# if fig-width is larger than figure size in final document,
# text will be too small since the figure is scaled down
# if fig-width is too small, text will be scaled too large
# experiment with fig-width and resulting width in document

# set fig-show: hold to show plots after code
# encourages breaking up large code blocks with explanations

# use fig-cap to add caption to plot

# default graphics type when producing PDF output is PDF
# produces very large and slow plots if thousands of points are displayed
# force use of PNGs with fig-format: "png"
# reduces quality but makes plots more compact

# name code chunks that produce figures, label is used for graphic filename
# gives plots more descriptive filenames for reuse (e.g. in e-mails)

# -------------------------------------------------------------------------


# 1. Open diamond-sizes.qmd in the visual editor, find an image of a diamond, 
# copy it, and paste it into the document. Double click on the image and 
# add a caption. Resize the image and render your document. Observe how the 
# image is saved in your current working directory.

# file is saved as fig-smaller-diamonds-1.png


# 2. Edit the label of the code chunk in diamond-sizes.qmd that generates
# a plot to start with the prefix fig- and add a caption to the figure with
# the chunk option fig-cap. Then, edit the text above the code chunk to add a 
# cross-reference to the figure with Insert > Cross Reference.


# 3. Change the size of the figure with the following chunk options, 
# one at a time, render your document, and describe how the figure changes.

# fig-width: 10
# figure is wider, text is smaller

# fig-height: 3
# figure is slightly shorter compared to default

# out-width: "100%"
# figure is larger, maintains same aspect ratio as default

# out-width: "20%"
# figure is shrunken to 1/5th the width of the document, very hard to read
