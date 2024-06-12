# summarise cohort characteristics of first time chornic users

# relevant libraries
library(CDMConnector)
library(dplyr)
library(CohortCharacteristics)

################################################################################
################################## ACO #########################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_first_time_chron_macro_users_aco <- first_time_chron_macro_users_aco |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-7,0)),
    eventInWindow = c("condition_occurrence"),
    minimumFrequency = 0.005
  )

# export csv file
write.csv(lsc_first_time_chron_macro_users_aco, 
          here::here("Macrolides/lsc_first_time_chron_macro_users_aco.csv"))

# demographics
demographics_first_time_chron_macro_users_aco <- 
  CohortCharacteristics::summariseCharacteristics(
  cohort = first_time_chron_macro_users_aco
)

# export csv file
write.csv(demographics_first_time_chron_macro_users_aco, 
          here::here("Macrolides/demographics_first_time_chron_macro_users_aco.csv"))

################################################################################
################################## ASTHMA ######################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_first_time_chron_macro_users_asthma <- first_time_chron_macro_users_asthma |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-7,0)),
    eventInWindow = c("condition_occurrence"),
    minimumFrequency = 0.005
  )

# export csv file
write.csv(lsc_first_time_chron_macro_users_asthma, 
          here::here("Macrolides/lsc_first_time_chron_macro_users_asthma.csv"))

# demographics
demographics_first_time_chron_macro_users_asthma <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = first_time_chron_macro_users_asthma
  )

# export csv file
write.csv(demographics_first_time_chron_macro_users_asthma, 
          here::here("Macrolides/demographics_first_time_chron_macro_users_asthma.csv"))

################################################################################
################################## COPD ########################################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_first_time_chron_macro_users_copd <- first_time_chron_macro_users_copd |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-7,0)),
    eventInWindow = c("condition_occurrence"),
    minimumFrequency = 0.005
  )

# export csv file
write.csv(lsc_first_time_chron_macro_users_copd, 
          here::here("Macrolides/lsc_first_time_chron_macro_users_copd.csv"))

# demographics
demographics_first_time_chron_macro_users_copd <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = first_time_chron_macro_users_copd
  )

# export csv file
write.csv(demographics_first_time_chron_macro_users_copd, 
          here::here("Macrolides/demographics_first_time_chron_macro_users_copd.csv"))

################################################################################
############################## GENERAL POPULATION ##############################
################################################################################

# perform lsc on study population on condition occurence and drug exposure
lsc_first_time_chron_macro_users_general_population <- first_time_chron_macro_users_general_population |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-7,0)),
    eventInWindow = c("condition_occurrence"),
    minimumFrequency = 0.005
  )

# export csv file
write.csv(lsc_first_time_chron_macro_users_general_population, 
          here::here("Macrolides/lsc_first_time_chron_macro_users_general_population.csv"))

# demographics
demographics_first_time_chron_macro_users_general_population <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = first_time_chron_macro_users_general_population
  )

# export csv file
write.csv(demographics_first_time_chron_macro_users_general_population, 
          here::here("Macrolides/demographics_first_time_chron_macro_users_general_population.csv"))
