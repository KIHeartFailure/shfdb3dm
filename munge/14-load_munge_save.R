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

save(file = "./data/rsdata_for_webb.RData", list = c("rsdata", "flow", "ncontrols", "outcommeta", "ccimeta", "deathmeta"))

# Version number

rsdata300 <- rsdata
rsdatanum300 <- rsdatanum

# RData

save(file = "./data/v300/rsdata300.RData", list = c("rsdata300"))
save(file = "./data/v300/rsdatanum300.RData", list = c("rsdatanum300"))

# Txt

write.table(rsdata300, file = "./data/v300/rsdata300.txt", quote = FALSE, sep = "\t", row.names = FALSE)
write.table(rsdatanum300, file = "./data/v300/rsdatanum300.txt", quote = FALSE, sep = "\t", row.names = FALSE)
