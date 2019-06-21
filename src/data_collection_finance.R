################################################################################################################
#
# Gets Finance data from Yahoo Finance (Web API) and exchangerates.org.uk (web scrapping)
#
################################################################################################################

# constants (dates for any financial data which will be collected/downloaded)
# data format yyyy-mm-dd
kFromDate = "2012-01-01"
kToDate = "2019-06-01"

# setup function 
setup <- function () {
  # Sets up the script, loads libraries and sources.
  
  # source miscellaneous functions
  source("miscellaneous.R") 
  
  # install/load libraries 
  # quantmod: for fx exchange rates
  # rvest: for web scraping
  lubripack("quantmod", "rvest")
}

collect.yahoofinance <- function(symbol, fromDate, toDate) {
  # Gets asset prices from yahoo finance.
  #
  # Args:
  #   symbol: Symbol/Ticker to fetch from yahoo finance.
  #   fromDate: Date from used when fetching historical prices (yyyy-mm-dd).
  #   toDate: Date to used when fetching historical prices (yyyy-mm-dd).
  #
  # Returns:
  #   Dataframe with the historical prices for the specified arguments.
  
  # get prices data with the specified arguments from yahoo
  yahoo.data <- getSymbols(symbol, src = "yahoo", from = fromDate, to = toDate, auto.assign = FALSE)
  data <- as.data.frame(yahoo.data) # convert to dataframe
  
  # change column names
  colnames(data) <- c("open", "high", "low", "close", "volume", "adjusted_close")
  
  # return historical price data as dataframe taken from yahoo finance
  return(data) 
}

collect.goldprices <- function() {
  # Gets commodity prices for gold (XAU/GBP) from exchangerates.org.uk.

  goldcontent <- read_html(kGoldSource) # get page content
  gold.tabletmp <- as.data.frame(html_table(html_node(goldcontent, "#hist"), fill=TRUE)) # get table and convert to df 
  gold.table <- gold.tabletmp[3:nrow(gold.tabletmp), ] # remove first 3 rows as they are useless
  
  # return XAU historical price data as dataframe using web scraping from exchangerates.org.uk
  return(gold.table)
}

collect.oilprices <- function() {
  # Gets commodity prices for gold (OIL/GBP) from exchangerates.org.uk.
  
  oilcontent <- read_html(kOilSource) # get page content
  oil.tabletmp <- as.data.frame(html_table(html_node(oilcontent, "#hist"), fill=TRUE)) # get table and convert to df 
  oil.table <- oil.tabletmp[3:nrow(oil.tabletmp), ] # remove first 3 rows as they are useless
  
  # return OIL historical price data as dataframe using web scraping from exchangerates.org.uk
  return(oil.table)
}

# main function
main <- function () {
  
  # call setup function 
  setup() 

  # get fx history from yahoo finance
  fx.gbpeur <- collect.yahoofinance(symbol = "GBPEUR=X", from = kFromDate, to = kToDate) # GBP/EUR
  fx.gbpusd <- collect.yahoofinance(symbol = "GBPUSD=X", from = kFromDate, to = kToDate) # GBP/USD
  fx.gbpjpy <- collect.yahoofinance(symbol = "GBPJPY=X", from = kFromDate, to = kToDate) # GBP/JPY

  # get crypto currency prices from yahoo finance
  crypto.btcgbp <- collect.yahoofinance(symbol = "BTC-GBP", from = kFromDate, to = kToDate) # BTC/GBP
  crypto.ethgbp <- collect.yahoofinance(symbol = "ETH-GBP", from = kFromDate, to = kToDate) # ETH/GBP

  # get commodity prices from exchangerates 
  commodity.gold <- collect.goldprices() # XAU/GBP
  commodity.oil <- collect.oilprices()  # OIL/GBP
  
  # save raw results for fx rates from yahoo finance
  write.csv(fx.gbpeur, file = paste("data/raw/", kGbpEurRawFile, sep="")) # GBP/EUR
  write.csv(fx.gbpusd, file = paste("data/raw/", kGbpUsdRawFile, sep="")) # GBP/USD
  write.csv(fx.gbpjpy, file = paste("data/raw/", kGbpJpyRawFile, sep="")) # GBP/JPY

  # save raw results for crypto prices from yahoo finance
  write.csv(crypto.btcgbp, file = paste("data/raw/", kBtcRawFile, sep="")) # BTC/GBP
  write.csv(crypto.ethgbp, file = paste("data/raw/", kEthRawFile, sep="")) # ETH/GBP

  # save raw results for commodities from exchangerates
  write.csv(commodity.gold, file = paste("data/raw/", kXauGbpRawFile, sep="")) # XAU/GBP
  write.csv(commodity.oil, file = paste("data/raw/", kOilGbpRawFile, sep="")) # OIL/GBP

  # results saved
  print("Data from Financial Markets was downloaded.")
}

main() # call main function to execute script 

