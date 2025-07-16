# make sure to run script 000_import_ first.

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
    outcome_cohort_name == 'Azithromycin', # != 'Any macrolide', # #%in% c('Clarithromycin', 'Erythromycin'),
      analysis_interval == 'overall',
      denominator_sex == 'Both',
    denominator_age_group %in% c('60 to 69','70 to 79'),
    denominator_target_cohort_name != 'Gen. pop.',
    cdm_name == 'SIDIAP',
    duration != '<30 days')%>%
  # amount of people with specific disease is the same regardless of the 
  # duration of macrolide use, as macrolide use is not an inclusion criterion
  #dplyr::arrange(duration,outcome_cohort_name,desc(point_estimate)) %>%
  dplyr::select(
    denominator_target_cohort_name, duration,denominator_age_group, outcome_cohort_name, point_est_adj,
    cdm_name)


# calculating absolute difference between
results_inc_prev[["prevalence"]] %>%
  dplyr::filter(
    outcome_cohort_name != 'Any macrolide', #== 'Azithromycin', #%in% c('Clarithromycin', 'Erythromycin'),
    analysis_interval == 'overall',
    denominator_sex == 'Both',
    denominator_age_group %in% c('0 to 9'),
    denominator_target_cohort_name == 'Asthma',
    cdm_name == 'SIDIAP'
    #duration != '<30 days')
  )%>%
  # amount of people with specific disease is the same regardless of the 
  # duration of macrolide use, as macrolide use is not an inclusion criterion
  #dplyr::arrange(duration,outcome_cohort_name,desc(point_estimate)) %>%
  dplyr::select(
    denominator_target_cohort_name, duration,denominator_age_group, outcome_cohort_name, point_est_adj,
    cdm_name)
       