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
  eventsraw.ap <- readLines(paste("data/raw/", kApRawFile, sep="")) # load ap events
  eventsraw.ap <- gsub('["\\]', "", eventsraw.ap) # remove unwanted characters
  eventsraw.ap <- str_split_fixed(eventsraw.ap, ":", 2) # split dates and content 
  eventsdf.ap <- data.frame(eventsraw.ap[,1], eventsraw.ap[,2]) # create dataframe for ap events 
  # al jazzera
  eventsraw.jazzera <- readLines(paste("data/raw/", kJazzeraRawFile, sep="")) # load al jazzera events
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
  fxraw.gbpeur <- data.frame(read.csv(paste("data/raw/", kGbpEurRawFile, sep=""))) # load GBP/EUR raw data
  fxraw.gbpeur <- select(fxraw.gbpeur, X, close) # get only Date/Close using dplyr
  names(fxraw.gbpeur)[1] <- "date" # set column name for date
  names(fxraw.gbpeur)[2] <- "GBPEUR" # set column name for the close price GBP/EUR
  # GBP/USD
  fxraw.gbpusd <- data.frame(read.csv(paste("data/raw/", kGbpUsdRawFile, sep=""))) # load GBP/USD raw data 
  fxraw.gbpusd <- select(fxraw.gbpusd, X, close) # get only Date/Close using dplyr
  names(fxraw.gbpusd)[1] <- "date" # set column name for date
  names(fxraw.gbpusd)[2] <- "GBPUSD" # set column name for the close price GBP/USD
  # GBP/JPY
  fxraw.gbpjpy <- data.frame(read.csv(paste("data/raw/", kGbpJpyRawFile, sep=""))) # load GBP/USD raw data 
  fxraw.gbpjpy <- select(fxraw.gbpjpy, X, close) # get only Date/Close using dplyr
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
  # LOG RETURNS GBP/EUR
  fxlog.gbpeur <- diff(log(fx.rates$GBPEUR)) # calculate log return 
  fx.rates$GBPEURLOG <- c(NA, fxlog.gbpeur) # since lag one first element must be NA
  # LOG RETURNS GBP/USD 
  fxlog.gbpusd <- diff(log(fx.rates$GBPUSD)) # calculate log return 
  fx.rates$GBPUSDLOG <- c(NA, fxlog.gbpusd) # since lag one first element must be NA
  # LOG RETURNS GBP/JPY 
  fxlog.gbpjpy <- diff(log(fx.rates$GBPJPY)) # calculate log return 
  fx.rates$GBPJPYLOG <- c(NA, fxlog.gbpjpy) # since lag one first element must be NA
  
  # returns cleaned and augmented fx rates for three different pairs (GPB/EUR, GBP/USD, GBP/JPY) as a dataframe.
  return(fx.rates)
}

clean.crypto <- function() {
  # Cleans raw data for different crypto prices taken from yahoo finance.
  #
  # Returns:
  #   Cleaned dataframes as a list two different pairs (BTC/GBP, ETH/GBP).
  
  # load raw btc prices dataset from csv files
  crypto.btcgbp <- data.frame(read.csv(paste("data/raw/", kBtcRawFile, sep=""))) # load BTC/GBP raw data
  crypto.btcgbp <- select(crypto.btcgbp, X, close) # get only Date/Close using dplyr
  crypto.ethgbp <- data.frame(read.csv(paste("data/raw/", kEthRawFile, sep=""))) # load ETH/GBP raw data
  crypto.ethgbp <- select(crypto.ethgbp, X, close) # get only Date/Close using dplyr
  
  crypto.btcgbp$X <- gsub('X', "", crypto.btcgbp$X) # remove unwanted characters
  crypto.ethgbp$X <- gsub('X', "", crypto.ethgbp$X) # remove unwanted characters
  
  # duplicate rows have the same date but with this data format 'yyyy-mm-dd.1'
  # remove these rows 
  crypto.btcgbp <- crypto.btcgbp[nchar(crypto.btcgbp$X) == 10, ]  # dates string contains 10 char yyyy.mm.dd
  crypto.ethgbp <- crypto.ethgbp[nchar(crypto.ethgbp$X) == 10, ]  # dates string contains 10 char yyyy.mm.dd
  
  # change column names 
  names(crypto.btcgbp)[1] <- "date" # set column name for date
  names(crypto.btcgbp)[2] <- "BTCGBP" # set column name for the close price BTC/GBP
  names(crypto.ethgbp)[1] <- "date" # set column name for date
  names(crypto.ethgbp)[2] <- "ETHGBP" # set column name for the close price ETH/GBP

  # change date to be the same format 'yyyy-mm-dd'
  crypto.btcgbp[["date"]] <- ymd(crypto.btcgbp[["date"]])  
  crypto.ethgbp[["date"]] <- ymd(crypto.ethgbp[["date"]])  
  
  # compute log returns
  # LOG RETURNS BTC/GBP
  cryptolog.btcgbp <- diff(log(crypto.btcgbp$BTCGBP)) # calculate log return 
  crypto.btcgbp$BTCGBPLOG <- c(NA, cryptolog.btcgbp) # since lag one first element must be NA
  # LOG RETURNS ETH/GBP
  cryptolog.ethgbp <- diff(log(crypto.ethgbp$ETHGBP)) # calculate log return 
  crypto.ethgbp$ETHGBPLOG <- c(NA, cryptolog.ethgbp) # since lag one first element must be NA
  
  # returns cleaned crypto prices 
  return(list(crypto.btcgbp, crypto.ethgbp))
}

clean.indices <- function() {
  # Cleans raw data for different indices taken from ShareCast.
  #
  # Returns:
  #   Cleaned dataframes as a list two different indices (FTSE100, FTSE250).
  
  # load raw datasets
  index.ftse100 <- data.frame(read.csv(paste("data/raw/", kFtse100RawFile, sep=""))) # load FTSE100 raw data
  index.ftse250 <- data.frame(read.csv(paste("data/raw/", kFtse250RawFile, sep=""))) # load FTSE250 raw data
  index.ftse100 <- select(index.ftse100, "Date", "Close.Price") # get only Date/Close using dplyr
  index.ftse250 <- select(index.ftse250, "Date", "Close.Price") # get only Date/Close using dplyr
  
  # set column names
  names(index.ftse100)[1] <- "date" # set column name for date
  names(index.ftse100)[2] <- "FTSE100" # set column name for the close price FTSE
  names(index.ftse250)[1] <- "date" # set column name for date
  names(index.ftse250)[2] <- "FTSE250" # set column name for the close price FTSE
  
  # convert to standard format date 'yyyy-mm-dd'
  index.ftse100[["date"]] <- dmy(index.ftse100[["date"]])  
  index.ftse250[["date"]] <- dmy(index.ftse250[["date"]])  
  
  # compute log returns 
  # LOG RETURNS FTSE100
  indexlog.ftse100 <- diff(log(index.ftse100$FTSE100)) # calculate log return 
  index.ftse100$FTSE100LOG <- c(NA, indexlog.ftse100) # since lag one first element must be NA
  # LOG RETURNS FTSE250
  indexlog.ftse250 <- diff(log(index.ftse250$FTSE250)) # calculate log return 
  index.ftse250$FTSE250LOG <- c(NA, indexlog.ftse250) # since lag one first element must be NA
  
  # returns cleaned indices prices 
  return(list(index.ftse100, index.ftse250))
}

clean.commodities <- function() {
  # Cleans raw data for different commoditiy prices taken from Exchange Rates.
  #
  # Returns:
  #   Cleaned dataframes as a list two different commodities (XAU/GBP, OIL/GBP).
  
  # load raw datasets
  commodity.xau <- data.frame(read.csv(paste("data/raw/", kXauGbpRawFile, sep=""))) # load XAU/GBP raw data
  commodity.oil <- data.frame(read.csv(paste("data/raw/", kOilGbpRawFile, sep=""))) # load OIL/GBP raw data
  commodity.xau <- select(commodity.xau, "X1", "X3") # get only Date/Close using dplyr
  commodity.oil <- select(commodity.oil, "X1", "X3") # get only Date/Close using dplyr
  
  # set column names
  names(commodity.xau)[1] <- "date" # set column name for date
  names(commodity.xau)[2] <- "XAUGBP" # set column name for the close price XAU/GBP
  names(commodity.oil)[1] <- "date" # set column name for date
  names(commodity.oil)[2] <- "OILGBP" # set column name for the close price OIL/GBP
  
  # remove empty values 
  commodity.xau <- commodity.xau[commodity.xau$XAUGBP > 0, ] 
  commodity.oil <- commodity.oil[commodity.oil$OILGBP > 0, ] 
  
  # convert to standard format date 'yyyy-mm-dd'
  commodity.xau[["date"]] <- dmy(commodity.xau[["date"]])  
  commodity.oil[["date"]] <- dmy(commodity.oil[["date"]])  
  
  # sort by date for these datasets 
  commodity.xau <- commodity.xau[order(as.Date(commodity.xau$date, format="%d/%m/%Y")),]
  commodity.oil <- commodity.oil[order(as.Date(commodity.oil$date, format="%d/%m/%Y")),]
  
  # compute log returns 
  # LOG RETURNS XAU/GBP
  commoditylog.xau <- diff(log(commodity.xau$XAUGBP)) # calculate log return 
  commodity.xau$XAUGBPLOG <- c(NA, commoditylog.xau) # since lag one first element must be NA
  # LOG RETURNS OIL/GBP
  commoditylog.oil <- diff(log(commodity.oil$OILGBP)) # calculate log return 
  commodity.oil$OILGBPLOG <- c(NA, commoditylog.oil) # since lag one first element must be NA
  
  # returns cleaned commodity prices 
  return(list(commodity.xau, commodity.oil))
}

# main function
main <- function() {
  # Main function to execute this script which cleans raw data.
  
  # call setup function 
  setup() 
  
  # clean/augment brexit events data 
  events.brexit <- clean.events()
  write.csv(events.brexit, file = paste("data/cleansed/", kEventsFile, sep="")) # saved cleaned brexit events
  print("Brexit events raw datasets cleaned, augmented and results saved.") # results saved (brexit events)

  # clean/augment fx rates data
  fx.rates <- clean.fx()
  write.csv(fx.rates, file = paste("data/cleansed/", kFxRatesFile, sep="")) # saved cleaned fx rates
  print("Fx rates raw datasets cleaned and results saved.") # results saved (fx rates)

  # clean crypto currency prices 
  crypto <- clean.crypto()
  crypto.btc <- crypto[[1]]
  crypto.eth <- crypto[[2]]
  write.csv(crypto.btc, file = paste("data/cleansed/", kBtcFile, sep="")) # saved cleaned BTC/GBP prices
  write.csv(crypto.eth, file = paste("data/cleansed/", kEthFile, sep="")) # saved cleaned ETH/GBP prices
  print("Crypto prices raw datasets cleaned and results saved.") # results saved (crypto prices)
  
  # clean index prices 
  indices <- clean.indices()
  index.ftse100 <- indices[[1]]
  index.ftse250 <- indices[[2]]
  write.csv(index.ftse100, file = paste("data/cleansed/", kFtse100File, sep="")) # saved cleaned FTSE100 prices
  write.csv(index.ftse250, file = paste("data/cleansed/", kFtse250File, sep="")) # saved cleaned FTSE250 prices
  print("Indices prices raw datasets cleaned and results saved.") # results saved (indices prices)
  
  # clean commodity prices 
  commodities <- clean.commodities()
  commodity.xau <- commodities[[1]]
  commodity.oil <- commodities[[2]]
  write.csv(commodity.xau, file = paste("data/cleansed/", kXauFile, sep="")) # saved cleaned XAU/GBP prices
  write.csv(commodity.oil, file = paste("data/cleansed/", kOilFile, sep="")) # saved cleaned OIL/GBP prices
  print("Commodities prices raw datasets cleaned and results saved.") # results saved (commodities prices)
  
  # results saved
  print("All data cleaning finished.")
}

main() # call main function to execute script 

