library(dplyr)

################################################################################
################################## ECG #########################################
################################################################################

results_ecg <- list()

for(i in seq_along(cdm_subsets)){
# I want to select the first record of macrolide prescription per cohort
first_time_chron_macro_users <-
  #cdm_subsets[[i]]$numerator_long %>%
  cdm_subsets[[i]]$numerator_no_restriction %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE)
  
# intersect with ecg
intersect_ecg <- PatientProfiles::addConceptIntersect(
  x = first_time_chron_macro_users,
  conceptSet = ecg_concept_ids,
  indexDate = "cohort_start_date",
  censorDate = "cohort_start_date",
  window = 
    list(c(-7,0), 
         c(-14,0),
         c(-30,0),
         c(-60,0),
         c(-Inf,Inf)),
  targetStartDate = "event_start_date",
  targetEndDate = "event_start_date",
  order = "last",
  value = "flag",
  nameStyle = "{value}_{concept_name}_{window_name}") %>%
  dplyr::collect() %>%
  PatientProfiles::summariseResult()

# put result in lsit
results_ecg[[i]] <- intersect_ecg
names(results_ecg)[i] <- names(cdm_subsets)[i]

# export csv file
ecg_file_name <- paste0("ecg_",names(cdm_subsets)[i],".csv")

write.csv(intersect_ecg, here::here("Macrolides_v2", ecg_file_name))
}