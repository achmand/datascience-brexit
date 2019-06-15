# setup function 
setup <- function () {
  # Sets up the script, loads libraries and sources.
  
  # install.packages("rstudioapi") # run this if package not installed
  library(rstudioapi) # load package (to set a 'relative' path)
  current.dir <- dirname(getActiveDocumentContext()$path) # get current directory 
  setwd(current.dir) # set working directory to the current directory
  source("miscellaneous.R") # source miscellaneous functions
  
  # install/load libraries 
  lubripack("gridExtra", "grid") 
}

setup()

# visualise data 
#df.events <- data.frame(read.csv(paste("data/cleansed/", kEventsFile)))
#grid.table(df.events)
sessionInfo()