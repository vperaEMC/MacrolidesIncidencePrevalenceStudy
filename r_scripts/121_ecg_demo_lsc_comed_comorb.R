library(dplyr)

################################################################################
################################## ECG #########################################
################################################################################

results_ecg <- list()
results_lsc <- list()
results_demographics <- list()
results_comorb_comed <- list()
num_name <- paste0("numerator","_",names(duration_ranges)[1])

for(i in seq_along(cohorts_of_interest)){

  first_t_chro_use_name <- paste0("first_t_chron_user","_",names(cohorts_of_interest)[i])
  denom_name <- paste0("denominator","_",names(cohorts_of_interest)[i])
  
# I want to select the first record of macrolide prescription per cohort
  cdm[[first_t_chro_use_name]] <-
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
    compute()
  
# intersect with ecg
intersect_ecg <- PatientProfiles::addConceptIntersect(
  x = cdm[[first_t_chro_use_name]],
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
names(results_ecg)[i] <- names(cohorts_of_interest)[i]

# export csv file
ecg_file_name <- paste0("ecg_",names(cohorts_of_interest)[i],".csv")

write.csv(intersect_ecg, here::here("Macrolides_v2", ecg_file_name))

################################################################################
################################## LSC #########################################
################################################################################

  # perform lsc on study population on condition occurrence
  lsc_first_time_chron_macro_users <- cdm[[first_t_chro_use_name]] |>
    CohortCharacteristics::summariseLargeScaleCharacteristics(
      window = list(c(-7,0), c(-14,0)),
      eventInWindow = c("condition_occurrence"),
      minimumFrequency = 0
    )
  
  lsc_name <- paste0("lsc_",names(cohorts_of_interest)[i],".csv")
  
  # export csv file
  # write.csv(lsc_cdm[[first_t_chro_use_name]], 
  #           here::here("Macrolides_v2",lsc_name))
  omopgenerics::exportSummarisedResult(lsc_first_time_chron_macro_users,
                                       fileName = lsc_name,
                                       path = here::here("Macrolides_v2"))
  
  results_lsc[[i]] <- lsc_first_time_chron_macro_users
  names(results_lsc)[i] <- names(cohorts_of_interest)[i]
  
  ################################################################################
  ################################## DEMO ########################################
  ################################################################################

  demographics_first_time_chron_macro_users <- 
    CohortCharacteristics::summariseCharacteristics(
      cohort = cdm[[first_t_chro_use_name]]
    )
  
  demo_name <- paste0("demographics_",names(cohorts_of_interest)[i],".csv")
  
  # export csv file
  write.csv(demographics_first_time_chron_macro_users, 
            here::here("Macrolides_v2",demo_name))
  
  omopgenerics::exportSummarisedResult(demographics_first_time_chron_macro_users,
                                       fileName = demo_name,
                                       path = here::here("Macrolides_v2"))
  
  results_demographics[[i]] <- demographics_first_time_chron_macro_users
  names(results_demographics)[i] <- names(cohorts_of_interest)[i]
  
################################################################################
############################# COMED & COMORB ###################################
################################################################################

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
    
    
    comorb_comed_summarised <- cdm[[first_t_chro_use_name]] %>%
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
    
    # export csv file
    omopgenerics::exportSummarisedResult(comorb_comed_summarised,
                                         fileName = "comorb_comed_summarised.csv",
                                         path = here::here("Macrolides_v2"))
    
    results_comorb_comed[[i]] <- comorb_comed_summarised
    names(results_comorb_comed)[i] <- names(cohorts_of_interest)[i]
  }