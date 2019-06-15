################################################################################################################
#
#
################################################################################################################

# setup function 
setup <- function () {
  # Sets up the script, loads libraries and sources.
  
  # source miscellaneous functions
  source("miscellaneous.R") 
  
  # install/load libraries 
  # stringr: string manipulation
  # lubridate: datetime conversion
  lubripack("stringr", "lubridate") 
}

clean.events <- function () {
  # Cleans and augments raw data taken from various news agencies as a dataframe.
  
  # load both events datasets from csv files
  # associated press
  eventsraw.ap <- readLines(paste("data/raw/", kApRawFile)) # load ap events
  eventsraw.ap <- gsub('["\\]', "", eventsraw.ap) # remove unwanted characters
  eventsraw.ap <- str_split_fixed(eventsraw.ap, ":", 2) # split dates and content 
  eventsdf.ap <- data.frame(eventsraw.ap[,1], eventsraw.ap[,2]) # create dataframe for ap events 
  # al jazzera
  eventsraw.jazzera <- readLines(paste("data/raw/", kJazzeraRawFile)) # load al jazzera events
  eventsraw.jazzera <- gsub('["\\]', "", eventsraw.jazzera) # remove unwanted characters
  eventsraw.jazzera <- str_split_fixed(eventsraw.jazzera, ":", 2) # split dates and content 
  eventsdf.jazzera <- data.frame(eventsraw.jazzera[,1], eventsraw.jazzera[,2]) # create dataframe for al jazzera events 
  
  # set column names 
  # associated press
  names(eventsdf.ap)[1] <- "event_date"
  names(eventsdf.ap)[2] <- "event_desc"
  # al jazzera
  names(eventsdf.jazzera)[1] <- "event_date"
  names(eventsdf.jazzera)[2] <- "event_desc"
  
  # remove any empty rows 
  eventsdf.ap <- eventsdf.ap[!(is.na(eventsdf.ap$event_desc) | eventsdf.ap$event_desc==""), ] # associated press 
  eventsdf.jazzera <- eventsdf.jazzera[!(is.na(eventsdf.jazzera$event_desc) | eventsdf.jazzera$event_desc==""), ] # al jazzera 
  
  # convert dates to keep a consistent format (yyyy-mm-dd)
  eventsdf.ap[["event_date"]] <- mdy(eventsdf.ap[["event_date"]]) # associated press 
  eventsdf.jazzera[["event_date"]] <- mdy(eventsdf.jazzera[["event_date"]]) # al jazzera 
  
  # combine both dataframes (augment events dataset)
  # take all instances in associated press and combine with al jazzera
  # if data already exists in associated press do not append 
  eventsdf.tmp <- subset(eventsdf.jazzera, !(event_date %in% eventsdf.ap$event_date)) # get subset where not in associated press 
  eventsdf.merged <- rbind(eventsdf.ap, eventsdf.tmp) # append/merge both dfs
  eventsdf.merged <- eventsdf.merged[order(eventsdf.merged$event_date),] # re sort by date
  row.names(eventsdf.merged) <- 1:nrow(eventsdf.merged) # re index row number 
  
  # only get past events not upcoming events 
  eventsdf.merged <- eventsdf.merged[year(eventsdf.merged$event_date) <= 2019, ] # up to 2019
  
  # returns cleaned and augmented brexit key events taken from two sources as a df
  return(eventsdf.merged)
}

# main function
main <- function() {
  # Main function to execute this script which cleans raw data.
  
  # call setup function 
  setup() 
  
  # clean brexit events data 
  events.brexit <- clean.events()
  write.csv(events.brexit, file = paste("data/cleansed/", kEventsFile)) # saved cleaned brexit events
  print("Brexit events raw datasets cleaned, augmented and results saved.") # results saved (brexit events)

  # results saved
  print("All data cleaning finished.")
}

main() # call main function to execute script 



