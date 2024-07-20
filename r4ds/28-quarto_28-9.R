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
