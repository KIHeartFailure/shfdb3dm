rsdata <- rsdata %>%
  mutate(scbyear = shf_indexyear - 1)

rsdata <- left_join(
  rsdata,
  antalbarn %>%
    select(LopNr, year) %>%
    mutate(scb_child = "Yes"),
  by = c("LopNr" = "LopNr", "scbyear" = "year")
) %>%
  mutate(scb_child = replace_na(scb_child, "No"))


lisa <- lisa %>%
  mutate(
    scb_region = Lan,
    scb_maritalstatus = case_when(
      Civil %in% c("A", "EP", "OG", "S", "SP") ~ "Single/widowed/divorced",
      Civil %in% c("G", "RP") ~ "Married"
    ),
    scb_famtype = case_when(
      FamTypF %in% c(11, 12, 13, 21, 22, 23, 31, 32, 41, 42) ~ "Cohabitating",
      FamTypF %in% c(50, 60) ~ "Living alone"
    ),
    scb_education = case_when(
      Sun2000niva_old %in% c(1, 2) ~ "Compulsory school",
      Sun2000niva_old %in% c(3, 4) ~ "Secondary school",
      Sun2000niva_old %in% c(5, 6, 7) ~ "University"
    ),
    scb_dispincome = coalesce(DispInk04, DispInk)
  ) %>%
  select(LopNr, year, starts_with("scb_"))

rsdata <- left_join(
  rsdata,
  lisa,
  by = c("LopNr" = "LopNr", "scbyear" = "year")
) %>%
  select(-scbyear)

## income
inc <- rsdata %>%
  group_by(shf_indexyear) %>%
  summarise(incsum = list(enframe(quantile(scb_dispincome,
    probs = c(0.33, 0.66),
    na.rm = TRUE
  )))) %>%
  unnest(cols = c(incsum)) %>%
  spread(name, value)

rsdata <- left_join(
  rsdata,
  inc,
  by = "shf_indexyear"
) %>%
  mutate(
    scb_dispincome_cat = case_when(
      scb_dispincome < `33%` ~ 1,
      scb_dispincome < `66%` ~ 2,
      scb_dispincome >= `66%` ~ 3
    ),
    scb_dispincome_cat = factor(scb_dispincome_cat, labels = c("Low", "Medium", "High"))
  ) %>%
  select(-`33%`, -`66%`)
