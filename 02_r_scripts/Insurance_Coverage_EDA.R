#Library Import
if (!require("ipumsr")) stop("Reading IPUMS data into R requires the ipumsr package. It can be installed using the following command: install.packages('ipumsr')")
library(tidyverse)
library(devtools)
library(readxl)
library(readr)
library(kableExtra)
devtools::install_github("DanChaltiel/crosstable", build_vignettes=TRUE)
library(crosstable)
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
  "Insurance Information by Race and Gender",
  c("us2021c"),
  c("AGE", "SEX", "RACE", "STATEFIP", "HCOVANY", "HCOVPRIV", "HINSEMP", "HINSPUR", "HINSTRI", "HCOVPUB", "HINSCAID", "HINSCARE", "HINSVA", "HINSIHS", "INCTOT", "FTOTINC",
    "INCWAGE", "CITIZEN", "EDUC", "EMPSTAT", "CBPERNUM", "CBSERIAL", "PERWT", "SAMPLE")
)

submitted_extract <- submit_extract(extract_definition)
submitted_extract <- get_extract_info(submitted_extract)
is_extract_ready(submitted_extract)
downloadable_extract <- wait_for_extract(submitted_extract)

ddi <- read_ipums_ddi("00_raw_data/usa_00004.xml")
data <- read_ipums_micro(ddi)
ipums_view(data)

# Clean Variables for EDA
censususadata <- data
censususadata <- censususadata %>% 
  mutate(RACE_factor = as_factor(RACE))
censususadata <- censususadata %>%
  mutate(GENDER_factor = as_factor(SEX))

#Create subset of data limited to Black Women
BWsubset <- censususadata %>%
  filter(RACE_factor == "Black/African American" & GENDER_factor == "Female")

#Mutate Variables Again as a Check
censususadata <- censususadata %>%
  mutate(RACE_zapped = zap_labels(RACE))
censususadata <- censususadata %>%
  mutate(GENDER_zapped = zap_labels(SEX))
BWsubset2 <- censususadata %>%
  filter(RACE_zapped == "2" & GENDER_zapped == "2")

#Zap Labels from Health Insurance Variables
BWSubset3 <- BWsubset %>%
  mutate_at(vars(starts_with("HC") | starts_with("HI")), zap_labels)

#Create Frequency Table of Health Insurance Coverage by Type 
table1 <- BWSubset3 %>%
  select(HCOVANY, HINSCAID, HINSPUR)
table1

#Create Table of Black Woman's Insurance Coverage by Type 
table2 <- crosstable(BWSubset3, c(HCOVANY:HINSIHS), showNA="ifany", 
           percent_digits=0, percent_pattern="{n} ({p_row})") %>% 
  as_flextable(keep_id=TRUE)

table2

table3 <- crosstable(BWSubset3, c(HCOVANY), by=c(HCOVPRIV, HCOVPUB), showNA = "ifany",
                     percent_digits = 0, percent_pattern = "{n} ({p_row})") %>%
  as_flextable(keep_id=TRUE)
table3

table4 <- crosstable(BWSubset3, c(HCOVPRIV, HCOVPUB), by=c(HCOVANY), showNA = "ifany",
                     percent_digits = 0, percent_pattern = "{n} ({p_row})") %>%
  as_flextable(keep_id=TRUE)
table4

#Line Graph of Black Women's Insurance Coverage (2017-2021)
graph_subset <- BWSubset3 %>%
  filter(HCOVANY == "2") %>%
  mutate(freq = length(HCOVANY))
linegraph1 <- graph_subset %>%
  ggplot(aes(x = MULTYEAR, y = freq)) +
  geom_line()
linegraph1
hist1
bargraph1 <- BWSubset3 %>%
  ggplot(aes(x = MULTYEAR, y = HCOVANY)) + 
  geom_bar()
bargraph1
