# Impute BMI ---------------------------------------------------------------

# If missing height select the latest height (can also be after index)

heightimpind <- rsdata %>%
  filter(!is.na(shf_height)) %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm) %>%
  slice(n()) %>%
  ungroup() %>%
  rename(height_imp = shf_height) %>%
  select(LopNr, height_imp)

rsdata <- left_join(rsdata,
  heightimpind,
  by = "LopNr"
) %>%
  mutate(
    shf_height = coalesce(shf_height, height_imp),
    shf_bmi = round(shf_weight / (shf_height / 100)^2, 1)
  )

# If still missing height impute by age and sex

rsdata <- rsdata %>%
  mutate(shf_age_catimp = case_when(
    shf_age < 30 ~ 30,
    shf_age < 40 ~ 40,
    shf_age < 50 ~ 50,
    shf_age < 60 ~ 60,
    shf_age < 65 ~ 65,
    shf_age < 70 ~ 70,
    shf_age < 75 ~ 75,
    shf_age < 80 ~ 80,
    shf_age < 85 ~ 85,
    shf_age < 90 ~ 90,
    shf_age >= 90 ~ 95
  ))

# median within sex and age
heightimpmed <- rsdata %>%
  group_by(shf_sex, shf_age_catimp) %>%
  summarise(heightmed = quantile(shf_height,
    probs = 0.5,
    na.rm = TRUE
  ), .groups = "drop_last")

# join together
rsdata <- left_join(
  rsdata,
  heightimpmed,
  by = c("shf_sex", "shf_age_catimp")
) %>%
  mutate(
    shf_heightimp = coalesce(shf_height, heightmed),
    shf_bmiimp = round(shf_weight / (shf_heightimp / 100)^2, 1),
    shf_bmi = clean_outliers(shf_bmi, 8, 80),
    shf_bmiimp = clean_outliers(shf_bmiimp, 8, 80)
  ) %>%
  select(-shf_heightimp, -shf_age_catimp, -heightmed, -height_imp)
