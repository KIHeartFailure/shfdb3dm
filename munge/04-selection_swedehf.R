
flow <- c("No of posts in SwedeHF", nrow(rsdata))

# remove duplicated indexdates
rsdata <- rsdata %>%
  group_by(LopNr, shf_indexdtm) %>%
  arrange(shf_source) %>%
  slice(1) %>% # remove 621 observations, se check_duplicates_rs_200228.R
  ungroup()

flow <- rbind(flow, c("Remove posts with duplicated index dates", nrow(rsdata)))

rsdata <- left_join(rsdata,
  pnr_bytt_ater,
  by = "LopNr"
)

rsdata <- rsdata %>%
  filter(is.na(AterPnr) & is.na(ByttPnr)) # reused/changed personr

flow <- rbind(flow, c("Remove posts with reused or changed PINs", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(shf_age >= 18 & !is.na(shf_age))

flow <- rbind(flow, c("Remove posts < 18 years", nrow(rsdata)))

rsdata <- rsdata %>%
  filter((shf_indexdtm < shf_deathdtm | is.na(shf_deathdtm))) # enddate prior to indexdate

flow <- rbind(flow, c("Remove posts with end of follow-up <= index date (died in hospital)", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(shf_indexdtm <= ymd("2018-12-31")) %>%
  select(-ByttPnr, -AterPnr)

flow <- rbind(flow, c("Remove posts with with index date > 2018-12-31", nrow(rsdata)))

flow <- rbind(flow, c("Unique patients", nrow(rsdata %>% group_by(LopNr) %>% slice(1))))
