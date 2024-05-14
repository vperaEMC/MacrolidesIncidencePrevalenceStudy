# filter based on years and export
prev_years_copd <- rbind(prev_copd_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(prevalence_start_date,1,4)))
write.csv(prev_years_copd, here::here("Macrolides/prev_years_copd.csv"))


prev_years_asthma<- rbind(prev_asthma_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(prevalence_start_date,1,4)))
write.csv(prev_years_asthma, here::here("Macrolides/prev_years_asthma.csv"))


prev_years_aco <- rbind(prev_aco_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(prevalence_start_date,1,4)))
write.csv(prev_years_aco, here::here("Macrolides/prev_years_aco.csv"))


prev_years_general_population <- rbind(prev_general_population_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(prevalence_start_date,1,4)))
write.csv(prev_years_general_population, here::here("Macrolides/prev_years_general_population.csv"))