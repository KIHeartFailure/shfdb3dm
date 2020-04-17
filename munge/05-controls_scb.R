
# select controls that have cases
kontroller <- inner_join(rsdata %>% select(LopNr, shf_indexdtm, shf_sex, shf_age),
  fallkontroller %>%
    mutate(indexdtm = ymd(Indexdatum)),
  by = c("LopNr", "shf_indexdtm" = "indexdtm")
) %>%
  mutate(
    LopNrcase = LopNr,
    LopNr = LopNrKontroll
  )


rsdata <- bind_rows(
  rsdata %>% 
    mutate(casecontrol = "Case"), 
  kontroller %>% 
    mutate(casecontrol = "Control") %>%
    select(LopNrcase, LopNr, shf_indexdtm, shf_sex, shf_age, casecontrol)
) %>%
  mutate(
    shf_indexyear = if_else(is.na(shf_indexyear), year(shf_indexdtm), shf_indexyear),
    LopNrcase = if_else(is.na(LopNrcase), LopNr, LopNrcase),
  )