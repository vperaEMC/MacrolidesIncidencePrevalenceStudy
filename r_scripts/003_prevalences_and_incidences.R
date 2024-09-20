# make an empty list to store the results in
prevalences_table <- c()
incidences_table <- c()
denom_name <- "denominator"

# loop it all
for (i in seq_along(cdm_subsets)){
  for(j in seq_along(duration_ranges)){

# naming convention for numerators
num_name <- paste0("numerator","_",names(duration_ranges)[j])
est_name <- paste0(names(cdm_subsets)[i],"_",names(duration_ranges)[j])

  
# generate the numerator
cdm_subsets[[i]] <- DrugUtilisation::generateDrugUtilisationCohortSet(
  cdm = cdm_subsets[[i]],
  name = num_name,
  conceptSet = all_concept_ids,
  durationRange = duration_ranges[[j]],
  imputeDuration = "none",
  gapEra = 7,
  priorUseWashout = 365,
  priorObservation = 0,
  limit = "all"
)

# generating the denominator
cdm_subsets[[i]] <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm_subsets[[i]],
  name = denom_name,
  ageGroup = age_groups_analysis,
  sex = sexes_analysis,
  requirementInteractions = TRUE)

# calculating prevalence
prev <- IncidencePrevalence::estimatePeriodPrevalence(
  cdm = cdm_subsets[[i]],
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
  cdm = cdm_subsets[[i]],
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
incidences_table <- rbind(incidences_table,prev)

  } # closing duration loop
} # closing cdm_subset loop


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