library(DrugUtilisation)

# generate the drug utilisation cohort for COPD
cdm_copd <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_copd,
  name = "incidence copd",
  conceptSet = all_concept_ids,
  durationRange = c(1,Inf),
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
  name = "denominator_inc_copd",
  #cohortDateRange = as.Date(c("2010-01-01", "2022-12-31")),
  ageGroup = list(c(0, 150), c(0,40), c(41,150)),
  sex = c("Both", "Female", "Male"),
  #daysPriorObservation = 0,
  requirementInteractions = TRUE)

# calculating incidence

inc_copd <- IncidencePrevalence::estimateIncidence(
  cdm = cdm_copd,
  denominatorTable = "denominator_inc_copd",
  outcomeTable = "incidence copd",
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
inc_copd_adj <-
  inc_copd %>%
  dplyr::mutate(
    denominator_cohort_name = ifelse(
      denominator_cohort_name=="Denominator cohort 1",
      "COPD",
      NA)
  )
# save
if (!dir.exists(here::here("Macrolides"))) {dir.create(here::here("Macrolides"))}
write.csv(inc_copd_adj, here::here("Macrolides/inc_copd_adj.csv"))