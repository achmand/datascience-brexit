################################################################################################################
#
# Downloads data using web scraping (historical prices) from CoinMarketCap,
# from 01/05/2015 to 14/06/2019 data is downloaded for the following pairs:
#
# USD/BTC 
# USD/ETH 
#
################################################################################################################

# constants (source)
kBtc <- "https://coinmarketcap.com/currencies/bitcoin/historical-data/?start=20150501&end=20190614"
kEth <- "https://coinmarketcap.com/currencies/ethereum/historical-data/?start=20150501&end=20190614"

# constants (file names to persist)
kBtcFile <- "raw_events_btcusd.csv"
kEthFile <- "raw_events_ethusd.csv"

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

# scraping from coinmarketcap (usd/btc historical prices) 
collect.btc <- function() {
  # Gets historical data for USD/BTC from CoinMarketCap.
  #
  # Returns:
  #   Historical data as a dataframe.
  
  btc <- read_html(kBtc) # get page content
  btc.table <- as.data.frame(html_table(html_node(btc, ".table"))) # get the table element and convert to df

  # return prices dataframe taken from coinmarketcap (USD/BTC)
  return(btc.table)  
}

# scraping from coinmarketcap (usd/eth historical prices) 
collect.eth <- function() {
  # Gets historical data for USD/ETH from CoinMarketCap.
  #
  # Returns:
  #   Historical data as a dataframe.
  
  eth <- read_html(kEth) # get page content
  eth.table <- as.data.frame(html_table(html_node(eth, ".table"))) # get the table element and convert to df
  
  # return prices dataframe taken from coinmarketcap (USD/ETH)
  return(eth.table)  
}

# main function
main <- function() {
  # Main function to execute this script which collects data from coinmarketcap.
  
  # call setup function 
  setup() 
  
  # get price history from coinmarketcap  
  btc.table <- collect.btc() # USD/BTC 
  eth.table <- collect.eth() # USD/ETH 
  
  # save raw results scraped from coinmarketcap
  write.csv(btc.table, file=paste("data/raw/", kBtcFile))
  write.csv(eth.table, file=paste("data/raw/", kEthFile))
  
  # results saved
  print("Crypto historical data is downloaded from coinmarketcap and saved.")
}

main() # call main function to execute script 


