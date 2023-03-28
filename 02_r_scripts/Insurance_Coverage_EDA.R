#Library Import
library(tidyverse)
library(devtools)
library(congressData)
library(readxl)
library(readr)

#Import Dataset 
Basic_HealthInsurance <- read_csv("00_raw_data/ACSST1Y2021.S2701-2023-03-25T063835.csv")