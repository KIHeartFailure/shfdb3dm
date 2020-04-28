
# Link hospital visits ----------------------------------------------------

svall <- bind_rows(
  sv1,
  sv2
) %>%
  select(-starts_with("OPD"), -KON, -ALDER, -Fall, -VTID, -UTSATT, -INDATUMA, -UTDATUMA)

svall <- svall %>%
  rename_at(
    vars(starts_with("op")),
    list(~ toupper(.))
  ) %>%
  rename_at(
    vars(starts_with("EKOD")),
    list(~ tolower(.))
  )

svall <- prep_sosdata(svall, utdatum = FALSE)

svall2 <- svall %>%
  filter(!is.na(INDATUM) & !is.na(UTDATUM)) %>% # 9 obs have missing for either
  mutate(UTDATUM = case_when(
    INDATUM > UTDATUM ~ INDATUM,
    TRUE ~ UTDATUM
  )) %>% # 74 obs have indatum AFTER utdatum, set utdatum to indatum
  group_by(LopNr) %>%
  arrange(INDATUM, UTDATUM) %>%
  mutate(
    n = row_number(),
    link = case_when(
      INDATUM <= dplyr::lag(UTDATUM) + 1 ~ 1,
      UTDATUM + 1 >= lead(INDATUM) ~ 1
    )
  ) %>%
  ungroup() %>%
  arrange(LopNr, INDATUM, UTDATUM)

svalllink <- svall2 %>%
  filter(!is.na(link)) %>%
  group_by(LopNr) %>%
  arrange(INDATUM, UTDATUM) %>%
  mutate(link2 = case_when(
    INDATUM > dplyr::lag(UTDATUM) + 1 ~ row_number(),
    row_number() == 1 ~ row_number()
  )) %>%
  ungroup() %>%
  arrange(LopNr, INDATUM, UTDATUM) %>%
  mutate(link2 = zoo::na.locf(link2))

svalllink <- svalllink %>%
  group_by(LopNr, link2) %>%
  summarize(
    DIA_all = paste0(" ", stringr::str_squish(str_c(DIA_all, collapse = " "))),
    OP_all = paste0(" ", stringr::str_squish(str_c(OP_all, collapse = " "))),
    ekod_all = paste0(" ", stringr::str_squish(str_c(ekod_all, collapse = " "))),
    HDIA = paste0(" ", stringr::str_squish(str_c(HDIA, collapse = " "))),
    INDATUM = min(INDATUM),
    UTDATUM = max(UTDATUM),
    PVARD = stringr::str_squish(str_c(PVARD, collapse = " ")),
    MVO = stringr::str_squish(str_c(MVO, collapse = " "))
  ) %>%
  ungroup()

svalllink <- bind_rows(
  svall2 %>% filter(is.na(link)) %>% mutate(sos_hosplinked = 0),
  svalllink %>% mutate(sos_hosplinked = 1)
) %>%
  select(-link, -link2, -n, -sosdtm) %>%
  mutate(AR = year(UTDATUM))

# koll <- svalllink %>% filter(LopNr == "100474")

# Merge sos data ----------------------------------------------------------

ovall <- bind_rows(
  ov1,
  ov2
) %>%
  select(-KON, -ALDER, -Fall, -INDATUMA)

ovall <- ovall %>%
  rename_at(
    vars(starts_with("op")),
    list(~ toupper(.))
  ) %>%
  rename_at(
    vars(starts_with("EKOD")),
    list(~ tolower(.))
  )

# koll <- ovall %>% filter(is.na(INDATUM)) %>% select(AR, INDATUMA)

ovall <- prep_sosdata(ovall, utdatum = FALSE)

patreg <- bind_rows(
  svalllink %>% mutate(sos_source = "sv"),
  ovall %>% mutate(sos_source = "ov") %>% select(-sosdtm)
) %>%
  mutate(LopNr = as.numeric(LopNr))

rm(list = ls()[grepl("sv|ov", ls())]) # delete to save workspace
