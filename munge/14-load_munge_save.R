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

rsdata302 <- rsdata
rsdatanum302 <- rsdatanum

# RData

save(file = "./data/v302/rsdata302.RData", list = c("rsdata302"))
save(file = "./data/v302/rsdatanum302.RData", list = c("rsdatanum302"))

# Txt

write.table(rsdata302, file = "./data/v302/rsdata302.txt", quote = FALSE, sep = "\t", row.names = FALSE)
write.table(rsdatanum302, file = "./data/v302/rsdatanum302.txt", quote = FALSE, sep = "\t", row.names = FALSE)
