# script for running all r-files

scripts_to_execute <- list.files(
  path = here::here("r_scripts"),
  full.names = TRUE)
scripts_to_execute

# execute scripts
for (scripts in scripts_to_execute){
  source(scripts,
         echo = TRUE)
}