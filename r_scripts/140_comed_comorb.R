################################################################################
############################# COMED & COMORB ###################################
################################################################################

results_comorb_comed <- list()

for (i in seq_along(cdm_subsets)){
cdm_subsets[[i]] <- CDMConnector::generateConceptCohortSet(
  cdm = cdm_subsets[[i]],
  conceptSet = concept_set_comedication,
  name = "comedication",
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
  name = "comorbidities",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  subsetCohort = NULL,
  subsetCohortId = NULL,
  overwrite = TRUE
)

# create the first time user long term macrolides cohort in the cdm object
cdm_subsets[[i]]$first_time_chron_macro_users <-
  #cdm_subsets[[i]]$numerator_long %>%
  cdm_subsets[[i]]$numerator_no_restriction %>%
  dplyr::filter(cohort_definition_id == 4) %>%
  dplyr::distinct(subject_id, .keep_all = TRUE) %>%
  dplyr::compute()

comorb_comed_summarised <- cdm_subsets[[i]]$first_time_chron_macro_users %>%
  CohortCharacteristics::summariseCharacteristics(
    cohortIntersectFlag = list(
      "comedication" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comedication",
        targetStartDate = "cohort_start_date",
        targetEndDate = "cohort_end_date",
        window = list(c(-365, 0)),
        nameStyle = "{cohort_name}_{window_name}"
      ),
      "comorbidities" = list(
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        targetCohortTable = "comorbidities",
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