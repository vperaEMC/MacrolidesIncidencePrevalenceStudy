library(DrugUtilisation)

# generate the drug utilisation cohort
cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = "prevalence chronic use general population",
  conceptSet = all_concept_ids,
  durationRange = c(30, Inf),
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 0,
  priorObservation = 0,
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  limit = "all"
)

library(IncidencePrevalence)

# generating the denominator

cdm <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm,
  name = "denominator_prevalence_chronic_use_general_population",
  cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  #ageGroup = list(c(0, 150)),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

# calculating prevalence
prev_chronic_use_general_population  <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm ,
  denominatorTable = "denominator_prevalence_chronic_use_general_population",
  outcomeTable = "prevalence chronic use general population",
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
prev_chronic_use_general_population_adj <-
  prev_chronic_use_general_population  %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="denominator_cohort_1",
      "Chronic use",
      NA))

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_chronic_use_general_population_adj, here::here("Macrolides/prev_chronic_use_general_population_adj.csv"))