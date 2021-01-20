
# Cause of death ----------------------------------------------------------

rsdata <- rsdata %>%
  mutate(
    sos_out_death = ifelse(censdtm == sos_deathdtm & !is.na(sos_deathdtm), 1, 0),
    sos_outtime_death = as.numeric(censdtm - shf_indexdtm)
  )

rsdata <- create_deathvar(
  cohortdata = rsdata,
  indexdate = shf_indexdtm,
  censdate = censdtm,
  deathdate = sos_deathdtm,
  name = "cv",
  orsakvar = sos_deathcause,
  orsakkod = "I|J81|K761|R57|G45",
  valsclass = "num",
  warnings = FALSE
)
rsdata <- create_deathvar(
  cohortdata = rsdata,
  indexdate = shf_indexdtm,
  censdate = censdtm,
  deathdate = sos_deathdtm,
  name = "noncv",
  orsakvar = sos_deathcause,
  orsakkod = "[A-F]|G(?!45)|H|J(?!81)|K(?!761)|[L-Q]|R(?!57)|[S-Z]",
  valsclass = "num",
  warnings = FALSE
)
rsdata <- create_deathvar(
  cohortdata = rsdata,
  indexdate = shf_indexdtm,
  censdate = censdtm,
  deathdate = sos_deathdtm,
  name = "scd",
  orsakvar = sos_deathcause,
  orsakkod = "I461",
  valsclass = "num",
  warnings = FALSE
)


deathmeta <- metaout
rm(metaout)

rsdata <- rsdata %>%
  mutate_at(vars(starts_with("sos_out_death")), ynfac) %>%
  mutate(sos_out_hospdeathscd = ifelse(sos_out_deathscd == "Yes" | sos_out_hospscd == "Yes", 1, 0), 
         sos_out_hospdeathscd = ynfac(sos_out_hospdeathscd)) %>%
  select(-sos_out_deathscd, -sos_out_hospscd, -sos_deathdtm)