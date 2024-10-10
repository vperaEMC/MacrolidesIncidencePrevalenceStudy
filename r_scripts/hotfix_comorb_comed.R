for(i in seq_along(cohorts_of_interest)){
  
  comorb_comed_summarised <- results_comorb_comed[[i]]
  
comorb_comed_name <- paste0("comorb_comed_summarised_",names(cohorts_of_interest)[i],".csv")

omopgenerics::exportSummarisedResult(comorb_comed_summarised,
                                     fileName = comorb_comed_name,
                                     path = here::here("Macrolides_v2"))
}