################################################################################
########################## TEST PATIENTS INPUT #################################
################################################################################

#test_file <- 'test_subjects_asthma_ages_focus.xlsx'
#test_file <- 'test_subjects_cdm_tables.xlsx'
test_file <- 'test_subjects_asthma_365_v2.xlsx'

################################################################################
######################### CDM SUBSET PARAMETER #################################
################################################################################

cohorts_of_interest <- list(
  #"copd" = 1617,
  #"aco" = 1618,
  #"asthma" = 1616
  "asthma" = 1664)

################################################################################
###################### INCIDENCE/PREVALENCE INPUT ##############################
################################################################################

duration_ranges <- list(
  "no_restriction" = c(1,Inf)
)

age_groups_analysis <- 
  list(
    #c(0,9), c(10,19), c(20,29), c(30,39),c(40,49),c(50,59),c(60,69),
    #c(70,79),c(80,89),c(90,99),c(100,109),
    #c(110,120),
    c(0,120)
    )

sexes_analysis <- c("Both")

time_interval <- c("overall")

num_prior_use_washout <- 365
gap_era <- 7
impute_duration <- "none"
prior_observation <- 0
limit <- "all"
min_cell_count <- 0
