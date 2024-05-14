inc_years_copd <- rbind(inc_copd_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(incidence_start_date,1,4)))
write.csv(inc_years_copd,here::here("Macrolides/inc_years_copd.csv"))

inc_years_asthma<- rbind(inc_asthma_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(incidence_start_date,1,4)))
write.csv(inc_years_asthma,here::here("Macrolides/inc_years_asthma.csv"))

inc_years_aco <- rbind(inc_aco_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(incidence_start_date,1,4)))
write.csv(inc_years_aco,here::here("Macrolides/inc_years_aco.csv"))

inc_years_general_population <- rbind(inc_general_population_adj) %>%
  filter(analysis_interval=="years") %>%
  mutate(year = as.integer(stringr::str_sub(incidence_start_date,1,4)))
write.csv(inc_years_general_population,here::here("Macrolides/inc_years_general_population.csv"))