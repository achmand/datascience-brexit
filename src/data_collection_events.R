################################################################################################################
#
# downloads data using web scraping (brexit major events) from news agencies 
# data is downloaded from the following sources: BNN Bloomberg/Associated Press & AlJazzera.
# events are taken from 2 different articles describing brexit major events.
#
# BNN Bloomberg/Associated Press: https://www.bnnbloomberg.ca/timeline-of-brexit-and-events-leading-to-may-s-departure-1.1270161
# AlJazzera: https://www.aljazeera.com/news/2019/01/brexit-timeline-190115164043103.html
#
################################################################################################################

# constants (sources)
kAp <- "https://www.bnnbloomberg.ca/timeline-of-brexit-and-events-leading-to-may-s-departure-1.1270161" # published on 7 June 2019
kJazzera <- "https://www.aljazeera.com/news/2019/01/brexit-timeline-190115164043103.html" # published on 15 January 2019

# constants (file names to persist)
kApFile <- "raw_events_ap.csv"
kJazzeraFile <- "raw_events_aljazzera.csv"

# setup function 
setup <- function () {
  # Sets up the script, loads libraries and sources.
  
  # install.packages("rstudioapi") # run this if package not installed
  library(rstudioapi) # load package (to set a 'relative' path)
  current.dir <- dirname(getActiveDocumentContext()$path) # get current directory 
  setwd(current.dir) # set working directory to the current directory
  source("miscellaneous.R") # source miscellaneous functions
  
  # install/load libraries 
  # rvest: for web scraping
  lubripack("rvest")
}

# scraping from associated press article/source 
collect.apnews <- function() {
  # Gets key brexit events from timeline posted in an article on Associated Press.
  #
  # Returns:
  #   Vector of strings of brexit key events from Associated Press.
  
  apnews <- read_html(kAp) # get page content
  apnews.content <- html_node(apnews, ".article-text") # select div with specified class
  apnews.entries <- html_text(html_nodes(apnews.content, "p")) # get the events which are in a p element
  apnews.events <- apnews.entries[2:length(apnews.entries)] # we skip first element since it is not an event
  
  # return brexit key events taken from associated press
  return(apnews.events)
}

# scraping from al jazzera article/source 
collect.jazzera <- function() {
  # Gets key brexit events from timeline posted in an article on Al Jazzera.
  #
  # Returns:
  #   Vector of strings of brexit key events from Al Jazzera.
  
  jazzera <- read_html(kJazzera) # get page content
  jazzera.content <- html_node(jazzera, ".article-p-wrapper") # select div with specified class
  jazzera.events <- html_text(html_nodes(jazzera.content, "h3")) # get the events which are in a h3 element
  
  # return brexit key events taken from associated press
  return(jazzera.events)
}

# main function
main <- function() {
  # Main function to execute this script which collects data from various news agencies.
  
  # call setup function 
  setup() 
  
  # get brexit key events from various news agencies 
  apnews.events <- collect.apnews() # get from associated press 
  jazzera.events <- collect.jazzera() # get from al jazzera 
  
  # save raw results scraped from various news agencies
  write.table(apnews.events, file= paste("data/", kApFile), row.names=FALSE, col.names=FALSE, eol="\n")
  write.table(jazzera.events, file= paste("data/", kJazzeraFile), row.names=FALSE, col.names=FALSE, eol="\n")
}

main() # call main function to execute script 



