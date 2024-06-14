# testing out stuff with MASS
renv::restore(packages = 'MASS')
renv::deactivate()
renv::activate()

# there seems to be a problem with the version of MASS registered in the lock
# file when trying to install it on R version 4.4.0 and 4.3.2
# the stategy now is the make a seperate lockfile for R version 4.3.2 and test 
# out installation on both R versions of SIDIAP.

# select R version 4.3.2 under global options, restart RStudio, and update 
# the lockfile

renv::status(lockfile = 'renv_sidiap_r_version_4_3_2.lock')

# r version is different and system packages need to be updated.
renv::snapshot(lockfile = 'renv_sidiap_r_version_4_3_2.lock', update = TRUE)

renv::restore(lockfile = 'renv.lock')

renv::snapshot()
