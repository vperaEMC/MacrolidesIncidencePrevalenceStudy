library(dplyr)


#aco
distinct_users_macrolides_aco <-
cdm_aco$`prevalence aco` %>%
  filter(cohort_definition_id == 4) %>%
  select(subject_id) %>%
  distinct() %>%
  collect() %>%
  unlist(use.names = FALSE)

never_macro_users_aco <-
  cdm_aco$stud_cohorts %>%
  filter(!subject_id %in% distinct_users_macrolides_aco)

#asthma
distinct_users_macrolides_asthma <-
  cdm_asthma$`prevalence asthma` %>%
  filter(cohort_definition_id == 4) %>%
  select(subject_id) %>%
  distinct() %>%
  collect() %>%
  unlist(use.names = FALSE)

never_macro_users_asthma <-
  cdm_asthma$stud_cohorts %>%
  filter(!subject_id %in% distinct_users_macrolides_asthma)

#copd
distinct_users_macrolides_copd <-
  cdm_copd$`prevalence copd` %>%
  filter(cohort_definition_id == 4) %>%
  select(subject_id) %>%
  distinct() %>%
  collect() %>%
  unlist(use.names = FALSE)

never_macro_users_copd <-
  cdm$stud_cohorts %>%
  filter(!subject_id %in% distinct_users_macrolides_copd)

#general population
distinct_users_macrolides_general_population <-
  cdm$`prevalence general population` %>%
  filter(cohort_definition_id == 4) %>%
  select(subject_id) %>%
  distinct() %>%
  collect() %>%
  unlist(use.names = FALSE)

never_macro_users_general_population <-
  cdm$stud_cohorts %>%
  filter(!subject_id %in% distinct_users_macrolides_general_population)

################################################################################
################################## ACO #########################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_never_macro_users_aco <- never_macro_users_aco |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-365,0),c(-Inf,0)),
    eventInWindow = c("condition_occurrence","drug_exposure"),
    minimumFrequency = 0.05
  )

# export csv file
write.csv(lsc_never_macro_users_aco, 
          here::here("Macrolides/lsc_never_macro_users_aco.csv"))

# demographics
demographics_never_macro_users_aco <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = never_macro_users_aco,
    strata = list(),
    demographics = TRUE,
    ageGroup = NULL,
    tableIntersect = list(),
    cohortIntersect = list(),
    conceptIntersect = list(),
    otherVariables = character()
  )

# export csv file
write.csv(demographics_never_macro_users_aco, 
          here::here("Macrolides/demographics_never_macro_users_aco.csv"))

################################################################################
################################## ASTHMA ######################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_never_macro_users_asthma <- never_macro_users_asthma |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-365,0),c(-Inf,0)),
    eventInWindow = c("condition_occurrence","drug_exposure"),
    minimumFrequency = 0.05
  )

# export csv file
write.csv(lsc_never_macro_users_asthma, 
          here::here("Macrolides/lsc_never_macro_users_asthma.csv"))

# demographics
demographics_never_macro_users_asthma <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = never_macro_users_asthma,
    strata = list(),
    demographics = TRUE,
    ageGroup = NULL,
    tableIntersect = list(),
    cohortIntersect = list(),
    conceptIntersect = list(),
    otherVariables = character()
  )

# export csv file
write.csv(demographics_never_macro_users_asthma, 
          here::here("Macrolides/demographics_never_macro_users_asthma.csv"))

################################################################################
################################## COPD ########################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_never_macro_users_copd <- never_macro_users_copd |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-365,0),c(-Inf,0)),
    eventInWindow = c("condition_occurrence","drug_exposure"),
    minimumFrequency = 0.05
  )

# export csv file
write.csv(lsc_never_macro_users_copd, 
          here::here("Macrolides/lsc_never_macro_users_copd.csv"))

# demographics
demographics_never_macro_users_copd <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = never_macro_users_copd,
    strata = list(),
    demographics = TRUE,
    ageGroup = NULL,
    tableIntersect = list(),
    cohortIntersect = list(),
    conceptIntersect = list(),
    otherVariables = character()
  )

# export csv file
write.csv(demographics_never_macro_users_copd, 
          here::here("Macrolides/demographics_never_macro_users_copd.csv"))

################################################################################
############################## GENERAL POPULATION ##############################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_never_macro_users_general_population <- never_macro_users_general_population |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-365,0),c(-Inf,0)),
    eventInWindow = c("condition_occurrence","drug_exposure"),
    minimumFrequency = 0.05
  )

# export csv file
write.csv(lsc_never_macro_users_general_population, 
          here::here("Macrolides/lsc_never_macro_users_general_population.csv"))

# demographics
demographics_never_macro_users_general_population <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = never_macro_users_general_population,
    strata = list(),
    demographics = TRUE,
    ageGroup = NULL,
    tableIntersect = list(),
    cohortIntersect = list(),
    conceptIntersect = list(),
    otherVariables = character()
  )

# export csv file
write.csv(demographics_never_macro_users_general_population, 
          here::here("Macrolides/demographics_never_macro_users_general_population.csv"))
