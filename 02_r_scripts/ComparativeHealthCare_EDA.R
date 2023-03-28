#Package Import
library(tidyverse)
library(devtools)
library(readxl)
library(ggthemes)
library(kableExtra)
library(readr)

#Import Dataset
Comp_Health_Spending <- read_csv("~/Desktop/Academic_Projects/data-2PzVz.csv")
View(Comp_Health_Spending)

NHE2021 <- read_csv("~/Desktop/Academic_Projects/NHE2021/NHE2021.csv")
View(NHE2021)

health_exp_percentage <- read_csv("00_raw_data/SHA_28032023054429853.csv")
