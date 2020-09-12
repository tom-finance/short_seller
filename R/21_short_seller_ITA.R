################################################################################
# Brief Analysis of Shortseller Data in Italy
#
# Thomas Ludwig, September 2020
################################################################################

# packages
library(readxl)
library(dplyr)
library(xts)

################################################################################

# import data
data_current <- read_excel("../Input/short_ITA.xlsx",
                   skip = 1, sheet = " Correnti - Current ")


data_historical <- read_excel("../Input/short_ITA.xlsx",
                           skip = 1, sheet = " Storiche - Historic ")

data_date <- read_excel("../Input/short_ITA.xlsx",
                              skip = 1, sheet = " Pubb. Data - Pubb. Date ")

# date of publication
data_date$`Data di pubblicazione`

################################################################################

data_current %>%
  group_by(ISIN, `Name of Share Issuer`) %>%
  summarise(pos_tot = sum(`Net Short Position (%)`)) %>%
  arrange(desc(pos_tot))

############################

date_count <- data_historical %>%
  mutate(`Position Date` = as.Date(as.character(as.POSIXct(`Position Date`)))) %>%
  group_by(`Position Date`) %>%
  summarise(n = n())

plot(date_count$n ~ date_count$`Position Date`, type = "l")



serie_test <- xts(date_count$n, 
                  order.by = date_count$`Position Date`)


ret_serie <- diff(log(serie_test))


plot(serie_test, lwd = 2, main = "", 
     minor.ticks = NULL, grid.col = NA, labels.col = "black", major.ticks = "months",
     major.format="%b-%d", grid.ticks.on = "auto")
addPanel(rollmean, k=5, on=1, lwd = 2, col = "orangered")

# aggregate to daily and monthly data
serie_monthly <-  apply.monthly(serie_test, sum)

plot(serie_monthly, lwd = 2, main = "", 
     minor.ticks = NULL, grid.col = NA, labels.col = "black", major.ticks = "months",
     major.format="%b-%d", grid.ticks.on = "auto")

min(data_current$`Position Date`)

target <- data_historical %>%
  group_by(ISIN, `Name of Share Issuer`) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

barplot(target$n)

hist(target$n, breaks = 20)

head(target)

################################################################################