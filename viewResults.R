# A problem when exporting and reimporting results is that some metadata is lost
# so a temporary solution is to use omopgenerics to put the metadata back in
# if it is desired to view the results in a table format from the following function:
# CohortCharacteristics::tableCharacteristics()

################################################################################
######################       META DATA FIXER              ###################### 
################################################################################

# so only necessary when object leave R-environment
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

# comorbidities & comedication
CohortCharacteristics::tableCharacteristics(results_lsc$)

# demographics
CohortCharacteristics::tableCharacteristics(results_demographics$)

# large scale characterization
CohortCharacteristics::tableLargeScaleCharacteristics(your_result)

# ecg
View(ecg_results$...)

# for drug utilisation tables, view private link attached in email