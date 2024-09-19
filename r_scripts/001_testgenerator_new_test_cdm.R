library(TestGenerator)
library(here)
library(testthat)
library(CDMConnector)
library(dplyr)

# remove cdm for fresh start
rm(cdm)

# output path for test json based on excel
json_test_path <- here::here("test_output")

# make the folder if it doesnt exist
if (!dir.exists(json_test_path)) 
{dir.create(json_test_path)}

test_name <- "macrolides_test"

# create the json
TestGenerator::readPatients(filePath = here::here('test_subjects', test_file),
                            testName = test_name,
                            outputPath = json_test_path)


cdm <- TestGenerator::patientsCDM(pathJson = json_test_path, 
                                  testName = test_name)

################################################################################
######################## CDM, subset ###########################################
################################################################################

# The way with CDMconnector to create cohorts within CDM object using json files
path_to_cohort_json_files <- here::here("inst/cohorts")
list.files(path_to_cohort_json_files) 

# read the json files that signify cohorts
# cohort definition ids are like 1, 2, 3 etc, but the cohort "name"  (i.e.
# atlas id number) is written next to it.
cohort_set <- CDMConnector::read_cohort_set(path_to_cohort_json_files)


# get the cohorts into MAIN CDM
cdm <- CDMConnector::generate_cohort_set(
  cdm = cdm,
  cohort_set = cohort_set,
  name = "stud_cohorts",
  overwrite = TRUE
)