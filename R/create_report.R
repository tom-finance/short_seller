################################################################################
# Automated Report Production from Markdown File

# (c) Thomas Ludwig, July 2020.
################################################################################

# define filename to be used for output file
file_name <- paste("Report_Systemindikatoren_", 
                   format(Sys.Date(), "%d_%m_%Y"), ".html", 
                   sep = "")

# render markdown document and safe to output directory
rmarkdown::render(input = "G:/Risiko/Anwendungen/Report_Systemindikatoren/report/Markdown_HTML_Indikatoren_ALL.Rmd",
                  quiet = FALSE, # show Pandoc commands in command line
                  output_file = file_name, # define directory where to store output file
                  clean = TRUE, # intermediate files are deleted
                  output_dir = "G:/Risiko/Anwendungen/Report_Systemindikatoren/report/Archiv",
                  encoding = "UTF-8") # select corect encoding

################################################################################
