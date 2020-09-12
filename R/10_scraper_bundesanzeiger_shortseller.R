################################################################################
# WEB SCRAPER OF SHORT POSITIONS OF HEDGE FUNDS IN GERMAN COMPANIES

# (c) Thomas Ludwig, July 2020
################################################################################

# packages for analysis

library(rvest)
library(dplyr)

################################################################################

# data import and cleansing

# define starting page
url_start <- "https://www.bundesanzeiger.de/ebanzwww/wexsservlet?page.navid=to_nlp_start"

# define web scraping function
getPostContent <- function(url){
  cont <- read_html(url) %>% # read html from given url
    html_table(fill = TRUE) # extract html table directly from website
  cont[[1]] <- NULL # delete first table which is not clean
  
  # add some random sleep time to web scraper to avoid server overload
  Sys.sleep(sample(seq(1, 3, by=0.001), 1))
  
  return(cont)
}

# define function to go back in website
getNextUrl <- function(url) {
  scraped_url <- read_html(url) %>% 
    html_node(".next_page a") %>%
    html_attr("href")
  
  paste0("https://www.bundesanzeiger.de", scraped_url)
}

# combine functions to scrape data from each page in one call
scrapeBackApply <- function(url, n) {
  # url: starting url
  # n: how many subpages do we want to go back?
  sapply(1:n, function(x) {
    r <- getPostContent(url)
    # Overwrite global 'url'
    url <<- getNextUrl(url)
    r
  })
}

# use function on website
data_scraped <- scrapeBackApply(url = url_start, 15)

# merge data to one data frame
all_test <- do.call(rbind.data.frame, data_scraped)

# clean data for data manipulation
all_test$Emittent <- gsub("Historie", "", all_test$Emittent)
all_test$Emittent <- gsub("[[:punct:]]", "", all_test$Emittent)
all_test$Datum <- as.Date(all_test$Datum, "%Y-%m-%d")
all_test$Position <- as.numeric(gsub("[\\%,]", "", gsub(",", ".", all_test$Position)))/100

################################################################################

# name cleaning (we have unambiguous names which we have to consolidate)

names <- all_test %>%
  filter(Datum > "2020-01-01") %>%
  select(ISIN, Emittent) %>%
  distinct()

# next code is used to manually correct the names in the data
# count <- names %>%
#   group_by(ISIN) %>%
#   summarise(count = n()) %>%
#   filter(count >1)
# 
# names_cleaning <- all_test %>%
#   filter(Datum > "2020-01-01") %>%
#   select(ISIN, Emittent) %>%
#   distinct() %>%
#   filter(., ISIN %in% count$ISIN) %>%
#   arrange(ISIN)

# this data frame was set up by hand for the 2020 data!
names_correct <- data.frame(ISIN = c("DE0006452907", "DE0007500001",
                                     "DE000A0TGJ55", "LU1296758029",
                                     "NL0012044747", "US3994732069"),
                            Emittent = c("Nemetschek SE", "ThyssenKrupp Aufzugswerke GmbH",
                                         "VARTA Microbattery GmbH", "Corestate Capital Holding",
                                         "SHOP APOTHEKE EUROPE NV", "GROUPON INC"))

count_clean <- names %>%
  group_by(ISIN) %>%
  summarise(count = n()) %>%
  filter(count == 1)

names_clean <- all_test %>%
  filter(Datum > "2020-01-01") %>%
  select(ISIN, Emittent) %>%
  distinct() %>%
  filter(., ISIN %in% count_clean$ISIN)
  
names_clean <- rbind(names_clean, names_correct)

#################################################################################