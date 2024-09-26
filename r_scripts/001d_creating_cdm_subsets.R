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



# empty list of person ids
cdm_subsets <- list()

for(i in seq_along(cohorts_of_interest)){
  
  cohort_number <- cohorts_of_interest[[i]]
  
  pers_ids_cohort <- 
    cdm$stud_cohorts %>%
    dplyr::filter(cohort_definition_id == cohort_number) %>%
    dplyr::distinct(subject_id) %>%
    dplyr::pull(subject_id)
  
  cdm_temp <- cdm %>%
    CDMConnector::cdm_subset(person_id = pers_ids_cohort)
  
  cdm_subsets[[i]] <- cdm_temp
  names(cdm_subsets)[i] <- names(cohorts_of_interest)[i]
  
  rm(cdm_temp)
}