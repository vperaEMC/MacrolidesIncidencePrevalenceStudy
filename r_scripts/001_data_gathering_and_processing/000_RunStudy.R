library(here)

# setwd to the testscripts folder
setwd(here::here("r_scripts","001_data_gathering_and_processing"))
getwd()

# apply parameter settings for study
source("001a_settings_parameters_study.R")

# make the subsets from the cdm
source("001d_creating_cdm_cohorts.R")

# create outcome definitions
source("002_preparing_outcome_concept_sets.R")

# run prevalence and incidence analysis
source("003_prevalences_and_incidences.R")

# run ecg analysis
source('121_ecg_demo_lsc_comed_comorb.R')