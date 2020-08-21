
# koll <- migration %>%
#  filter(Posttyp == "Utv") %>%
#  group_by(lopnr) %>%
#  slice(2) %>%
#  ungroup() %>%
#  count()

migration <- inner_join(rsdata %>%
  select(LopNr, shf_indexdtm),
migration %>%
  filter(Posttyp == "Utv"),
by = c("LopNr" = "lopnr")
) %>%
  mutate(tmp_migrationdtm = ymd(MigrationDatum)) %>%
  filter(tmp_migrationdtm > shf_indexdtm,
         tmp_migrationdtm <= ymd("2018-12-31")
         ) %>%
  group_by(LopNr, shf_indexdtm) %>%
  slice(1) %>%
  ungroup() %>%
  select(LopNr, shf_indexdtm, tmp_migrationdtm)

rsdata <- left_join(rsdata,
  migration,
  by = c("LopNr", "shf_indexdtm")
)


rsdata <- left_join(rsdata,
  dors %>% select(LopNr, ULORSAK, DODSDAT),
  by = "LopNr"
) %>%
  mutate(sos_deathdtm = ymd(case_when(
    substr(DODSDAT, 5, 8) == "0000" ~ paste0(substr(DODSDAT, 1, 4), "0701"),
    substr(DODSDAT, 7, 8) == "00" ~ paste0(substr(DODSDAT, 1, 6), "15"),
    TRUE ~ DODSDAT
  ))) %>%
  rename(sos_deathcause = ULORSAK) %>%
  select(-DODSDAT)

# koll <- rsdata %>%
#  mutate(shf_deathdtm = if_else(shf_deathdtm > ymd("2018-12-31"), as.Date(NA), shf_deathdtm) )  %>%
#  filter(sos_deathdtm != shf_deathdtm |
#           is.na(sos_deathdtm) != is.na(shf_deathdtm)) %>%
#  select(shf_deathdtm, sos_deathdtm) # not so big diff, use sos dtm

hfsos <- patreg %>%
  filter(DIA_all != "") %>%
  mutate(tmp_hfsos = stringr::str_detect(DIA_all, " I110| I130| I132| I255| I420| I423| 1425| I426| I427| I428| I429| I43| I50| J81| K761| R57| 414W| 425E| 425F| 425G| 425H| 425W| 425X| 428")) %>%
  filter(tmp_hfsos)

controlstososcase <-
  inner_join(rsdata %>% filter(casecontrol == "Control") %>% select(LopNr, LopNrcase, shf_indexdtm, shf_indexyear),
    hfsos,
    by = "LopNr"
  ) %>%
  mutate(tmp_hfsosdtm = INDATUM) %>%
  group_by(LopNr, shf_indexdtm) %>%
  arrange(tmp_hfsosdtm) %>%
  slice(1) %>%
  ungroup() %>%
  select(LopNr, shf_indexdtm, tmp_hfsosdtm)

rsdata <- left_join(rsdata,
  controlstososcase,
  by = c("LopNr", "shf_indexdtm")
)

controlstorscase <- left_join(rsdata %>% filter(casecontrol == "Control") %>% select(LopNr, LopNrcase, shf_indexdtm),
  rsdata %>% filter(casecontrol == "Case") %>% select(LopNr, LopNrcase, shf_indexdtm),
  by = "LopNr",
  suffix = c("", "_case")
) %>%
  filter(!is.na(shf_indexdtm_case)) %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm_case) %>%
  slice(1) %>%
  ungroup() %>%
  rename(tmp_hfrsdtm = shf_indexdtm_case) %>%
  select(LopNr, shf_indexdtm, tmp_hfrsdtm)

rsdata <- left_join(rsdata,
  controlstorscase,
  by = c("LopNr", "shf_indexdtm")
)

rsdata <- rsdata %>%
  mutate(
    censdtm = coalesce(
      pmin(sos_deathdtm, tmp_migrationdtm, na.rm = TRUE),
      ymd("2018-12-31")
    ),
    censdtm = pmin(censdtm, tmp_hfsosdtm, na.rm = TRUE),
    censdtm = pmin(censdtm, tmp_hfrsdtm, na.rm = TRUE)
  ) %>%
  filter(censdtm >= shf_indexdtm) %>% # finns 683 poster som har sos hf diagnos, migrationsdatum, dör innan de blir controller. delete.
  select(-shf_deathdtm)


# n controls for cases

nkontroller <- rsdata %>%
  filter(casecontrol == "Control") %>%
  select(LopNrcase, shf_indexdtm) %>%
  group_by(LopNrcase, shf_indexdtm) %>%
  mutate(ncontrols = n()) %>%
  slice(1) %>%
  ungroup()

rsdata <- left_join(rsdata,
  nkontroller,
  by = c("LopNr" = "LopNrcase", "shf_indexdtm")
) %>%
  mutate(
    ncontrols = replace_na(ncontrols, 0)
  )

ncontrols <- full_join(
  rsdata %>% filter(casecontrol == "Case") %>%
    count(ncontrols),
  rsdata %>%
    filter(casecontrol == "Case") %>%
    group_by(LopNr) %>%
    arrange(desc(ncontrols)) %>%
    slice(1) %>%
    ungroup() %>%
    count(ncontrols),
  by = "ncontrols"
) %>%
  mutate(
    n.y = replace_na(n.y, 0)
  )

names(ncontrols) <- c("No controls", "Posts", "Unique patients")
