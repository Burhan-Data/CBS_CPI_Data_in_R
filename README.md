CBS_CPI_Data_in_R
## Consumer Price Index (CPI) Analysis Pipeline in R
## Overview
#This repository contains a self-contained R script that retrieves consumer price data directly from the CBS StatLine API, processes the monthly data 
#into quarterly averages, calculates quarter-on-quarter percentage changes, plots the results, and archives everything into a local SQLite database.
## Tooling & Dependencies
**Language:** R
**Data Wrangling:** `dplyr`, `tidyr`, `stringr`
**Visualization:** `ggplot2`
**Database:** `RSQLite`, `DBI`

## Process Architecture
**Input:** Automatically fetches the latest official CPI table (`86141ENG`) directly from the CBS StatLine web service without manual file downloads.
**Input2** Check only Food and Non-Alcoholic Beverages (CPI010000) and Health (CPI060000) CPI.
**Throughput:** Filters user-selected product categories, groups monthly indexes into 3-month blocks to compute the quarterly CPI average, and calculates 
the percentage growth relative to the preceding quarter.
**Output:** Generates a publication-ready line chart (`output_cpi_quarterly_change.png`) and writes the clean dataset into a local SQLite database (`cpi_database.sqlite`).

## How to Run
1. Open the project in RStudio.
2. Run `install.packages(c("cbsodataR", "dplyr", "tidyr", "ggplot2", "DBI", "RSQLite", "stringr", "writexl"))` if packages are missing.
3. Run the main R script.
