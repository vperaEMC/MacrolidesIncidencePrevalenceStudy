# import & processing data tables

library(dplyr)
library(stringr)
library(readr)
library(here)
library(visOmopResults)

# list all the db's contributing to analyses
names_db <- list(
  'SIDIAP' = 'sidiap',
  'IPCI' = 'ipci'
)

# list cohorts of interest to be displayed
cohorts_of_interest <- list(
  'asthma' = 1664,  
  'copd' = 1672,
  'aco' = 1673,
  'gen_pop_no_resp' = 1683
)

# list various durations
duration_ranges <- list(
  "short" = "short",
  "medium" = "medium",
  "long" = "long"
)

# types of data to be imported
data_types <- list(
  'demo' = NULL,
  'ecg' = NULL
)

# start with empty df
results_demo <- NULL
results_ecg <- NULL

# create loop to import and process results
for (i in seq_along(names_db)){
  for(j in seq_along(cohorts_of_interest)){
    for(k in seq_along(duration_ranges)){
      for(m in seq_along(data_types)){
        
        # compose file name
        file_name <- 
          paste0('comorb_comed_summarised_',
                 names(cohorts_of_interest)[j],
                 '_',
                 duration_ranges[[k]],
                 '.csv')
        
        file_name_ecg <- 
          paste0('ecg_',
                 names(cohorts_of_interest)[j],
                 '_',
                 duration_ranges[[k]],
                 '.csv')
        
        # assign cohort name
        cohort_name <-  paste0(names(cohorts_of_interest)[j],'_',duration_ranges[[k]])
        
        # import files
        if(names(data_types[m]) == 'demo'){
          df_demo_import <- 
            readr::read_csv(
              file = here::here('results',names_db[[i]],file_name),
              guess_max = 2^53) %>%
            dplyr::mutate(strata_level = dplyr::case_when(
              group_level != 'overall' ~ cohort_name,
              .default = 'overall')) %>%
            dplyr::mutate(strata_name = dplyr::case_when(
              group_level != 'overall' ~ 'Cohort, macrolide use period',
              .default = 'overall'))
          
          # remove last 4 rows settings-part, this will be readded later
          df_demo_trimmed <- 
            df_demo_import %>%
            dplyr::filter(row_number() <= n()-4)
          
          results_demo <- rbind(results_demo,df_demo_trimmed)}
        
        if(names(data_types[m]) == 'ecg'){
          results_ecg_import <- 
            readr::read_csv(
              file = here::here('results',names_db[[i]],file_name_ecg),
              guess_max = 2^53) %>%
            .[,-1] %>%
            dplyr::mutate(strata_level = cohort_name) %>%
            dplyr::mutate(strata_name = 'Cohort, macrolide use period') %>%
            dplyr::mutate(cdm_name = names(names_db[i]))
          
          
          # bind all result dataframes
          
          results_ecg <- rbind(results_ecg,results_ecg_import)}
      }
    }
  }
}


# extract table settings from one of the imported tables, doesnt matter which
table_setting_rows <- 
  df_demo_import %>%
  dplyr::filter(row_number() > n()-4)


# add the settings from one dataframe into the combined results dataframe
results_demo_with_settings <- rbind(results_demo, table_setting_rows)
results_ecg_with_settings <- rbind(results_ecg, table_setting_rows)


# a list of strings for column for renaming purposes
replacements <- 
  c('asthma' = 'Asthma', 'copd' = 'COPD', 'aco' = 'ACOS', 
    'gen_pop_no_resp' = 'Gen. pop.', '_' = ', ')

replacements_ecg <-
  c(
    'flag_ecg_m' = '', '_to_0' = '-0 days before', 
    'inf_to_inf' = 'Any time before and after'  )

# additional editing for appropriate row and column names
results_demo_clean <-
  results_demo_with_settings %>%
  dplyr::filter(
    !(
      variable_level == 'Systemic corticosteroids' & 
        variable_name == 'Comed name')) %>% 
  # both arguments needed to prevent deletion of rows with NA
  dplyr::mutate(
    variable_name = case_when(
      variable_name == 'Comed name' ~ 'Respiratory drug prescription, past year',
      variable_name == 'Comorb name' ~ 'History of comorbidities',
      variable_name == 'Number subjects' ~ 'Individuals, total',
      .default = variable_name
    ),
    variable_level = case_when(
      variable_level == 'Lama inc combo' ~ 'LAMA',
      variable_level == 'Ics all including combinations saba sama laba lama etc' ~
        'ICS',
      variable_level == 'Systemic corticosteroids only oral' ~
        'Systemic corticosteroids, oral',
      variable_level == 'Saba' ~ 'SABA',
      variable_level == 'Sama' ~ 'SAMA',
      variable_level == 'Laba inc combo' ~ 'LABA',
      variable_level == 'Montelukast ltra' ~ 'Montelukast',
      variable_level == 'Methylxanthines' ~ 'Methylxanthines (Theophylline)',
      variable_level == 'Cromones' ~ 'Cromones',
      variable_level == 'Roflumilast pde5i' ~ 'PDE5i\'s (Roflumilast)',
      variable_level == 'Gerd' ~ 'GERD',
      .default = variable_level)) %>%
  dplyr::mutate(
    across(
      'strata_level', 
      \(x) stringr::str_replace_all(
        x, replacements)))

# additional editing for appropriate row and column names
results_ecg_clean <-
  results_ecg_with_settings %>%
  dplyr::mutate(
    variable_name = case_when(
      variable_name == 'number subjects' ~ 'Individuals, total',
      .default = variable_name
    )) %>%
  dplyr::mutate(variable_level = case_when(
    variable_name != 'settings' ~ variable_name,
    .default = NULL
  )) %>%
  dplyr::mutate(
    across(
      'strata_level', 
      \(x) stringr::str_replace_all(
        x, replacements))) %>%
  dplyr::mutate(
    across(
      'variable_level', 
      \(x) stringr::str_replace_all(
        x, replacements_ecg)))

# put demo and ecg results in list for easier processing purposes

list_results_ecg_demo <- NULL
list_results_ecg_demo <-
  list(
    'results_demo_clean' = results_demo_clean,
    'results_ecg_clean' = results_ecg_clean
  )

# make empty list object for the table_formatted tables to be exported
final_tables <- list()


# formatting the with visOmopResults functions & more
for(i in seq_along(list_results_ecg_demo)){
  table_formatted <-
    list_results_ecg_demo[[i]] %>%
    dplyr::filter(!(variable_name %in% c('Number records','number records',
                                         'Cohort start date','cohort_start_date',
                                         'Cohort end date','cohort_end_date',
                                         'Prior observation',
                                         'Future observation'))) %>%
    dplyr::select(!(c('additional_name','additional_level',
                      'result_id', 'group_name', 'group_level'))) %>%
    {if(names(list_results_ecg_demo[i]) == 'results_demo_clean')
      dplyr::filter(.,!estimate_name %in% c('min','max','mean','sd')) else .} %>%
    {if(names(list_results_ecg_demo[i]) ==  'results_ecg_clean')
      dplyr::filter(.,!estimate_name %in% c('min','max','mean','sd',
                                            'median','q25','q75')) else .} %>%
    visOmopResults::formatEstimateValue(.,
                                        decimals = c(integer = 0, numeric = 0, 
                                                     percentage = 0, 
                                                     proportion = 0),
                                        decimalMark = '.',
                                        bigMark = ',') %>%
    {if(names(list_results_ecg_demo[i]) == 'results_demo_clean')
      visOmopResults::formatEstimateName(.,
                                         estimateNameFormat = c(
                                           'N%' = '<count> (<percentage>)',
                                           'N' = '<count>',
                                           'Median (IQR)' = '<median> (<q25>-<q75>)'),
                                         keepNotFormatted = FALSE,
                                         useFormatOrder = FALSE) else .} %>%
    {if(names(list_results_ecg_demo[i]) ==  'results_ecg_clean')
      visOmopResults::formatEstimateName(.,estimateNameFormat = c(
                                           'N%' = '<count> (<percentage>)',
                                           'N' = '<count>'),
                                         keepNotFormatted = FALSE,
                                         useFormatOrder = FALSE) %>%
        dplyr::filter(estimate_type != 'numeric') else .} %>%
    visOmopResults::formatHeader(
      header = c('strata_name','strata_level'),
      delim = '\n',
      includeHeaderName = FALSE,
      includeHeaderKey = FALSE) %>%
    dplyr::mutate(
      across(6:ncol(.),
             \(x) stringr::str_replace_na(x))) %>%
    dplyr::mutate(
      across(6:ncol(.),
             \(x) stringr::str_replace_all(
               x, pattern = '(?<!\\d)[0-4]\\s\\(\\d\\)|NA', replacement='<5 (NA)'))) %>%
    dplyr::mutate(
      across(6:ncol(.),
             \(x) stringr::str_replace_all(
               x, pattern = '\\(0\\)', replacement='(<1)'))) %>%
    dplyr::mutate_all(~na_if(.,'IGNORE')) %>%
    dplyr::select(!('estimate_type')) %>%
    dplyr::rename(
      'Variable' = 'variable_name',
      'Category' = 'variable_level',
      'Unit of measure' = 'estimate_name',
      'Database' = 'cdm_name') 
  
  # adding the settings from one dataframe into the combined results dataframe
  # needed later for functions to accept the table for processing
  final_tables[[i]] <- table_formatted
  names(final_tables)[i] <- names(list_results_ecg_demo)[i]
  
  
  
  # Introduce factor levels to get the desired order within the tables
  
  if(names(final_tables)[i] == 'results_demo_clean'){
    final_tables[[i]]$Variable <-
      factor(
        final_tables[[i]]$Variable,
        levels = c('Individuals, total','Age','Sex','History of comorbidities',
                   'Respiratory drug prescription, past year'))
    
    final_tables[[i]]$Category <-
      factor(
        final_tables[[i]]$Category,
        levels = c('Female','Male','ICS',
                   'Systemic corticosteroids, oral', 'SABA','LABA','SAMA',
                   'LAMA','Montelukast','Methylxanthines (Theophylline)','Cromones',
                   'PDE5i\'s (Roflumilast)', 'Cardiovascular diseases','Pneumonia',
                   'Obesity', 'GERD','Diabetes mellitus')
      )
  }
  
  if(names(final_tables)[i] == 'results_ecg_clean'){
    final_tables[[i]]$Category <-
      factor(
        final_tables[[i]]$Category,
        levels = c('Individuals, total', '7-0 days before','14-0 days before',
                   '30-0 days before','60-0 days before', 
                   'Any time before and after'))
  }
  
  
  # factor database names
  final_tables[[i]]$Database <-
    factor(
      final_tables[[i]]$Database,
      levels = c('SIDIAP','IPCI'),
      labels = c('SIDIAP','IPCI'))
  
  # for ease of table processing
  selected_table <- final_tables[[i]]
  
  # arrange based on factors
  if(names(final_tables)[i] == 'results_demo_clean'){
    final_tables_ordered <- selected_table[
      order(
        selected_table$Database,
        selected_table$Variable,
        selected_table$Category),] #yes, that last comma needs to stay
  }
  
  if(names(final_tables)[i] == 'results_ecg_clean'){
    final_tables_ordered <- selected_table[
      order(
        selected_table$Database,
        selected_table$Category),]
    
    final_tables_ordered <-
      final_tables_ordered %>%
      dplyr::mutate(Variable = 'Time window for ECG measure')
    
  }
  
  # add temporary table titles
  if(names(final_tables)[i] == 'results_demo_clean'){
    title <- 'Baseline characteristics of cohorts upon the first macrolide use after cohort entry'
  }
  
  if(names(final_tables)[i] == 'results_ecg_clean'){
    title <- 'Presence of a registered ECG procedure in respect to the first macrolide prescription after cohort entry'
  }
  
  # final step to get the table suitable for graphic display
  final_tables_graphical <- 
    visOmopResults::gtTable(
      x = final_tables_ordered,
      style = 'default',
      title = title,
      groupAsColumn = FALSE,
      colsToMergeRows = 'all_columns'
    )
  
  # export graph (html-files can be opened in excel :)
  tablename <- names(final_tables)[i]
  gt::gtsave(final_tables_graphical, here::here('results',paste0('table_',tablename,'.html')))
}
