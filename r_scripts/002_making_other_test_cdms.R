

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
