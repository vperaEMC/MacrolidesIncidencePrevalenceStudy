library(here)
library(CDMConnector)
library(dplyr)

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

#  get the person IDs from asthma, check cohort_set (from read_cohort_set) which number is needed
pers_ids_asthma <- 
  cdm$stud_cohorts %>%
  dplyr::filter(cohort_definition_id == 1616) %>%
  dplyr::distinct(subject_id) %>%
  dplyr::pull(subject_id)

# and for COPD
pers_ids_copd <- 
  cdm$stud_cohorts %>%
  dplyr::filter(cohort_definition_id == 1617) %>%
  dplyr::distinct(subject_id) %>%
  dplyr::pull(subject_id)

# and for ACO
pers_ids_aco <- 
  cdm$stud_cohorts %>%
  dplyr::filter(cohort_definition_id == 1618) %>%
  dplyr::distinct(subject_id) %>%
  dplyr::pull(subject_id)

# check if numbers make sense
length(pers_ids_asthma)
length(pers_ids_copd)
length(pers_ids_aco)

# subset the main CDM for cohorts of interest based on subject/person id
cdm_asthma <- cdm %>%
  CDMConnector::cdm_subset(person_id = pers_ids_asthma)

cdm_copd <- cdm %>%
  CDMConnector::cdm_subset(person_id = pers_ids_copd)

cdm_aco <- cdm %>%
  CDMConnector::cdm_subset(person_id = pers_ids_aco)