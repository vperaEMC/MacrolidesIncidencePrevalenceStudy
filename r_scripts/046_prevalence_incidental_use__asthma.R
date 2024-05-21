library(DrugUtilisation)

# generate the drug utilisation cohort for asthma
cdm_asthma <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_asthma,
  name = "prevalence incidental use asthma",
  conceptSet = all_concept_ids,
  durationRange = c(1, 29),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  limit = "all"
)

library(IncidencePrevalence)

# generating the denominator

cdm_asthma <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_asthma,
  name = "denominator_prevalence_incidental_use_asthma",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  ageGroup = list(c(0, 150), c(0,40), c(41,150)),
  sex = c("Both", "Female", "Male"),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

# calculating overall prevalence

prev_incidental_use_asthma <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_asthma,
  denominatorTable = "denominator_prevalence_incidental_use_asthma",
  outcomeTable = "prevalence incidental use asthma",
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
prev_incidental_use_asthma_adj <-
  prev_incidental_use_asthma %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="Denominator cohort 1",
      "Incidental use",
      NA)
  )

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_incidental_use_asthma_adj, here::here("Macrolides/prev_incidental_use_asthma_adj.csv"))