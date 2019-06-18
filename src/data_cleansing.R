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
  lubripack("stringr", "lubridate", "dplyr") 
}

clean.events <- function () {
  # Cleans and augments raw data taken from various news agencies as a dataframe.
  #
  # Returns:
  #   Cleaned and augmented brexit key events taken from two sources as a dataframe.

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
  eventsdf.merged <- eventsdf.merged[date(eventsdf.merged$event_date) <= date("2019-06-01"), ] # up to June 19
  
  # returns cleaned and augmented brexit key events taken from two sources as a df
  return(eventsdf.merged)
}

clean.fx <- function() {
  # Cleans and augments raw data for different fx rates taken from yahoo finance.
  #
  # Returns:
  #   Cleaned and augmented fx rates for three different pairs (GPB/EUR, GBP/USD, GBP/JPY) as a dataframe.
  
  # load fx rates datasets from csv files
  # GBP/EUR 
  fxraw.gbpeur <- data.frame(read.csv(paste("data/raw/", kGbpEurRawFile))) # load GBP/EUR raw data
  fxraw.gbpeur <- select(fxraw.gbpeur, X, GBPEUR.X.Close) # get only Date/Close using dplyr
  names(fxraw.gbpeur)[1] <- "date" # set column name for date
  names(fxraw.gbpeur)[2] <- "GBPEUR" # set column name for the close price GBP/EUR
  # GBP/USD
  fxraw.gbpusd <- data.frame(read.csv(paste("data/raw/", kGbpUsdRawFile))) # load GBP/USD raw data 
  fxraw.gbpusd <- select(fxraw.gbpusd, X, GBPUSD.X.Close) # get only Date/Close using dplyr
  names(fxraw.gbpusd)[1] <- "date" # set column name for date
  names(fxraw.gbpusd)[2] <- "GBPUSD" # set column name for the close price GBP/USD
  # GBP/JPY
  fxraw.gbpjpy <- data.frame(read.csv(paste("data/raw/", kGbpJpyRawFile))) # load GBP/USD raw data 
  fxraw.gbpjpy <- select(fxraw.gbpjpy, X, GBPJPY.X.Close) # get only Date/Close using dplyr
  names(fxraw.gbpjpy)[1] <- "date" # set column name for date
  names(fxraw.gbpjpy)[2] <- "GBPJPY" # set column name for the close price GBP/JPY
  
  # augment all closing prices into one 
  # create dataframe (date, GBP/EUR, GBP/USD, GBP/JPY)
  fx.rates <- data.frame(fxraw.gbpeur$date, fxraw.gbpeur$GBPEUR, fxraw.gbpusd$GBPUSD, fxraw.gbpjpy$GBPJPY)
  names(fx.rates)[1] <- "date" # set column name for date
  names(fx.rates)[2] <- "GBPEUR" # set column name for the close price GBP/EUR
  names(fx.rates)[3] <- "GBPUSD" # set column name for the close price GBP/USD
  names(fx.rates)[4] <- "GBPJPY" # set column name for the close price GBP/JPY
  
  # only keep rows which do not have an NA value
  fx.rates <- fx.rates[!is.na(fx.rates$GBPEUR) & !is.na(fx.rates$GBPUSD) & !is.na(fx.rates$GBPJPY), ] 
  
  # calculate log returns for each pair 
  # LOG GBP/EUR
  fxlog.gbpeur <- diff(log(fx.rates$GBPEUR)) # calculate log return 
  fx.rates$GBPEURLOG <- c(NA, fxlog.gbpeur) # since lag one first element must be NA
  # LOG GBP/USD 
  fxlog.gbpusd <- diff(log(fx.rates$GBPUSD)) # calculate log return 
  fx.rates$GBPUSDLOG <- c(NA, fxlog.gbpusd) # since lag one first element must be NA
  # LOG GBP/JPY 
  fxlog.gbpjpy <- diff(log(fx.rates$GBPJPY)) # calculate log return 
  fx.rates$GBPJPYLOG <- c(NA, fxlog.gbpjpy) # since lag one first element must be NA
  
  # returns cleaned and augmented fx rates for three different pairs (GPB/EUR, GBP/USD, GBP/JPY) as a dataframe.
  return(fx.rates)
}

# main function
main <- function() {
  # Main function to execute this script which cleans raw data.
  
  # call setup function 
  setup() 
  
  # clean/augment brexit events data 
  events.brexit <- clean.events()
  write.csv(events.brexit, file = paste("data/cleansed/", kEventsFile)) # saved cleaned brexit events
  print("Brexit events raw datasets cleaned, augmented and results saved.") # results saved (brexit events)

  # clean/augment fx rates data 
  fx.rates <- clean.fx()
  write.csv(fx.rates, file = paste("data/cleansed/", kFxRatesFile)) # saved cleaned fx rates
  print("Fx rates raw datasets cleaned, augmented and results saved.") # results saved (fx rates)
  
  # results saved
  print("All data cleaning finished.")
}

main() # call main function to execute script 

