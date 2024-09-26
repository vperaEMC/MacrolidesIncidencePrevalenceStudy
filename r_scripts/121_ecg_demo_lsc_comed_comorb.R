library(dplyr)

################################################################################
################################## ECG #########################################
################################################################################

results_ecg <- list()
results_lsc <- list()
results_demographics <- list()
results_comorb_comed <- list()

for(i in seq_along(cdm_subsets)){

  num_name <- paste0("numerator","_",names(duration_ranges)[1],"_",names(cdm_subsets)[i])
  
  first_t_chro_use_name <- paste0("first_time_chron_user","_",names(cdm_subsets)[i])
  
# I want to select the first record of macrolide prescription per cohort
  cdm_subsets[[i]][[first_t_chro_use_name]] <-
  cdm_subsets[[i]][[num_name]] %>%
  dplyr::filter(cohort_definition_id == 4) %>%
  dplyr::distinct(subject_id, .keep_all = TRUE) |> 
    compute()
  
# intersect with ecg
intersect_ecg <- PatientProfiles::addConceptIntersect(
  x = cdm_subsets[[i]][[first_t_chro_use_name]],
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

################################################################################
################################## LSC #########################################
################################################################################


  # perform lsc on study population on condition occurrence and drug exposure
  lsc_first_time_chron_macro_users <- cdm_subsets[[i]][[first_t_chro_use_name]] |> 
    CohortCharacteristics::summariseLargeScaleCharacteristics(
      window = list(c(-7,0)),
      eventInWindow = c("condition_occurrence"),
      minimumFrequency = 0#0.005
    )
  
  lsc_name <- paste0("lsc_",names(cdm_subsets)[i],".csv")
  
  # export csv file
  # write.csv(lsc_cdm_subsets[[i]][[first_t_chro_use_name]], 
  #           here::here("Macrolides_v2",lsc_name))
  omopgenerics::exportSummarisedResult(lsc_first_time_chron_macro_users,
                                       fileName = lsc_name,
                                       path = here::here("Macrolides_v2"))
  
  results_lsc[[i]] <- lsc_first_time_chron_macro_users
  names(results_lsc)[i] <- names(cdm_subsets)[i]
  
  ################################################################################
  ################################## DEMO ########################################
  ################################################################################
  

  
  # demographics
  demographics_first_time_chron_macro_users <- 
    CohortCharacteristics::summariseCharacteristics(
      cohort = cdm_subsets[[i]][[first_t_chro_use_name]]
    )
  
  demo_name <- paste0("demographics_",names(cdm_subsets)[i],".csv")
  
  # export csv file
  write.csv(demographics_first_time_chron_macro_users, 
            here::here("Macrolides_v2",demo_name))
  
  omopgenerics::exportSummarisedResult(demographics_first_time_chron_macro_users,
                                       fileName = demo_name,
                                       path = here::here("Macrolides_v2"))
  
  results_demographics[[i]] <- demographics_first_time_chron_macro_users
  names(results_demographics)[i] <- names(cdm_subsets)[i]
  
################################################################################
############################# COMED & COMORB ###################################
################################################################################
  

    
    comed_name <- paste0("comedication","_",names(cdm_subsets)[i])  
    comorb_name <- paste0("comorbidities","_",names(cdm_subsets)[i])  
    
    cdm_subsets[[i]] <- CDMConnector::generateConceptCohortSet(
      cdm = cdm_subsets[[i]],
      conceptSet = concept_set_comedication,
      name = comed_name,
      limit = "all",
      requiredObservation = c(0, 0),
      end = "observation_period_end_date",
      subsetCohort = NULL,
      subsetCohortId = NULL,
      overwrite = TRUE
    )
    cdm_subsets[[i]] <- CDMConnector::generateConceptCohortSet(
      cdm = cdm_subsets[[i]],
      conceptSet = concept_set_comorbidities,
      name = comorb_name,
      limit = "all",
      requiredObservation = c(0, 0),
      end = "observation_period_end_date",
      subsetCohort = NULL,
      subsetCohortId = NULL,
      overwrite = TRUE
    )
    
    
    comorb_comed_summarised <- cdm_subsets[[i]][[first_t_chro_use_name]] %>%
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
            window = list(c(-365, 0)),
            nameStyle = "{cohort_name}_{window_name}"
          )
        )
      )
    
    # export csv file
    omopgenerics::exportSummarisedResult(comorb_comed_summarised,
                                         fileName = "comorb_comed_summarised.csv",
                                         path = here::here("Macrolides_v2"))
    
    results_comorb_comed[[i]] <- comorb_comed_summarised
    names(results_comorb_comed)[i] <- names(cdm_subsets)[i]
  }