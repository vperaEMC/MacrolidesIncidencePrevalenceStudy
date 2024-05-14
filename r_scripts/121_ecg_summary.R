library(dplyr)

################################################################################
################################## ACO #########################################
################################################################################

# I want to select the first record of macrolide prescription per cohort
first_time_chron_macro_users_aco <-
  cdm_aco$`prevalence chronic use aco` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE)
  
# intersect with ecg
intersect_ecg_aco <- PatientProfiles::addConceptIntersect(
  x = first_time_chron_macro_users_aco,
  conceptSet = ecg_concept_ids,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  window = 
    list(c(0,7), 
         c(0,14),
         c(0,30), 
         c(0,60)),
  targetStartDate = "event_start_date",
  targetEndDate = NULL,
  order = "last",
  value = "flag",
  nameStyle = "{value}_{concept_name}_{window_name}") %>%
  dplyr::collect() %>%
  PatientProfiles::summariseResult()

# export csv file
write.csv(intersect_ecg_aco, 
          here::here("Macrolides/intersect_ecg_aco.csv"))

################################################################################
################################## ASTHMA ######################################
################################################################################

# I want to select the first record of macrolide prescription per cohort
first_time_chron_macro_users_asthma <-
  cdm_asthma$`prevalence chronic use asthma` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE)

# intersect with ecg
intersect_ecg_asthma <- PatientProfiles::addConceptIntersect(
  x = first_time_chron_macro_users_asthma,
  conceptSet = ecg_concept_ids,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  window = 
    list(c(0,7), 
         c(0,14),
         c(0,30), 
         c(0,60)),
  targetStartDate = "event_start_date",
  targetEndDate = NULL,
  order = "last",
  value = "flag",
  nameStyle = "{value}_{concept_name}_{window_name}") %>%
  dplyr::collect() %>%
  PatientProfiles::summariseResult()

# export csv file
write.csv(intersect_ecg_asthma, 
          here::here("Macrolides/intersect_ecg_asthma.csv"))

################################################################################
##################################  COPD  ######################################
################################################################################

# I want to select the first record of macrolide prescription per cohort
first_time_chron_macro_users_copd <-
  cdm_copd$`prevalence chronic use copd` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE)

# intersect with ecg
intersect_ecg_copd <- PatientProfiles::addConceptIntersect(
  x = first_time_chron_macro_users_copd,
  conceptSet = ecg_concept_ids,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  window = 
    list(c(0,7), 
         c(0,14),
         c(0,30), 
         c(0,60)),
  targetStartDate = "event_start_date",
  targetEndDate = NULL,
  order = "last",
  value = "flag",
  nameStyle = "{value}_{concept_name}_{window_name}") %>%
  dplyr::collect() %>%
  PatientProfiles::summariseResult()

# export csv file
write.csv(intersect_ecg_copd, 
          here::here("Macrolides/intersect_ecg_copd.csv"))


################################################################################
############################ GENERAL POPULATION ################################
################################################################################

# I want to select the first record of macrolide prescription per cohort
first_time_chron_macro_users_general_population <-
  cdm$`prevalence chronic use general population` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE)

# intersect with ecg
intersect_ecg_general_population <- PatientProfiles::addConceptIntersect(
  x = first_time_chron_macro_users_general_population,
  conceptSet = ecg_concept_ids,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  window = 
    list(c(0,7), 
         c(0,14),
         c(0,30), 
         c(0,60)),
  targetStartDate = "event_start_date",
  targetEndDate = NULL,
  order = "last",
  value = "flag",
  nameStyle = "{value}_{concept_name}_{window_name}") %>%
  dplyr::collect() %>%
  PatientProfiles::summariseResult()

# export csv file
write.csv(intersect_ecg_general_population, 
          here::here("Macrolides/intersect_ecg_general_population.csv"))