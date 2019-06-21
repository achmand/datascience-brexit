####################################################################
I suggest following the README page in our GitHub Repository for requirements and running instructions: https://github.com/achmand/datascience-brexit
####################################################################
---------------------------------------
SETUP
---------------------------------------
R version 3.5.1 (2018-07-02)
Platform: x86_64-conda_cos6-linux-gnu (64-bit)
Running under: Ubuntu 18.04.1 LTS
####################################################################
---------------------------------------
SCRIPTS
---------------------------------------
The following scripts could be executed from terminal using ‘Rscript’ command. The datasets are already downloaded and cleaned, these scripts will reapply the procedures done to get/clean the datasets. Execute the ‘data_collection_*.R’ scripts before the ‘data_cleansing.R’ script.  


-> ‘miscellaneous.R’ : Script which holds various miscellaneous functions and constants.
-> ‘data_collection_events.R’ : Collects events data set via web scraping. 
-> ‘data_collection_finance.R’ : Collects financial data. 
-> ‘data_cleansing.R’ : Cleans the raw datasets. 


For the Jupyter notebook make sure to install the conda environment from the ‘.yaml’ file supplied. An HTML version of the notebook is also supplied. 

-> ‘impact_of_major_brexit_events_on_various_financial_markets.ipynb’ : Jupyter notebook with the main functionality, hypothesis testing, visualisations, etc.. 

* Note: ‘environment.yml’ is also supplied, it is a conda environment used when implementing the Jupyter Notebook part of the implementation. 

conda env create --file=environment.yaml
####################################################################
---------------------------------------
DEPENDENCIES  
---------------------------------------
The following libraries were used for this implementation. It must be noted that a function in the ‘miscellaneous.R’ called ‘lubripack(...)’ script was written to check if the package is already installed and if not the package is installed. So any libraries used are referenced using this function. 

-> vrest 
-> quantmod
-> stringr
-> lubridate
-> dplyr
-> knitr
-> IRdisplay
-> kableExtra
-> e1071
-> broom
-> ggplot2
-> ggpubr
-> repr

 

