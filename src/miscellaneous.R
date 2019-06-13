################################################################################################################
#
# Script which holds various miscellaneous functions.
#
################################################################################################################

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

