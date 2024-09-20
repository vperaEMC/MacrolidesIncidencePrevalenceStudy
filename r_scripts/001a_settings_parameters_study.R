################################################################################
######################### CDM SUBSET PARAMETER #################################
################################################################################

cohorts_of_interest <- list(
  'asthma' = 1664,
  'copd' = 1672,
  'aco' = 1673)

################################################################################
###################### INCIDENCE/PREVALENCE INPUT ##############################
################################################################################

# minimal cell count
min_cell_count <- 5

# time interval
time_interval <- c("overall","years")

# list all the duration ranges of interest
duration_ranges <- list(
  "short" = c(1,29),
  "long" = c(30,Inf),
  "no_restriction" = c(1,Inf)
)

# age groups of interest
age_groups_analysis <- 
  list(
    c(0,9),c(10,19), c(20,29), c(30,39),
    c(40,49),c(50,59),c(60,69),c(70,79),
    c(80,89),c(90,99),c(100,109),c(110,120),
    c(0,120))

# sexes
sexes_analysis <- c("Both", "Female", "Male")