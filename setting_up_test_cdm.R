library(TestGenerator)
library(here)

# read the patients
TestGenerator::readPatients.xl(
  filePath = here::here("testpatients", "macro_test_p_v3.xlsx"),
  testName = "test_macro",
  outputPath = tempdir(),
  cdmVersion = "5.3"
)

# make the cdm object
cdm <- TestGenerator::patientsCDM(pathJson = tempdir(), 
                                  testName = "test_macro",
                                  cdmVersion = "5.3")
