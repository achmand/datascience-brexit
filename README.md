# Brexit Influence on various Financial Markets
This is my final project for the ‘Statistics for Data Scientists’ for the ICS5115 study unit. The final results for this project is best viewed using nbviewer, click on the following link to view results [Jupyter Notebook](https://nbviewer.jupyter.org/github/achmand/datascience-brexit/blob/master/src/impact_of_major_brexit_events_on_various_financial_markets.ipynb). For a detailed explanation for this project read through the [research paper](https://github.com/achmand/datascience-brexit/blob/master/doc/Impact%20of%20major%20brexit%20events%20on%20various%20financial%20markets.pdf) or look at this [presentation](https://github.com/achmand/datascience-brexit/blob/master/doc/datascience-brexit.pdf) for an overview. 

Resources for this project;
* [miscellaneous.R](https://github.com/achmand/datascience-brexit/blob/master/src/miscellaneous.R) [Various miscellaneous functions and constants]
* [data_collection_events.R](https://github.com/achmand/datascience-brexit/blob/master/src/data_collection_events.R) [Collects Brexit events from AP & Al Jazeera]
* [data_collection_finance.R](https://github.com/achmand/datascience-brexit/blob/master/src/data_collection_finance.R) [Collects financial data from Yahoo Finance]
* [data_cleansing.R](https://github.com/achmand/datascience-brexit/blob/master/src/data_cleansing.R) [Cleans the collected datasets]
* [Jupyter Notebook/Results](https://github.com/achmand/datascience-brexit/blob/master/src/impact_of_major_brexit_events_on_various_financial_markets.ipynb) [Notebook with visualisations and results]
* [Datasets](https://github.com/achmand/datascience-brexit/tree/master/src/data) [Both Raw and Cleaned datasets]
* [Anaconda Environment](https://github.com/achmand/datascience-brexit/blob/master/src/environment.yml) 
* [Research Paper](https://github.com/achmand/datascience-brexit/blob/master/doc/Impact%20of%20major%20brexit%20events%20on%20various%20financial%20markets.pdf) 

## Setup
### Environment
R version 3.5.1 (2018-07-02)
Running under: Ubuntu 18.04.1 LTS
IDE: [RStudio](https://www.rstudio.com/) 

### R Packages
The following libraries were used for this implementation. It must be noted that a function in the [miscellaneous.R](https://github.com/achmand/datascience-brexit/blob/master/src/miscellaneous.R) script called ‘lubripack(...)’ script was written to check if the package is already installed and if not the package is installed. So any libraries used are referenced using this function. 
* rvest 
* quantmod
* stringr
* lubridate
* dplyr
* knitr
* IRdisplay
* kableExtra
* e1071
* broom
* ggplot2
* ggpubr
* repr

Furthermore, an anaconda environment file ([environment.yml](https://github.com/achmand/datascience-brexit/blob/master/src/environment.yml)) is supplied to be able to run the Jupyter Notebook. If you don’t have anaconda installed on your system, follow this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart) to install anaconda on Ubuntu 18.04. Once anaconda is set up on your system execute the following commands to create an new environment from the supplied yaml file.

```
conda env create --f environment.yaml # creates a conda environment from file
conda activate r_brexit # activate conda environment 
jupyter notebook # run jupyter notebook
```

## Scope for this project 
The scope of the project is to examine (statistically) whether Brexit events had an impact on the following financial markets: Foreign Exchange Market, Cryptocurrency Market, Stock Market and the commodities market. 

*  To examine the impact of major brexit events on foreign exchange rates (GBP/EUR, GBP/USD, GBP/JPY). 
*  To examine the impact of major brexit events on cryptocurrency prices (BTC/GBP, ETH/GBP). 
*  To examine the impact of major brexit events on stock market prices (FTSE100, FTSE250). 
*  To examine the impact of major brexit events on commodity prices (GOLD, OIL).

To do so we applied a T-test to examine the following hypothesis: 
* Null Hypothesis: There is no significant difference between the abnormal mean returns before a major brexit event and after it (pre-mean = post-mean)
* Alternative Hypothesis: There is a significant difference between the abnormal mean returns before a major brexit event and after it (pre-mean <> post-mean)

## Some resource on Events Studies 
* [Significance tests for events studies](https://www.eventstudytools.com/significance-tests)
* [Expected Return Models](https://www.eventstudytools.com/expected-return-models)
* [Event Study Assumptions](https://www.eventstudytools.com/assumptions-event-study-methodology)



