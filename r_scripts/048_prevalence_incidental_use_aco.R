library(DrugUtilisation)

# generate the drug utilisation cohort
cdm_aco <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_aco,
  name = "prevalence incidental use aco",
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

cdm_aco <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_aco,
  name = "denominator_prevalence_incidental_use_aco",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  ageGroup = list(c(0, 150), c(0,40), c(41,150)),
  sex = c("Both", "Female", "Male"),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

cdm_aco$denominator_prevalence_incidental_use_aco %>%
  distinct() %>%
  tally() #3577 -> 1 person falling out, whoooo?? -> ok, the one that really needs to be excluded, YOINK

# calculating prevalence

prev_incidental_use_aco <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_aco,
  denominatorTable = "denominator_prevalence_incidental_use_aco",
  outcomeTable = "prevalence incidental use aco",
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
prev_incidental_use_aco_adj <-
  prev_incidental_use_aco %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="Denominator cohort 1",
      "Incidental use",
      NA)
  )

if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(prev_incidental_use_aco_adj, here::here("Macrolides/prev_incidental_use_aco_adj.csv"))