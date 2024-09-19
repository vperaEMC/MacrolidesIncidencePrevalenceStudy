library(here)

# setwd to the testscripts folder
setwd(here::here("r_scripts_tests"))
getwd()

# apply test settings OR full settings
source("010_test_settings.R")
#source("020_real_executions_settings.R")


# make the appropriate test cdms
source("001_testgenerator_new_test_cdm.R")

# create outcome definitions
source("002_preparing_outcome_concept_sets.R")

# make the subsets from the cdm
source("002_making_other_test_cdms.R")


# run prevalence and incidence analysis
source("003_prevalences_and_incidences.R")

# run ecg analysis
source("121_ecg_summary.R")

# run lsc and demographics analysis
source("131_demo_lsc_chronic_users.R")

# run comedication and comorbidity analysis
source("140_comed_comorb.R")
