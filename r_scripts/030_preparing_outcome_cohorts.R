library(CodelistGenerator)

# import necessary concept sets
ecg_concept_ids <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/ecg/ecg.json"),
    cdm = cdm_asthma,
    withConceptDetails = FALSE)

concept_set_azithromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_azithromycin.json"),
    cdm = cdm_asthma,
    withConceptDetails = FALSE)

concept_set_clarithromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_clarithromycin.json"),
    cdm = cdm_asthma,
    withConceptDetails = FALSE)

concept_set_erythromycin <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/vp_ingredient_erythromycin.json"),
    cdm = cdm_asthma,
    withConceptDetails = FALSE)

concept_set_azi_clar_ery <- 
  CodelistGenerator::codesFromConceptSet(
    path = here::here("concept_sets/drugs/azi_clar_ery.json"),
    cdm = cdm_asthma,
    withConceptDetails = FALSE)

# concatenate all drug related conceptsets
all_concept_ids <- 
  c(
    concept_set_azithromycin,
    concept_set_clarithromycin,
    concept_set_erythromycin,
    concept_set_azi_clar_ery)