################################################################################################################
#
# Script which holds various miscellaneous functions and constants.
#
################################################################################################################
# CONSTANTS ####################################################################################################

# brexit news sources 
kApSource <- "https://www.bnnbloomberg.ca/timeline-of-brexit-and-events-leading-to-may-s-departure-1.1270161" 
kJazzeraSource <- "https://www.aljazeera.com/news/2019/01/brexit-timeline-190115164043103.html" 

# commodities sources 
kGoldSource <- "https://www.exchangerates.org.uk/commodities/XAU-GBP-history.html"
kOilSource <- "https://www.exchangerates.org.uk/commodities/OIL-GBP-history.html"

# brexit events filenames (news sites)
kApRawFile <- "raw_events_ap.csv"
kJazzeraRawFile <- "raw_events_aljazzera.csv"
kEventsFile <- "brexit_events.csv" # for cleaned/augmented events

# fx rates filenames
kGbpEurRawFile <- "raw_fx_gbpeur.csv"
kGbpUsdRawFile <- "raw_fx_gbpusd.csv"
kGbpJpyRawFile <- "raw_fx_gbpjpy.csv"
kFxRatesFile <- "fx_rates.csv" # for cleaned/augmented fx rates

# crypto filenames 
kBtcRawFile <- "raw_crypto_btcgbp.csv"
kEthRawFile <- "raw_crypto_ethgbp.csv"
kBtcFile <- "btc_prices.csv" # for cleaned BTC Prices
kEthFile <- "eth_prices.csv" # for cleaned ETH Prices

# equity filenames 
kFtse100RawFile <- "raw_index_ftse100.csv"
kFtse250RawFile <- "raw_index_ftse250.csv"
kFtse100File <- "ftse100_prices.csv" # for cleaned FTSE100 Prices
kFtse250File <- "ftse250_prices.csv" # for cleaned FTSE250 Prices

# commodities filenames 
kXauGbpRawFile <- "raw_commodity_xau.csv" # gold 
kOilGbpRawFile <- "raw_commodity_oil.csv" # oil 
kXauFile <- "xau_prices.csv" # for cleaned XAU/GBP Prices
kOilFile <- "oil_prices.csv" # for cleaned OIL/GBP Prices

################################################################################################################
# FUNCTIONS ####################################################################################################

# check if packages are installed then load libraries.
# https://stackoverflow.com/questions/15155814/check-if-r-package-is-installed-then-load-library
install_load <- function (package1, ...)  {   
  
  # convert arguments to vector
  packages <- c(package1, ...)
  
  # start loop to determine if each package is installed
  for(package in packages){
    
    # if package is installed locally, load
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package))
    
    # if package is not installed locally, download, then load
    else {
      install.packages(package, dependencies = TRUE)
      do.call("library", list(package))
    }
  } 
}

lubripack <- function(...,silent=FALSE){
  
  #check names and run 'require' function over if the given package is installed
  requirePkg<- function(pkg){
    if(length(setdiff(pkg,rownames(installed.packages())))==0)
      require(pkg, quietly = TRUE,character.only = TRUE)
  }
  
  packages <- as.vector(unlist(list(...)))
  if(!is.character(packages))
    stop("No numeric allowed! Input must contain package names to install and load")
  
  if (length(setdiff(packages,rownames(installed.packages()))) > 0 )
    install.packages(setdiff(packages,rownames(installed.packages())), dependencies = TRUE,
                     repos = c("https://cran.revolutionanalytics.com/", "http://owi.usgs.gov/R/"))
  
  res <- unlist(sapply(packages, requirePkg))
  
  if(silent == FALSE && !is.null(res)) {cat("\nBelow Packages Successfully Installed:\n\n")
    print(res)
  }
}
################################################################################################################

