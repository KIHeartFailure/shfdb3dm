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

rsdata301 <- rsdata
rsdatanum301 <- rsdatanum

# RData

save(file = "./data/v301/rsdata301.RData", list = c("rsdata301"))
save(file = "./data/v301/rsdatanum301.RData", list = c("rsdatanum301"))

# Txt

write.table(rsdata301, file = "./data/v301/rsdata301.txt", quote = FALSE, sep = "\t", row.names = FALSE)
write.table(rsdatanum301, file = "./data/v301/rsdatanum301.txt", quote = FALSE, sep = "\t", row.names = FALSE)
