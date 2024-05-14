library(DrugUtilisation)

# generate the drug utilisation cohort for COPD
cdm_copd <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_copd,
  name = "prevalence incidental use copd",
  conceptSet = all_concept_ids,
  durationRange = c(1,29),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  limit = "all"
)

library(IncidencePrevalence)


# generating the denominator

cdm_copd <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_copd,
  name = "denominator_prevalence_incidental_use_copd",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  #ageGroup = list(c(0, 150)),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

# calculating prevalence

prev_incidental_use_copd <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_copd,
  denominatorTable = "denominator_prevalence_incidental_use_copd",
  outcomeTable = "prevalence incidental use copd",
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


cdm_copd$person

# rename and store prevalence data in a convenient object
prev_incidental_use_copd_adj <-
  prev_incidental_use_copd %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="denominator_cohort_1",
      "Incidental use",
      NA)
  )

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_incidental_use_copd_adj, here::here("Macrolides/prev_incidental_use_copd_adj.csv"))
