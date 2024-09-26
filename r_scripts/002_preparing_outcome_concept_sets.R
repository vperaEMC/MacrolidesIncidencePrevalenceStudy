################################################################################
####################### DRUG & ECG CONCEPT SETS ################################
################################################################################

# import necessary concept sets
ecg_concept_ids <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/ecg/ecg.json"),
    cdm = cdm,
    withConceptDetails = FALSE)

concept_set_azithromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_azithromycin.json"),
    cdm = cdm,
    withConceptDetails = FALSE)

concept_set_clarithromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_clarithromycin.json"),
    cdm = cdm,
    withConceptDetails = FALSE)

concept_set_erythromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_erythromycin.json"),
    cdm = cdm,
    withConceptDetails = FALSE)

concept_set_azi_clar_ery <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/azi_clar_ery.json"),
    cdm = cdm,
    withConceptDetails = FALSE)

# concatenate all drug related conceptsets
all_concept_ids <- 
  c(
    concept_set_azithromycin,
    concept_set_clarithromycin,
    concept_set_erythromycin,
    concept_set_azi_clar_ery)

################################################################################
################################## COMEDICATION ################################
################################################################################

# load concept sets for comedication of interest
concept_set_comedication <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets", "drugs_comedication"),
    cdm = cdm,
    withConceptDetails = FALSE)

################################################################################
################################## COMORBIDITIES ###############################
################################################################################

# load concept sets for comorbidities of interest from json
concept_ids_comorbidities_json <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets", "comorbidities_json"),
    cdm = cdm,
    withConceptDetails = FALSE)

# collect paths to csv
path_comorbidities <- here::here("concept_sets","comorbidities_csv")

# list csv
list_csv <- list.files(path_comorbidities, full.names = TRUE)
names_csv <- list.files(path_comorbidities) 
names_csv <- stringr::str_sub(names_csv, end = -5)

# for looping to get all needed from csv
concept_ids_comorbidities_csv <- list()

for (i in 1:length(list_csv)){
  comorbidity <- read.csv(list_csv[i]) %>%
    filter(!is.na(concept_id))
  
  concept_ids_comorbidities_csv[[names_csv[i]]] <- comorbidity$concept_id
}

concept_set_comorbidities <-c(concept_ids_comorbidities_csv,concept_ids_comorbidities_json)

rm(cdm)