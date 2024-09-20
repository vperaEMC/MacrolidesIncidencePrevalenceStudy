################################################################################
################################## LSC #########################################
################################################################################
results_lsc <- list()

for(i in seq_along(cdm_subsets)){
# perform lsc on study population on condition occurrence and drug exposure
lsc_first_time_chron_macro_users <- first_time_chron_macro_users |> 
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    window = list(c(-7,0)),
    eventInWindow = c("condition_occurrence"),
    minimumFrequency = 0.005
  )

lsc_name <- paste0("lsc_",names(cdm_subsets)[i],".csv")

# export csv file
# write.csv(lsc_first_time_chron_macro_users, 
#           here::here("Macrolides_v2",lsc_name))
omopgenerics::exportSummarisedResult(lsc_first_time_chron_macro_users,
                                     fileName = lsc_name,
                                     path = here::here("Macrolides_v2"))

results_lsc[[i]] <- lsc_first_time_chron_macro_users
names(results_lsc)[i] <- names(cdm_subsets)[i]

################################################################################
################################## DEMO ########################################
################################################################################

results_demographics <- list()

# demographics
demographics_first_time_chron_macro_users <- 
  CohortCharacteristics::summariseCharacteristics(
    cohort = first_time_chron_macro_users
  )

demo_name <- paste0("demographics_",names(cdm_subsets)[i],".csv")

# export csv file
write.csv(demographics_first_time_chron_macro_users, 
          here::here("Macrolides_v2",demo_name))

omopgenerics::exportSummarisedResult(demographics_first_time_chron_macro_users,
                                     fileName = demo_name,
                                     path = here::here("Macrolides_v2"))

results_demographics[[i]] <- demographics_first_time_chron_macro_users
names(results_demographics)[i] <- names(cdm_subsets)[i]
}