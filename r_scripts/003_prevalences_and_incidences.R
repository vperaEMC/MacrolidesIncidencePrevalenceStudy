# make an empty list to store the results in
prevalences_table <- c()
incidences_table <- c()


# loop it all
for (j in seq_along(duration_ranges)){
  for(i in seq_along(cohorts_of_interest)){

    
# naming convention for numerators
num_name <- paste0("numerator","_",names(duration_ranges)[j])
est_name <- paste0(names(cohorts_of_interest)[i],"_",names(duration_ranges)[j])
denom_name <- paste0("denominator","_",names(cohorts_of_interest)[i])
  

# generate the numerator
cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = num_name,
  conceptSet = all_concept_ids,
  durationRange = duration_ranges[[j]],
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 365,
  priorObservation = 0,
  cohortDateRange = as.Date(c("2006-01-01", "2022-12-31")),
  limit = "all"
)


# generating the denominator (different approach for general population)
if (names(cohorts_of_interest)[i] == 'general_pop') {
  cdm <- IncidencePrevalence::generateDenominatorCohortSet(
    cdm = cdm,
    name = denom_name,
    cohortDateRange = as.Date(c("2006-01-01", "2022-12-31")),
    ageGroup = age_groups_analysis,
    sex = sexes_analysis,
    requirementInteractions = TRUE)
} else {
  cdm <- IncidencePrevalence::generateTargetDenominatorCohortSet(
    targetCohortTable = 'stud_cohorts',
    targetCohortId = cohorts_of_interest[[i]],
    cdm = cdm,
    name = denom_name,
    cohortDateRange = as.Date(c("2006-01-01", "2022-12-31")),
    ageGroup = age_groups_analysis,
    sex = sexes_analysis,
    requirementInteractions = TRUE)
} 


# calculating prevalence
prev <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = denom_name,
  outcomeTable = num_name,
  denominatorCohortId = NULL, #all ids are selected
  outcomeCohortId = NULL, #all ids are selected
  interval = time_interval,
  completeDatabaseIntervals = TRUE,
  fullContribution = FALSE,
  strata = list(),
  includeOverallStrata = TRUE,
  minCellCount = min_cell_count,
  returnParticipants = FALSE
) %>%
  dplyr::mutate(
    denominator_cohort_name = est_name)

# calculating incidence
inc <- IncidencePrevalence::estimateIncidence(
  cdm = cdm,
  denominatorTable = denom_name,
  outcomeTable = num_name,
  denominatorCohortId = NULL, #all ids are selected
  outcomeCohortId = NULL, #all ids are selected
  interval = time_interval,
  completeDatabaseIntervals = TRUE,
  outcomeWashout = 0,
  repeatedEvents = TRUE,
  minCellCount = min_cell_count,
  strata = list(),
  includeOverallStrata = TRUE,
  #temporary = TRUE,
  returnParticipants = FALSE
) %>%
  dplyr::mutate(
    denominator_cohort_name = est_name)

# store all estimates together
prevalences_table <- rbind(prevalences_table,prev)
incidences_table <- rbind(incidences_table,inc)

  } # closing duration loop
} # closing cohort loop


# save results
if (!dir.exists(here::here("Macrolides_v2"))) 
{dir.create(here::here("Macrolides_v2"))}

all_estimates <- list(
  "prev_all_estimates" = prevalences_table, 
  "inc_all_estimates" = incidences_table)

for (i in seq_along(all_estimates)){
  
file_name <- paste0(names(all_estimates)[i],'.csv')

write.csv(
  all_estimates[[i]], 
  here::here(
    "Macrolides_v2",file_name
    )
  )
}