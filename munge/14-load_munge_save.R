# 1. Set options in config/global.dcf
# 2. Load packages listed in config/global.dcf
# 3. Import functions and code in lib directory
# 4. Load data in data directory
# 5. Run data manipulations in munge directory

ProjectTemplate::reload.project(
  reset = TRUE,
  data_loading = TRUE,
  munging = TRUE
)

# For webb only

save(
  file = "./data/rsdata_for_webb.RData",
  list = c("rsdata", "flow", "ncontrols", "outcommeta", "ccimeta", "deathmeta")
)

# Version number

version <- "312"

assign(paste0("rsdata", version), rsdata)
assign(paste0("rsdatanum", version), rsdatanum)

dir.create(paste0("./data/v", version))

# RData

save(
  file = paste0("./data/v", version, "/rsdata", version, ".RData"),
  list = c(paste0("rsdata", version))
)
save(
  file = paste0("./data/v", version, "/rsdatanum", version, ".RData"),
  list = c(paste0("rsdatanum", version))
)

# Txt

write.table(rsdata,
  file = paste0("./data/v", version, "/rsdata", version, ".txt"),
  quote = FALSE, sep = "\t", row.names = FALSE, na = ""
)
write.table(rsdatanum,
  file = paste0("./data/v", version, "/rsdatanum", version, ".txt"),
  quote = FALSE, sep = "\t", row.names = FALSE, na = ""
)

# Stata 14

write_dta(rsdata,
  path = paste0("./data/v", version, "/rsdata", version, ".dta"),
  version = 14
)
write_dta(rsdatanum,
  path = paste0("./data/v", version, "/rsdatanum", version, ".dta"),
  version = 14
)
