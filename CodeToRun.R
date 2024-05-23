# Install dependencies -----
#install.packages("renv") # if not already installed, install renv from CRAN
renv::restore() # this should prompt you to install the various packages required for the study

# CireR package is included under the folder github_packges and can be installed like this:
install.packages(
  here::here("github_packages/CirceR-1.3.3.tar.gz"), repos = NULL)

# Load packages ------
library(DBI)
library(here)
library(CDMConnector)
library(dplyr)
library(CodelistGenerator)
library(DrugUtilisation)
library(IncidencePrevalence)
library(PatientProfiles)
library(CohortCharacteristics)
library(stringr)
library(RPostgres)

# Database connection details -----
# In this study we also use the DBI package to connect to the database
# set up the dbConnect details below (see https://dbi.r-dbi.org/articles/dbi for more details)
# make the db connection, example:

# dbiConnection <- DBI::dbConnect(RPostgres::Postgres(),
#                                 dbname = "...",
#                                 host = "...",
#                                 port = "...",
#                                 user = "...",
#                                 password = "...")
dbiConnection <- DBI::dbConnect("....")

# The name of the schema that contains the OMOP CDM with patient-level data
cdm_database_schema<-"...."

# The name of the schema where results tables will be created 
results_database_schema<-"...."

# create cdm reference ----

# make the CDM object, use connection details from previously
cdm <- CDMConnector::cdm_from_con(
  con = dbiConnection,
  cdm_schema = cdm_database_schema,
  write_schema = results_database_schema
)

# check database connection
# running the next line should give you a count of your person table
cdm$person %>% 
  tally()

# Run the study ------
source(here("RunStudy.R"))
# after the study is run you should have a folder called Macrolides in 
# the root of this project to be shared
