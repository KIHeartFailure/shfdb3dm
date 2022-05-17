
fodland <- fodland %>%
  filter(!is.na(FodelseVarldsdel)) %>%
  group_by(LopNr) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(
    scb_countryofbirth = case_when(
      FodelseVarldsdel %in% c(
        "Afrika",
        "Asien",
        "Nordamerika",
        "Oceanien",
        "Sovjetunionen",
        "Sydamerika"
      ) ~ 3,
      FodelseVarldsdel %in% c(
        "EU28 utom Norden",
        "Europa utom EU28 och Norden",
        "Norden utom Sverige"
      ) ~ 2,
      FodelseVarldsdel == "Sverige" ~ 1
    ),
    scb_countryofbirth = factor(scb_countryofbirth,
      labels = c("Sweden", "Europe", "Other")
    )
  )

# koll <- fodland %>%
# group_by(LopNr) %>% slice(2) %>% ungroup()

rsdata <- left_join(rsdata,
  fodland %>% select(scb_countryofbirth, LopNr),
  by = "LopNr"
)
