library(here)
library(CDMConnector)
library(dplyr)

################################################################################
######################## CDM, subset ###########################################
################################################################################

# The way with CDMconnector to create cohorts within CDM object using json files
path_to_cohort_json_files <- path_setting_cohort
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

# get only prescription data, aiming to exclude dispensing data from SIDIAP
cdm$drug_exposure <-
  cdm$drug_exposure %>%
  dplyr::filter(drug_type_concept_id %in% c(32838,32839))