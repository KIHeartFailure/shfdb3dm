
# Cause of death ----------------------------------------------------------

rsdata <- rsdata %>%
  mutate(
    sos_out_deathhf = case_when(
      stringr::str_starts(sos_deathcause, "I50|I42|I43|I255|K761|I110|I130|I132|J81") ~ 1,
      TRUE ~ 0
    ), 
    sos_out_deathhf = ynfac(sos_out_deathhf)
  )