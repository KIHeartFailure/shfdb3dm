# delete tmp and fix order of variables

rsdata <- rsdata %>%
  select(
    LopNr, casecontrol, ncontrols, LopNrcase,
    shf_source, shf_indexdtm, shf_indexyear, shf_type,
    contains("shf_ef"),
    contains("shf_"),
    contains("scb_"),
    censdtm,
    sos_durationhf,
    contains("sos_com"),
    contains("sos_out"),
    sos_deathcause
  )


rsdata <- rsdata %>%
  mutate_if(is.character, as.factor) %>%
  mutate(
    sos_deathcause = as.character(sos_deathcause),
    scb_region = as.character(scb_region)
  )

# fix so that yes no variables should have values 0, 1, not 1, 2
ynvar <- function(var) {
  if (is.factor(var)) {
    out <- all(levels(var) %in% c("No", "Yes"))
  } else {
    out <- FALSE
  }
}
ynvars <- rsdata %>% sapply(ynvar)
ynvars <- names(ynvars)[ynvars]

# create numeric dataset

rsdata_levs <- rsdata %>%
  sapply(levels) %>%
  unlist()

rsdata_levs <- bind_cols(level = rsdata_levs, var = names(rsdata_levs)) %>%
  mutate(
    variable = str_replace(names(rsdata_levs), "\\d+$", "")
  ) %>%
  group_by(variable) %>%
  mutate(value = row_number()) %>%
  ungroup() %>%
  # fix so that yes no variables should have values 0, 1, not 1, 2
  mutate(value = ifelse(variable %in% ynvars, value - 1, value)) %>%
  select(variable, value, level)

write.xlsx(rsdata_levs, "./metadata/meta_factorlevels.xlsx")

# create Excel where nice labels/units can be written and comments "good to know"
write.xlsx(names(rsdata), "./metadata/tmp_meta_variables.xlsx")


# fix so that yes no variables should have values 0, 1, not 1, 2
m1 <- function(var) {
  var <- var - 1
}
rsdatanum <- rsdata %>%
  mutate_if(is.factor, as.numeric) %>%
  mutate_at(vars(all_of(ynvars)), m1)
