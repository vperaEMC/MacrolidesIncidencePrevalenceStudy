library(DrugUtilisation)

# generate the drug utilisation cohort
cdm_aco <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_aco,
  name = "incidence incidental use aco",
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
  name = "denominator_incidence_incidental_use_aco",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  ageGroup = list(c(0, 150), c(0,40), c(41,150)),
  sex = c("Both", "Female", "Male"),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)


# calculating incidence

inc_incidental_use_aco  <- IncidencePrevalence::estimateIncidence(
  cdm = cdm_aco ,
  denominatorTable = "denominator_incidence_incidental_use_aco",
  outcomeTable = "incidence incidental use aco",
  denominatorCohortId = NULL, #all ids are selected
  outcomeCohortId = NULL, #all ids are selected
  interval = c("years","overall"),
  completeDatabaseIntervals = TRUE,
  strata = list(),
  includeOverallStrata = TRUE,
  minCellCount = 0,
  #temporary = TRUE,
  returnParticipants = FALSE,
  outcomeWashout = 0,
  repeatedEvents = TRUE
)

# rename and store incidence data in a convenient object
inc_incidental_use_aco_adj <-
  inc_incidental_use_aco %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="Denominator cohort 1",
      "Incidental use",
      NA)
  )

# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(inc_incidental_use_aco_adj, here::here("Macrolides/inc_incidental_use_aco_adj.csv"))