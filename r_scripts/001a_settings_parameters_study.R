################################################################################
######################### CDM SUBSET PARAMETER #################################
################################################################################

cohorts_of_interest <- list(
  'asthma' = 1664,
  'copd' = 1672,
  'aco' = 1673,
  'gen_pop_no_resp' = 1683)

path_setting_cohort <- here::here("inst/cohorts")

################################################################################
###################### INCIDENCE/PREVALENCE INPUT ##############################
################################################################################

# minimal cell count
min_cell_count <- 5

# time interval
time_interval <- c("overall","years")

# list all the duration ranges of interest
duration_ranges <- list(
  "long" = c(180,Inf),
  "short" = c(1,29),
  "medium" = c(30,179),
  "long_old" = c(30,inf)
)

# age groups of interest
age_groups_analysis <- 
  list(
    c(0,9),c(10,19), c(20,29), c(30,39),
    c(40,49),c(50,59),c(60,69),c(70,79),
    c(80,89),c(90,100),
    c(0,100))

# sexes
sexes_analysis <- c("Both", "Female", "Male")