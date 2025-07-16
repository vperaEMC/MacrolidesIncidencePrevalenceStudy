library(here)
library(dplyr)
library(scales)
library(ggplot2)
library(stringr)

# list all the db's contributing to analyses
names_db <- list(
  'ipci' = 'ipci',
  'sidiap' = 'sidiap'
)

# empty R object needed for starters
prev_all_estimates <- NULL
inc_all_estimates <- NULL

# import all prevalence estimates
for (i in seq_along(names_db)){
  prev_one_db <- 
    read.csv(
      file = here::here('results',names_db[[i]],'prev_all_estimates.csv')
      )
  
  # bind all the dataframes
  prev_all_estimates <- rbind(prev_all_estimates,prev_one_db)
  
  inc_one_db <- 
    read.csv(
      file = here::here('results',names_db[[i]],'inc_all_estimates.csv')
    )
  
  # bind all the dataframes
  inc_all_estimates <- rbind(inc_all_estimates,inc_one_db)
}

results_inc_prev <- list(
  'prevalence' = prev_all_estimates,
  'incidence' = inc_all_estimates
)

for (i in seq_along(results_inc_prev)){
results_inc_prev[[i]] <-
  results_inc_prev[[i]] %>%
  dplyr::mutate(
    outcome_cohort_name = dplyr::case_when(
      outcome_cohort_name == 'vp_ingredient_azithromycin' ~ 'Azithromycin',
      outcome_cohort_name == 'vp_ingredient_erythromycin' ~ 'Erythromycin',
      outcome_cohort_name == 'vp_ingredient_clarithromycin' ~ 'Clarithromycin',
      outcome_cohort_name == 'azi_clar_ery' ~ 'Macrolides',
    ),
    denominator_target_cohort_name = dplyr::case_when( 
      denominator_target_cohort_name == 'cohort_1664' ~ 'Asthma',  ####
      denominator_target_cohort_name == 'cohort_1672' ~ 'COPD', 
      denominator_target_cohort_name == 'cohort_1673' ~ 'ACO', 
      denominator_target_cohort_name == 'cohort_1683' ~ 'Gen. pop.',
      .default = 'General population'
    ),
    denominator_target_cohort_integer = dplyr::case_when( 
      denominator_target_cohort_name == 'Asthma' ~ '1',
      denominator_target_cohort_name == 'COPD' ~ '2', 
      denominator_target_cohort_name == 'ACO' ~ '3', 
      denominator_target_cohort_name == 'Gen. pop.' ~ '4', 
      .default = 'General population'
    )) %>%
  dplyr::mutate(denominator_target_cohort_integer = as.integer(denominator_target_cohort_integer)) %>%
  dplyr::filter(!(denominator_age_group == '30 to 39' & denominator_target_cohort_name %in% c('ACO','COPD'))) %>%
  dplyr::filter(denominator_target_cohort_name != 'General population') %>%
  dplyr::rename(duration = denominator_cohort_name) %>%
  dplyr::mutate(
    duration = dplyr::case_when(
      stringr::str_detect(duration, '_short$',) ~ '<30 days',
      stringr::str_detect(duration, '_long$',) ~ '=>180 days', #unicode \U2265 works good in table, but not in console. But now its more easy searchable
      stringr::str_detect(duration, '_medium$',) ~ '30-179 days')
  ) %>%
  {if(names(results_inc_prev[i]) == 'prevalence')
    dplyr::mutate(., 
                  point_est_adj = scales::percent(prevalence, accuracy = 0.1)) %>%
      dplyr::mutate(year = as.integer(stringr::str_sub(.[[3]],1,4))) %>%
      dplyr::mutate(dplyr::across(c(5,7:9), ~ ifelse(n_cases==0, NA,.))) %>%
      dplyr::mutate(point_estimate = prevalence) %>%
      dplyr::rename(lower_95CI = prevalence_95CI_lower) %>%
      dplyr::rename(upper_95CI = prevalence_95CI_upper)
    else .} %>% 
  {if(names(results_inc_prev[i]) == 'incidence')
    mutate(.,point_est_adj = 
             format(round(incidence_100000_pys,0), nsmall =0, big.mark=",")) %>%
      dplyr::mutate(year = as.integer(stringr::str_sub(.[[6]],1,4))) %>%
      dplyr::mutate(dplyr::across(9:11, ~ ifelse(n_events==0, NA,.))) %>%
      dplyr::mutate(point_estimate = incidence_100000_pys) %>%
      dplyr::rename(lower_95CI = incidence_100000_pys_95CI_lower) %>%
      dplyr::rename(upper_95CI = incidence_100000_pys_95CI_upper)
    else .}

# the order of groups is specific, just like secondary axis specification
# so we will establish that by refactoring & establishing the levels

# needed for secondary axis purposes
# factor the target population
results_inc_prev[[i]]$denominator_target_cohort_integer <-
  as.numeric(factor(
    results_inc_prev[[i]]$denominator_target_cohort_integer,
    levels = c(
      1,2,3,4
      ),
    labels = c('Asthma', 'COPD', 'ACO', 'Gen. pop.')
    )
    )

# factor the target population
results_inc_prev[[i]]$denominator_target_cohort_name <-
  factor(
    results_inc_prev[[i]]$denominator_target_cohort_name,
    levels = c('Asthma', 'COPD', 'ACO', 'Gen. pop.'
    ),
    labels = c('Asthma', 'COPD', 'ACO', 'Gen. pop.')
  )

# factor the drug names
results_inc_prev[[i]]$outcome_cohort_name <-
  factor(
    results_inc_prev[[i]]$outcome_cohort_name,
    levels = c(
      'Macrolides', 'Azithromycin', 'Clarithromycin','Erythromycin'
    ),
    labels = c(
      'Any macrolide', 'Azithromycin', 'Clarithromycin','Erythromycin'
    )
  )

# factor length of use
results_inc_prev[[i]]$duration <-
  factor(
    results_inc_prev[[i]]$duration,
    levels = c('<30 days','30-179 days', '=>180 days'),
    labels = c('<30 days','30-179 days', paste0('\U2265','180 days')) #unicode insert
  )

# factor the age-groups
results_inc_prev[[i]]$denominator_age_group <-
  factor(
    results_inc_prev[[i]]$denominator_age_group,
    levels = c(
      "0 to 9", "10 to 19", "20 to 29", "30 to 39","40 to 49", "50 to 59", 
      "60 to 69", "70 to 79", "80 to 89", "90 to 100", "0 to 100"
    ),
    labels = c(
      "0 to 9", "10 to 19", "20 to 29", "30 to 39","40 to 49", "50 to 59", 
      "60 to 69", "70 to 79", "80 to 89", "90 to 100", "All ages"
    )
  )

# factor cdm_name
results_inc_prev[[i]]$cdm_name <-
  factor(
    results_inc_prev[[i]]$cdm_name,
    levels = c('SIDIAP','IPCI'),
    labels = c('SIDIAP','IPCI')
  )
}
