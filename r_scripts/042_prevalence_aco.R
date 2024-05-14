library(DrugUtilisation)

# generate the drug utilisation cohort for asthma
cdm_aco <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_aco,
  name = "prevalence aco",
  conceptSet = all_concept_ids,
  durationRange = c(1, Inf),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  limit = "all"
)

library(IncidencePrevalence)

# generating the denominator

cdm_aco <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_aco,
  name = "denominator_prevalence_aco",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  #ageGroup = list(c(0, 150)),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

# calculating overall prevalence

prev_aco <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_aco,
  denominatorTable = "denominator_prevalence_aco",
  outcomeTable = "prevalence aco",
  denominatorCohortId = NULL, #all ids are selected
  outcomeCohortId = NULL, #all ids are selected
  interval = c("years","overall"),
  completeDatabaseIntervals = TRUE,
  fullContribution = FALSE,
  strata = list(),
  includeOverallStrata = TRUE,
  minCellCount = 0,
  #temporary = TRUE,
  returnParticipants = FALSE
)

# rename and store prevalence data in a convenient object
prev_aco_adj <-
  prev_aco %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="denominator_cohort_1",
      "ACO",
      NA)
  )

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_aco_adj, here::here("Macrolides/prev_aco_adj.csv"))
