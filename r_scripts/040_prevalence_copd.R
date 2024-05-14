library(DrugUtilisation)

# generate the drug utilisation cohort for COPD
cdm_copd <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_copd,
  name = "prevalence copd",
  conceptSet = all_concept_ids,
  durationRange = c(1,Inf),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  limit = "all"
)

library(IncidencePrevalence)

# generating the denominator

cdm_copd <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_copd,
  name = "denominator_prevalence_copd",
  requirementInteractions = TRUE)

# calculating prevalence

prev_copd <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_copd,
  denominatorTable = "denominator_prevalence_copd",
  outcomeTable = "prevalence copd",
  denominatorCohortId = NULL, #all ids are selected
  outcomeCohortId = NULL, #all ids are selected
  interval = c("years","overall"),
  completeDatabaseIntervals = TRUE,
  fullContribution = FALSE,
  strata = list(),
  includeOverallStrata = TRUE,
  minCellCount = 0,
  returnParticipants = FALSE
)


# rename and store prevalence data in a convenient object
prev_copd_adj <-
  prev_copd %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="denominator_cohort_1",
      "COPD",
      NA)
    )

# save results
if (!dir.exists(here::here("Macrolides"))) 
  {dir.create(here::here("Macrolides"))}

write.csv(prev_copd_adj, 
          here::here("Macrolides/prev_copd_adj.csv"))