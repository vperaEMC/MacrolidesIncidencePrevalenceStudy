library(DBI)
library(here)
library(RPostgres)

# set the wd
setwd(here::here())

#get configuration settings from your config.yml file
config <- config::get('database')

#input here your db configuration settings
Sys.setenv(DBMS = config$dbms)
Sys.setenv(JDBC_DRIVER = config$driver)
Sys.setenv(DB_SERVER = config$server)
Sys.setenv(DB_PORT = config$port)
Sys.setenv(DB_NAME = config$dbname)

Sys.setenv(DB_USER = config$user)
Sys.setenv(DB_PASSWORD = config$password)

Sys.setenv(SERVER = paste0(Sys.getenv("DB_SERVER"), "/", Sys.getenv("DB_NAME")))
Sys.setenv(CDMSCHEMA = "cdm")
Sys.setenv(RESULTSSCHEMA = "results")
Sys.setenv(TEMPSCHEMA = "temp")

dbms <- Sys.getenv("DBMS")
databaseServer <- Sys.getenv("DB_SERVER")
databasePort <- Sys.getenv("DB_PORT")
databaseName <- Sys.getenv("DB_NAME")
databaseUser <- if (Sys.getenv("DB_USER") == "") NULL else Sys.getenv("DB_USER")
databasePassword <- if (Sys.getenv("DB_PASSWORD") == "") NULL else Sys.getenv("DB_PASSWORD")

# make the db connection
dbiConnection <- DBI::dbConnect(RPostgres::Postgres(),
                                dbname = databaseName,
                                host = databaseServer,
                                port = databasePort,
                                user = databaseUser,
                                password = databasePassword)

databaseCDMSchema <- Sys.getenv("CDMSCHEMA")

# make the CDM object, use connection details from previously
cdm <- CDMConnector::cdm_from_con(
  con = dbiConnection,
  cdm_schema = databaseCDMSchema
)