################################################################################
# Automated Report Production from Markdown File

# (c) Thomas Ludwig, July 2020.
################################################################################

# define filename to be used for output file
file_name <- paste("short_seller_analysis_", 
                   format(Sys.Date(), "%d_%m_%Y"), ".pdf", 
                   sep = "")

# render markdown document and safe to output directory
rmarkdown::render(input = "short_seller_analysis.Rmd",
                  quiet = FALSE, # show Pandoc commands in command line
                  output_file = file_name, # define directory where to store output file
                  clean = TRUE, # intermediate files are deleted
                  output_dir = "../Output",
                  encoding = "UTF-8") # select correct encoding

################################################################################