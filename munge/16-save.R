
# For webb only

save(
  file = "./data/rsdata_for_webb.RData",
  list = c("rsdata", "flow", "ncontrols", "outcommeta", "ccimeta", "deathmeta")
)

# Version number

version <- "327"

assign(paste0("rsdata", version), rsdata)

dir.create(paste0("./data/v", version))

# RData

save(
  file = paste0("./data/v", version, "/rsdata", version, ".RData"),
  list = c(paste0("rsdata", version))
)

# Txt

write.table(rsdata,
  file = paste0("./data/v", version, "/rsdata", version, ".txt"),
  quote = FALSE, sep = "\t", row.names = FALSE, na = ""
)

# Stata 14

write_dta(rsdata,
  path = paste0("./data/v", version, "/rsdata", version, ".dta"),
  version = 14
)