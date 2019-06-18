################################################################################################################
#
#
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
  lubripack("quantmod")
}

collect.fxrates <- function(symbol, fromDate, toDate) {
  # Gets fx rates from yahoo finance.
  #
  # Args:
  #   symbol: FX symbol to fetch from yahoo finance.
  #   fromDate: Date from used when fetching FX historical prices (yyyy-mm-dd).
  #   toDate: Date to used when fetching FX historical prices (yyyy-mm-dd).
  #
  # Returns:
  #   Dataframe with the historical FX rates for the specified arguments.
  
  # get fx data with the specified arguments from yahoo
  data <- as.data.frame(getSymbols(symbol, src = "yahoo", from = fromDate, to = toDate, auto.assign = FALSE))
  
  # return historical fx dataframe taken from yahoo finance
  return(data) 
}

# main function
main <- function () {
  
  # call setup function 
  setup() 

  # get fx history from yahoo finance 
  fx.gbpeur <- collect.fxrates(symbol = "GBPEUR=X", from = kFromDate, to = kToDate) # GBP/EUR 
  fx.gbpusd <- collect.fxrates(symbol = "GBPUSD=X", from = kFromDate, to = kToDate) # GBP/USD
  fx.gbpjpy <- collect.fxrates(symbol = "GBPJPY=X", from = kFromDate, to = kToDate) # GBP/JPY
  
  # save raw results for fx rates from yahoo finance 
  write.csv(fx.gbpeur, file = paste("data/raw/", kGbpEurRawFile))
  write.csv(fx.gbpusd, file = paste("data/raw/", kGbpUsdRawFile))
  write.csv(fx.gbpjpy, file = paste("data/raw/", kGbpJpyRawFile))
  
  # results saved
  print("FX exchange data is downloaded from yahoo finance and saved.")
}

main() # call main function to execute script 

