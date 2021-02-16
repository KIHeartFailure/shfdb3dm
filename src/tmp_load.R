

memory.limit(size = 10000000000000)

ProjectTemplate::reload.project()

load("./data/rawData_rs.RData")
load("./data/rawData_scb.RData")
load("./data/rawData_enheter.RData")

# run 01-07
source("./munge/01-clean_missing_swedehf.R")
source("./munge/02-merge_swedehf.R")
source("./munge/03-clean_outliers_swedehf.R")
source("./munge/04-selection_swedehf.R")
source("./munge/05-controls_scb.R")
source("./munge/06-countryofbirth_scb.R")
source("./munge/07-lisa_scb.R")

save(file = "./data/rsdata_rs_scb.RData", list = c("rsdata", "flow", "migration"))

ProjectTemplate::reload.project()
load("./data/rawData_sossv.RData")
load("./data/rawData_sosov.RData")

# run 08
source("./munge/08-prep_sosdata.R")

save(file = "./data/patreg.RData", list = c("patreg"))

ProjectTemplate::reload.project()
load(file = "./data/rsdata_rs_scb.RData")
load(file = "./data/patreg.RData")
load("./data/rawData_sosdors.RData")

# run 09-14
source("./munge/09-endtime.R")
source("./munge/10-outcom_sos.R")
source("./munge/11-charlsoncomorbindex_sos.R")
source("./munge/12-death_sos.R")
source("./munge/13-niceties.R")
source("./munge/14-save.R")

save(file = "./data/rsdata.RData", list = c("rsdata"))
