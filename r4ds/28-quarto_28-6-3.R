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

# -------------------------------------------------------------------------


