library(DrugUtilisation)
library(CDMConnector)
library(dplyr)
library(PatientProfiles)

cdm <- mockDrugUtilisation(numberIndividual = 200)

new_cohort_set <- settings(cdm$cohort1) %>%
  dplyr::arrange(cohort_definition_id) %>%
  dplyr::mutate(cohort_name = c("asthma","bronchitis","pneumonia"))

cdm$cohort1 <- cdm$cohort1 |>
  newCohortTable(cohortSetRef = new_cohort_set)

new_cohort_set <- settings(cdm$cohort2) %>%
  dplyr::arrange(cohort_definition_id) %>%
  dplyr::mutate(cohort_name = c("albuterol","fluticasone","montelukast"))

cdm$cohort2 <- cdm$cohort2 |>
  newCohortTable(cohortSetRef = new_cohort_set)

settings(cdm$cohort1)

settings(cdm$cohort2)

save <- summariseTreatmentFromCohort(cohort = cdm$cohort1,
                             treatmentCohortName = c("cohort2"),
                             window = list(c(-Inf,Inf)))
#i'm not sure if I understand the estimate values. I would rather
#like to see the % of users, just as in demographics table,
#rather than the proportion within users, as it seems now

