library(DrugUtilisation)

# generate the drug utilisation cohort for asthma
cdm_asthma <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_asthma,
  name = "prevalence asthma",
  conceptSet = all_concept_ids,
  durationRange = c(1, Inf),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  limit = "all"
)

library(IncidencePrevalence)

# generating the denominator

cdm_asthma <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_asthma,
  name = "denominator_prevalence_asthma",
  requirementInteractions = TRUE)

# calculating overall prevalence

prev_asthma <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_asthma,
  denominatorTable = "denominator_prevalence_asthma",
  outcomeTable = "prevalence asthma",
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
prev_asthma_adj <-
  prev_asthma %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="denominator_cohort_1",
      "Asthma",
      NA)
  )

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_asthma_adj, here::here("Macrolides/prev_asthma_adj.csv"))
