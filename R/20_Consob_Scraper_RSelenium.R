################################################################################
# R Script do Automate Download from Website with javascript Elements
#
# (c) Thomas Ludwig, September 2020.
################################################################################

# packages
library(RSelenium)

################################################################################

# set up driver
driver <- rsDriver(browser=c("chrome"), # I use Chrome because Firefox causes trouble with download
                   chromever="85.0.4183.83", # have to manually set this, otherwise problems
                   port = 2000L) # select port, this setting should work out fine normally

# navigate to website of interest, in this case Consob website where we can download the file 
driver$client$navigate("http://www.consob.it/web/consob-and-its-activities/short-selling#:~:text=To%20be%20able%20to%20submit,your%20net%20short%20positions%20here.")

# execute javascript which triggers download
driver$client$executeScript("downloadShortselling();")

# close server and client, otherwise problems with RSelenium
driver$server$stop()
driver$client$quit()

# now find location of download folder on local machine and construct file path
download_location <- file.path(Sys.getenv("USERPROFILE"), 
                               "Downloads")

# change working directory
setwd(download_location)

# copy file to new directory and delete file from download folder
file.rename(dir(path = download_location,
                pattern = "Pnc"), 
            "C:/Users/User/Desktop/input_consob.xlsx")

################################################################################

# Solution to possible problem with Chrome:
# https://stackoverflow.com/questions/55201226/session-not-created-this-version-of-chromedriver-only-supports-chrome-version-7

# Other useful information here
# https://stackoverflow.com/questions/56366491/how-to-use-r-to-download-a-file-from-webpage-when-there-is-no-specific-file-embe
# http://theautomatic.net/2020/04/21/make-your-amazon-purchases-with-r/

################################################################################