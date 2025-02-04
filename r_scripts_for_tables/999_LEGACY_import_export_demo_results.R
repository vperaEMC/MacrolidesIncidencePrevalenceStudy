# A problem when exporting and reimporting results is that some metadata is lost
# so a solution is to use omopgenerics to put the metadata back in if it is 
# desired to view the results in a table format from the following function:
# CohortCharacteristics::tableCharacteristics()

################################################################################
######################       META DATA FIXER              ###################### 
################################################################################

# so only necessary when object leave R-environment (i.e. when exported)
your_result_imported <- readr::read_csv(
  file = "your_result",
  guess_max = 2^53) %>%
  dplyr::select(-1) #double check if necessary

your_result_imported_readable  <- 
  omopgenerics::newSummarisedResult(
    x = your_result_imported, 
    settings = tibble::tibble(result_id = 1,
                              package_name = "CohortCharacteristics", 
                              package_version = "0.2.0",
                              result_type = "summarised_characteristics")) 
# OR:
# "summarised_large_scale_characteristics"                                                                                                                       result_type = "summarised_characteristics"))

################################################################################
###################      FUNCTIONS TO VIEW RESULTS        ###################### 
################################################################################

# comorbidities & comedication (& other demographics)
CohortCharacteristics::tableCharacteristics(results_comorb_comed$first_time_users_asthma_medium) 
#OR: substitute with "your_result_imported_readable" from previously

# large scale characterization
CohortCharacteristics::tableLargeScaleCharacteristics(results_lsc$first_time_users_copd_long)

# ecg
View(results_ecg$asthma)

# for drug utilisation tables, view private link attached in email