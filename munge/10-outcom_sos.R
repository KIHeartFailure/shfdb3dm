

# Comorbs and outcomes ----------------------------------------------------


rsdata <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hospstroke",
  diakod = " I60| I61| I62| I63| I64",
  censdate = censdtm,
  valsclass = "num", 
  warnings = FALSE
)

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "stroke",
  diakod = " I60| I61| I62| I63| I64",
  stoptime = - 5 * 365.25,
  valsclass = "num", 
  warnings = FALSE
)

rsdata <- rsdata %>%
  mutate_at(vars(starts_with("sos_out_")), ynfac) %>%
  mutate_at(vars(starts_with("sos_com_")), ynfac)

outcommeta <- metaout 
rm(metaout)