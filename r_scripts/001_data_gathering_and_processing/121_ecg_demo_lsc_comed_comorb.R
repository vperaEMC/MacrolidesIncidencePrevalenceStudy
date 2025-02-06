library(dplyr)

################################################################################
################################## ECG #########################################
################################################################################

results_ecg <- list()
results_lsc <- list()
results_comorb_comed <- list()

for(i in seq_along(cohorts_of_interest)){
  for(j in seq_along(duration_ranges)){
  
  num_name <- paste0("numerator","_",names(duration_ranges)[j])
  denom_name <- paste0("denominator","_",names(cohorts_of_interest)[i])
  first_time_users <- paste0("first_time_users_",names(cohorts_of_interest)[i],'_',names(duration_ranges)[j])
  cohort_duration_name <- paste0(names(cohorts_of_interest)[i],'_',names(duration_ranges)[j],".csv")
  
  
  
  # I want to select the first record of macrolide prescription per cohort
  cdm[[first_time_users]] <-
    cdm[[num_name]] %>%  # select numerator, i.e. drug users
    dplyr::right_join(cdm[[denom_name]], # right join with denominator, entire target cohort basically
                      by = join_by(subject_id == subject_id, 
                                   cohort_start_date >= cohort_start_date,
                                   cohort_start_date <= cohort_end_date,
                                   cohort_end_date >= cohort_start_date,
                                   cohort_end_date <= cohort_end_date
                      )) %>%
    dplyr::filter(!is.na(cohort_start_date.x)) %>%
    dplyr::select(1:4) %>%
    dplyr::rename(cohort_definition_id = cohort_definition_id.x,
                  cohort_start_date = cohort_start_date.x,
                  cohort_end_date = cohort_end_date.x) %>%
    dplyr::filter(cohort_definition_id == 4) %>%
    dplyr::distinct(subject_id, .keep_all = TRUE) %>%
    omopgenerics::newCohortTable(.softValidation = TRUE) %>% 
    dplyr::compute()
  
  # intersect with ecg
  intersect_ecg <- PatientProfiles::addConceptIntersect(
    x = cdm[[first_time_users]],
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
  
  # put result in list
  results_ecg[[first_time_users]] <- intersect_ecg
  
  # export csv file
  ecg_file_name <- paste0("ecg_",cohort_duration_name)
  
  write.csv(intersect_ecg, here::here("Macrolides_v2", ecg_file_name))
  
  ################################################################################
  ################################## LSC #########################################
  ################################################################################
  
  # perform lsc on study population on condition occurrence
  lsc_first_time_macro_users <- cdm[[first_time_users]] |>
    CohortCharacteristics::summariseLargeScaleCharacteristics(
      window = list(c(-7,0), c(-14,0)),
      eventInWindow = c("condition_occurrence"),
      minimumFrequency = 0
    )
  
  lsc_name <- paste0("lsc_",cohort_duration_name)
  
  # export csv file
  # write.csv(lsc_cdm[[first_time_users]], 
  #           here::here("Macrolides_v2",lsc_name))
  omopgenerics::exportSummarisedResult(lsc_first_time_macro_users,
                                       fileName = lsc_name,
                                       path = here::here("Macrolides_v2"))
  
  results_lsc[[first_time_users]] <- lsc_first_time_macro_users 
  }
}
  
  ################################################################################
  ############################# COMED & COMORB ###################################
  ################################################################################
  

  
  for(i in seq_along(cohorts_of_interest)){
    comed_name <- paste0("comedication","_",names(cohorts_of_interest)[i])  
    comorb_name <- paste0("comorbidities","_",names(cohorts_of_interest)[i])  

  cdm <- CDMConnector::generateConceptCohortSet(
    cdm = cdm,
    conceptSet = concept_set_comedication,
    name = comed_name,
    limit = "all",
    requiredObservation = c(0, 0),
    end = "observation_period_end_date",
    subsetCohort = NULL,
    subsetCohortId = NULL,
    overwrite = TRUE
  )
  cdm <- CDMConnector::generateConceptCohortSet(
    cdm = cdm,
    conceptSet = concept_set_comorbidities,
    name = comorb_name,
    limit = "all",
    requiredObservation = c(0, 0),
    end = "observation_period_end_date",
    subsetCohort = NULL,
    subsetCohortId = NULL,
    overwrite = TRUE
  )
  }
  
for(i in seq_along(cohorts_of_interest)){
  for(j in seq_along(duration_ranges)){
    
    first_time_users <- paste0("first_time_users_",names(cohorts_of_interest)[i],'_',names(duration_ranges)[j])
    cohort_duration_name <- paste0(names(cohorts_of_interest)[i],'_',names(duration_ranges)[j],".csv")
  
  comorb_comed_summarised <- cdm[[first_time_users]] %>%
    CohortCharacteristics::summariseCharacteristics(
      cohortIntersectFlag = list(
        comed_name = list(
          indexDate = "cohort_start_date",
          censorDate = "cohort_end_date",
          targetCohortTable = comed_name,
          targetStartDate = "cohort_start_date",
          targetEndDate = "cohort_end_date",
          window = list(c(-365, 0)),
          nameStyle = "{cohort_name}_{window_name}"
        ),
        comorb_name = list(
          indexDate = "cohort_start_date",
          censorDate = "cohort_end_date",
          targetCohortTable = comorb_name,
          targetStartDate = "cohort_start_date",
          targetEndDate = "cohort_end_date",
          window = list(c(-Inf, 0)),
          nameStyle = "{cohort_name}_{window_name}"
        )
      )
    )
  
  comorb_comed_name <- paste0("comorb_comed_summarised_",cohort_duration_name)
  
  # export csv file
  omopgenerics::exportSummarisedResult(comorb_comed_summarised,
                                       fileName = comorb_comed_name,
                                       path = here::here("Macrolides_v2"))
  
  results_comorb_comed[[first_time_users]] <- comorb_comed_summarised
  }
}

