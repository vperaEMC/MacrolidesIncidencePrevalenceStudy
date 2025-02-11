# make sure to run script 000_import... first.

library(dplyr)

# getting the total number of individuals per cohort
results_inc_prev[["prevalence"]] %>%
  dplyr::filter(
    outcome_cohort_name == 'Any macrolide',
    analysis_interval == 'overall',
    denominator_sex == 'Both',
    denominator_age_group == 'All ages',
    duration == '30-179 days') %>%
  # amount of people with specific disease is the same regardless of the 
  # duration of macrolide use, as macrolide use is not an inclusion criterion
  dplyr::select(n_population, denominator_target_cohort_name, cdm_name)

# getting the % of individuals witihin cohort using a macrolide
results_inc_prev[["prevalence"]] %>%
  dplyr::filter(
    outcome_cohort_name == 'Any macrolide',
      analysis_interval == 'overall',
      denominator_sex == 'Both',
    denominator_age_group == 'All ages',
    ) %>%
  # amount of people with specific disease is the same regardless of the 
  # duration of macrolide use, as macrolide use is not an inclusion criterion
  dplyr::select(
    denominator_target_cohort_name, duration, point_est_adj,cdm_name,n_population, n_cases) %>%
  arrange(duration,point_est_adj)
