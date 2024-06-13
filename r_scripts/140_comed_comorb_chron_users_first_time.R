################################################################################
################################## COMEDICATION ################################
################################################################################

# load concept sets for comedication of interest
concept_set_comedication <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets", "drugs_comedication"),
    cdm = cdm,
    withConceptDetails = FALSE)

################################################################################
################################## COMORBIDITIES ###############################
################################################################################

# load concept sets for comorbidities of interest from json
concept_ids_comorbidities_json <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets", "comorbidities_json"),
    cdm = cdm,
    withConceptDetails = FALSE)

# collect paths to csv
path_comorbidities <- here::here("concept_sets","comorbidities_csv")

# list csv
list_csv <- list.files(path_comorbidities, full.names = TRUE)
names_csv <- list.files(path_comorbidities) 
names_csv <- stringr::str_sub(names_csv, end = -5)

# for looping to get all needed from csv
concept_ids_comorbidities_csv <- list()

for (i in 1:length(list_csv)){
  comorbidity <- read.csv(list_csv[i]) %>%
    filter(!is.na(concept_id))
  
  concept_ids_comorbidities_csv[[names_csv[i]]] <- comorbidity$concept_id
}

concept_set_comorbidities <-c(concept_ids_comorbidities_csv,concept_ids_comorbidities_json)

################################################################################
################################## ACO #########################################
################################################################################

cdm_aco <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_aco,
  conceptSet = concept_set_comedication,
  name = "comedication_aco",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)
cdm_aco <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_aco,
  conceptSet = concept_set_comorbidities,
  name = "comorbidities_aco",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)

# create the first time user long term macrolides cohort in the cdm object
cdm_aco$first_time_chron_macro_users_aco <-
  cdm_aco$`prevalence chronic use aco` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE) %>%
  compute()

comorbidities_summarised_aco <- cdm_aco$first_time_chron_macro_users_aco %>%
  CohortCharacteristics::summariseCharacteristics(
    cohortIntersectFlag = list(
      "Comedication" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comedication_aco",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      ),
      "comorbidities" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comorbidities_aco",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      )
    )
  )

# CohortCharacteristics::tableCharacteristics(comorbidities_summarised_aco)

# export csv file
write.csv(comorbidities_summarised_aco, 
          here::here("Macrolides/comorbidities_summarised_aco.csv"))

################################################################################
################################## COPD ########################################
################################################################################

cdm_copd <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_copd,
  conceptSet = concept_set_comedication,
  name = "comedication_copd",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)

cdm_copd <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_copd,
  conceptSet = concept_set_comorbidities,
  name = "comorbidities_copd",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)


# create the first time user long term macrolides cohort in the cdm object
cdm_copd$first_time_chron_macro_users_copd <-
  cdm_copd$`prevalence chronic use copd` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE) %>%
  compute()

comorbidities_summarised_copd <- cdm_copd$first_time_chron_macro_users_copd %>%
  CohortCharacteristics::summariseCharacteristics(
    cohortIntersectFlag = list(
      "Comedication" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comedication_copd",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      ),
      "comorbidities" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comorbidities_copd",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      )
    )
  )

# CohortCharacteristics::tableCharacteristics(comorbidities_summarised_copd)

# export csv file
write.csv(comorbidities_summarised_copd, 
          here::here("Macrolides/comorbidities_summarised_copd.csv"))

################################################################################
################################## ASTHMA ######################################
################################################################################

cdm_asthma <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_asthma,
  conceptSet = concept_set_comedication,
  name = "comedication_asthma",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)

cdm_asthma <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_asthma,
  conceptSet = concept_set_comorbidities,
  name = "comorbidities_asthma",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)


# create the first time user long term macrolides cohort in the cdm object
cdm_asthma$first_time_chron_macro_users_asthma <-
  cdm_asthma$`prevalence chronic use asthma` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE) %>%
  compute()

comorbidities_summarised_asthma <- cdm_asthma$first_time_chron_macro_users_asthma %>%
  CohortCharacteristics::summariseCharacteristics(
    cohortIntersectFlag = list(
      "Comedication" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comedication_asthma",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      ),
      "comorbidities" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comorbidities_asthma",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      )
    )
  )
# CohortCharacteristics::tableCharacteristics(comorbidities_summarised_asthma)

# export csv file
write.csv(comorbidities_summarised_asthma, 
          here::here("Macrolides/comorbidities_summarised_asthma.csv"))

################################################################################
################################## GENERAL POPULATION ##########################
################################################################################

# # create cohort based on the comedication
cdm <- CDMConnector::generateConceptCohortSet(
  cdm = cdm,
  conceptSet = concept_set_comedication,
  name = "comedication_general_population",
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
  name = "comorbidities_general_population",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)



cdm$first_time_chron_macro_users_general_population <-
  cdm$`prevalence chronic use general population` %>%
  filter(cohort_definition_id == 4) %>%
  distinct(subject_id, .keep_all = TRUE) %>%
  compute()

comorbidities_summarised_general_population <- cdm$first_time_chron_macro_users_general_population %>%
  CohortCharacteristics::summariseCharacteristics(
    cohortIntersectFlag = list(
      "Comedication" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comedication_general_population",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      ),
      "comorbidities" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comorbidities_general_population",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      )
    )
  )

# CohortCharacteristics::tableCharacteristics(comorbidities_summarised_general_population)

# export csv file
write.csv(comorbidities_summarised_general_population, 
          here::here("Macrolides/comorbidities_summarised_general_population.csv"))