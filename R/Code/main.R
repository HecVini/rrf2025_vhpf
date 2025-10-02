### Reproducible Research Fundamentals -  Main R Script

# Load libraries ---- 

# Load necessary libraries
library(haven)  # for reading .dta files
library(dplyr)  # for data manipulation
library(tidyr)  # for reshaping data
library(stringr) # work with strings
library(labelled) # use labels
library(gtsummary) # tables
library(gt) # tables
library(ggplot2) #graphs
library(tidyverse) # working with tidy data
library(modelsummary) # creating summary tables
library(stargazer) # writing nice tables
library(RColorBrewer) # color palettes

# Set data path ----

# this is the second root of the project, the first root is the code whose directory 
# is already being handled by the rstudio project.

data_path <- "/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/Transparent and Credible Analytics/Course Materials/DataWork/Data"

# Run the R scripts ----

#source("/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/rrf2025_vhpf/R/Code/01-processing-data.R")
source("/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/rrf2025_vhpf/R/Code/02-constructing-data.R")
source("/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/rrf2025_vhpf/R/Code/03-analyzing-data.R")
