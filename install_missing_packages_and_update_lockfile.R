# install missing packages
install.packages("remotes")
library(remotes)
remotes::install_github("OHDSI/CirceR@v1.3.3")

# install testgenerator to test locally
install.packages("TestGenerator")

# snapshot library
renv::settings$snapshot.type("all")
renv::snapshot()

# isolate just once when you are ready to give package to someone else
renv::isolate()
