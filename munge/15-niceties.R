# delete tmp and fix order of variables

rsdata <- rsdata %>%
  select(
    LopNr, casecontrol, ncontrols, LopNrcase,
    shf_source, shf_indexdtm, shf_indexhosptime, shf_indexyear, shf_type,
    contains("shf_ef"),
    contains("shf_"),
    contains("scb_"),
    censdtm,
    sos_durationhf,
    sos_prevhosphf,
    sos_location, 
    contains("sos_com"),
    contains("sos_out"),
    sos_deathcause
  )


rsdata <- rsdata %>%
  mutate_if(is.character, as.factor) %>%
  mutate(
    shf_centre = as.character(shf_centre), 
    shf_centreregion = as.character(shf_centreregion), 
    sos_deathcause = as.character(sos_deathcause),
    scb_region = as.character(scb_region)
  )

# create Excel where nice labels/units can be written and comments "good to know"
write.xlsx(names(rsdata), "./metadata/tmp_meta_variables.xlsx")
