#Library Import
if (!require("ipumsr")) stop("Reading IPUMS data into R requires the ipumsr package. It can be installed using the following command: install.packages('ipumsr')")
library(tidyverse)
library(devtools)
library(readxl)
library(readr)
if (!require(remotes)) install.packages("remotes")
remotes::install_github("ipums/ipumsr/ipumsexamples")
remotes::install_github(
  "ipums/ipumsr", 
  build_vignettes = TRUE, 
  dependencies = TRUE
)

#API Call To Import Data
set_ipums_api_key("59cba10d8a5da536fc06b59dba6936aacdfc4183a2ec23d67211303a")

extract_definition <- define_extract_usa(
  "This is an example extract to submit via API.",
  c("us2018a","us2019a"),
  c("AGE", "SEX", "RACE", "STATEFIP")
)

submitted_extract <- submit_extract(extract_definition)
submitted_extract <- get_extract_info(submitted_extract)
is_extract_ready(submitted_extract)
downloadable_extract <- wait_for_extract(submitted_extract)

path_to_ddi_file <- download_extract(downloadable_extract)
data <- read_ipums_micro(path_to_ddi_file)

#Attempted to Import Dataset Manually - Wouldn't Work for Some Reason
#ddi <- read_ipums_ddi("00_raw_data/usa_00002.xml")
#data <- read_ipums_micro("00_raw_data/usa_00002.xml")



