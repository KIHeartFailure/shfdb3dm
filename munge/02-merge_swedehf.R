# check and rename if varname in both old and new
# koll <- names(newrs)[names(newrs) %in% names(oldrs)]
oldrs <- oldrs %>%
  rename(
    TYPE_old = TYPE,
    FATIGUE_old = FATIGUE,
    MOBILITY_old = MOBILITY,
    DIABETES_old = DIABETES,
    BNP_old = BNP,
    ARNI_old = ARNI
  )

rsdata <- bind_rows(
  newrs %>% mutate(source = 3),
  oldrs %>% mutate(source = 1)
)

yncomb <- function(oldvar, newvar) {
  combvar <- case_when(
    !!oldvar == 0 | !!newvar == "NO" ~ 0,
    !!oldvar == 1 | !!newvar == "YES" ~ 1
  )
  combvar <- ynfac(combvar)
}
  
rsdata <- rsdata %>%
  #mutate( # change to transmute when finished checking
  transmute(
    LopNr = LopNr,
    shf_source = case_when(
      source == 3 & migrated == 1 ~ 2,
      TRUE ~ source
    ),
    shf_source = factor(shf_source, labels = c("Old SHF", "New SHF migrated from old SHF", "New SHF")),
    
    shf_indexdtm = coalesce(DTMUT, DATE_DISCHARGE, DTMIN, d_DATE_FOR_ADMISSION),
    shf_indexyear = year(shf_indexdtm),
    shf_sex = case_when(
      SEX == "FEMALE" | GENDER == 2 ~ "Female",
      SEX == "MALE" | GENDER == 1 ~ "Male"
    ),
    shf_type = case_when(
      TYPE_old == 0 | TYPE == "INDEX" ~ "Index",
      TYPE_old == 1 | TYPE %in% c("FOLLOWUP", "YEARLY_FOLLOWUP") ~ "Follow-up"
    ),
    shf_age = coalesce(d_age_at_VISIT_DATE, d_alder),
    shf_civilstatus = case_when(
      CIVILSTATUS == 1 | CIVIL_STATUS == "PARTNER" ~ "Married/cohabitating",
      CIVILSTATUS == 2 | CIVIL_STATUS == "SINGLE" ~ "Single"
    ),
    shf_residence = case_when(
      BOFORM == 1 | RESIDENCE_TYPE == "OWN_HOME" ~ "Own home",
      BOFORM == 2 | RESIDENCE_TYPE == "OTHER_HOME" ~ "Other home"
    ),
    shf_location = case_when(
      VARDGIVARE %in% c(2, 3) | LOCATION == "IX_OV" | TYPE %in% c("FOLLOWUP", "YEARLY_FOLLOWUP") ~ "Out-patient",
      VARDGIVARE == 1 | LOCATION == "IX_SV" ~ "In-patient"
    ),
    shf_smoking = case_when(
      ROKNING == 1 | ROKVANOR == 0 | SMOKING_HABITS == "NEVER" ~ "Never",
      ROKNING == 2 | ROKVANOR %in% c(1, 2) | SMOKING_HABITS %in% c("FORMER_SMOKER", "STOP_LESS_6_MONTHS", "STOP_MORE_6_MONTHS") ~ "Former",
      ROKNING == 3 | ROKVANOR %in% c(3, 4) | SMOKING_HABITS %in% c("YES", "NOT_DAILY", "DAILY") ~ "Current"
    ),

    # https://www.iq.se/fakta-om-alkohol/riskbruk-och-beroende/
    # För att ange ett riskbruk i mängd alkoholdryck används ofta den här definitionen (ett standardglas innehåller 12 gram alkohol):
    # Om en man dricker mer än 14 standardglas per vecka
    # Om en kvinna dricker mer än 9 standardglas per vecka
    # Eller:
    # Om en man dricker mer än 4 standardglas vid ett och samma tillfälle
    # Om en kvinna dricker mer än 3 standardglas vid ett och samma tillfälle

    #tmp_alcohol = case_when(
    #  ALKOHOL %in% c(0, 1, 2) | L_ALCOHOL %in% c("FORMER_PROBLEMATIC", "NEVER", "NORMAL") ~ 0,
    #  ALKOHOL == 3 | L_ALCOHOL == "PROBLEMATIC" ~ 1
    #),
    #tmp_alcohol_vecka = case_when(
    #  ALKOHOLVECKA %in% c(0, 1, 2) | ALKOHOLVECKA == 3 & shf_sex == "male" |
    #    ALCOHOL_STD_GLASS_PER_WEEK %in% c("LESS_THAN_ONE", "ONE_TO_FOUR", "FIVE_TO_NINE") |
    #    ALCOHOL_STD_GLASS_PER_WEEK == "TEN_TO_FOURTEEN" & shf_sex == "male" ~ 0,
    #  ALKOHOLVECKA == 4 | ALKOHOLVECKA == 3 & shf_sex == "female" |
    #    ALCOHOL_STD_GLASS_PER_WEEK == "FIFTEEN_OR_MORE" |
    #    ALCOHOL_STD_GLASS_PER_WEEK == "TEN_TO_FOURTEEN" & shf_sex == "female" ~ 1
    #),
    #tmp_alcohol_tillfalle = case_when(
    #  ALKOHOLTILLFALLE %in% c(0, 1, 2) |
    #    ALCOHOL_MORE_THAN_5_PER_TIME %in% c("EACH_MONTH", "LESS_THAN_EACH_MONTH", "NEVER") ~ 0,
    #  ALKOHOLTILLFALLE %in% c(3, 4) |
    #    ALCOHOL_MORE_THAN_5_PER_TIME %in% c("EACH_WEEK", "DAILY") ~ 1
    #),
    #shf_alcohol = case_when(
    #  tmp_alcohol == 1 | tmp_alcohol_vecka == 1 | tmp_alcohol_tillfalle == 1 ~ "Risk",
    #  tmp_alcohol == 0 | tmp_alcohol_vecka == 0 | tmp_alcohol_tillfalle == 0 ~ "Normal"
    #),
    tmp_timedurationhf = d_DATE_FOR_ADMISSION - DATE_FOR_DIAGNOSIS_HF,
    tmp_timedurationhf2 = case_when(
      tmp_timedurationhf < 6 * 30.5 ~ "LESS_THAN_6_MONTHS",
      tmp_timedurationhf >= 6 * 30.5 ~ "MORE_THAN_6_MONTHS"
    ),
    tmp_DURATION_OF_HF = coalesce(tmp_timedurationhf2, DURATION_OF_HF),
    shf_durationhf = case_when(
      DURATIONHJARTSVIKT == 1 | tmp_DURATION_OF_HF == "LESS_THAN_6_MONTHS" ~ "<6mo",
      DURATIONHJARTSVIKT == 2 | tmp_DURATION_OF_HF == "MORE_THAN_6_MONTHS" ~ ">6mo"
    ),
    shf_primaryetiology = case_when(
      PRIMARETIOLOGI == 1 | PRIMARY_ETIOLOGY == "HYPERTENSION" ~ "Hypertension",
      PRIMARETIOLOGI == 2 | PRIMARY_ETIOLOGY == "ISCHEMIC" ~ "IHD",
      PRIMARETIOLOGI == 3 | PRIMARY_ETIOLOGY == "DILATED" ~ "DCM",
      PRIMARETIOLOGI == 4 | PRIMARY_ETIOLOGY == "ALCOHOL" ~ "Known alcoholic cardiomyopathy",
      PRIMARETIOLOGI == 5 | PRIMARY_ETIOLOGY == "HEARTVALVE" ~ "Heart valve disease",
      PRIMARETIOLOGI == 6 | PRIMARY_ETIOLOGY == "OTHER" ~ "Other"
    ),
    shf_nyha = case_when(
      NYHA == 1 | FUNCTION_CLASS_NYHA == "NYHA_I" ~ "I",
      NYHA == 2 | FUNCTION_CLASS_NYHA == "NYHA_II" ~ "II",
      NYHA == 3 | FUNCTION_CLASS_NYHA == "NYHA_III" ~ "III",
      NYHA == 4 | FUNCTION_CLASS_NYHA == "NYHA_IV" ~ "IV"
    ),
    shf_efproc = LVEF_PERCENT,
    shf_ef = case_when(
      d_lvefprocent == 1 | LVEF_SEMIQUANTITATIVE == "NORMAL" | LVEF_PERCENT >= 50 ~ 1,
      d_lvefprocent == 2 | LVEF_SEMIQUANTITATIVE == "MILD" | LVEF_PERCENT >= 40 ~ 2,
      d_lvefprocent == 3 | LVEF_SEMIQUANTITATIVE == "MODERATE" | LVEF_PERCENT >= 30 ~ 3,
      d_lvefprocent == 4 | LVEF_SEMIQUANTITATIVE == "SEVERE" | LVEF_PERCENT < 30 ~ 4
    ),
    shf_ef = factor(shf_ef, labels = c(">=50", "40-49", "30-39", "<30")),
    
    shf_weight = coalesce(WEIGHT, VIKT),
    shf_height = coalesce(HEIGHT, LANGD),
    shf_bmi = round(shf_weight / (shf_height / 100) ^ 2, 1),

    # laboratory
    shf_bpsys = coalesce(BP_SYSTOLIC, BTSYSTOLISKT),
    shf_bpdia = coalesce(BP_DIASTOLIC, BTDIASTOLISKT),
    shf_map = (shf_bpsys + 2 * shf_bpdia) / 3,
    shf_heartrate = coalesce(HJARTFREKVENS, HEART_FREQUENCY),
    shf_hb = coalesce(HB, B_HB),
    shf_potassium = coalesce(KALIUM, S_POTASSIUM),
    shf_sodium = coalesce(NATRIUM, S_SODIUM),
    shf_creatinine = coalesce(S_CREATININE, KREATININ),
    # eGFR according to CKD-EPI
    tmp_sex = recode(shf_sex, "Male" = 1, "Female" = 0),
    tmp_ethnicity = 0, # ethnicity is unknown. therefore all are considered not "African-American"
    shf_gfrckdepi = nephro::CKDEpi.creat(shf_creatinine / 88.4, tmp_sex, shf_age, tmp_ethnicity),
    shf_ntpropbnp = coalesce(PROBNP, NT_PROBNP),
    shf_bnp = coalesce(BNP_old, BNP),
    shf_transferrin = P_TRANSFERRIN,
    shf_ferritin = S_FERRITIN,

    shf_qrs = coalesce(QRSBREDD, QRS_WIDTH),
    shf_lbbb = yncomb(LBBB, LEFT_BRANCH_BLOCK),

    # treatments
    shf_diuretics = case_when(
      is.na(DIURETIKA) & shf_source == "Old SHF" |
        is.na(LOOP_DIUR) & shf_source == "New SHF migrated from old SHF" |
        (is.na(LOOP_DIUR) | is.na(THIAZIDE_OR_OTHER_DIURETIC)) & shf_source == "New SHF" ~ NA_real_,
      DIURETIKA %in% c(1, 2, 3, 8) |
        LOOP_DIUR %in% c("LOOP_DIURETIC", "LOOP_DIURETIC_AND_THIAZIDES", "THIAZIDES", "YES") |
        THIAZIDE_OR_OTHER_DIURETIC == "YES" ~ 1,
      TRUE ~ 0 # same as: DIURETIKA == 0 | LOOP_DIUR == "NO" | THIAZIDE_OR_OTHER_DIURETIC == "NO" ~ "No"
    ),
    shf_diuretics = ynfac(shf_diuretics),
    
    shf_loopdiuretics = case_when(
      (is.na(DIURETIKA) | shf_indexyear < 2011) & shf_source == "Old SHF" |
        (is.na(LOOP_DIUR) | shf_indexyear < 2011) & shf_source == "New SHF migrated from old SHF" |
        is.na(LOOP_DIUR) & shf_source == "New SHF" ~ NA_real_,
      DIURETIKA %in% c(1, 3) |
        LOOP_DIUR %in% c("LOOP_DIURETIC", "LOOP_DIURETIC_AND_THIAZIDES", "YES") ~ 1,
      TRUE ~ 0 # same as: DIURETIKA %in% c(0, 2) | LOOP_DIUR %in% c("NO", "THIAZIDES") ~ "No"
    ),
    shf_loopdiuretics = ynfac(shf_loopdiuretics),
    
    shf_loopdiureticdose = if_else(!is.na(shf_loopdiuretics) & shf_loopdiuretics == "Yes",
      coalesce(
        LOOP_DIUR_DOSE_BUMETANID,
        LOOP_DIUR_DOSE_FUROSEMID,
        LOOP_DIUR_DOSE_TORESAMID,
        L_LOOP_DIUR_DOSE,
        DIURETIKA_DOS
      ), NA_real_
    ),
    shf_loopdiureticusage = case_when(
      is.na(shf_loopdiuretics) | shf_loopdiuretics == "No" ~ NA_character_,
      DIURETIKA_DOSTYP == 0 | LOOP_DIUR_USAGE == "DAY" ~ "Daily",
      DIURETIKA_DOSTYP == 1 | LOOP_DIUR_USAGE == "ONLY_WHEN_NECESSARY" ~ "When necessary"
    ),
    shf_acei = yncomb(ACEHAMMARE, ACE_INHIBITOR),
    shf_aceisub = case_when(
      is.na(shf_acei) | shf_acei == "No" ~ NA_character_,
      NAMNACE == 0 | ACE_SUBSTANCE == "KAPTOPRIL" ~ "Captopril",
      NAMNACE == 1 | ACE_SUBSTANCE == "ENALAPRIL" ~ "Enalapril",
      NAMNACE == 2 | ACE_SUBSTANCE == "RAMIPRIL" ~ "Ramipril",
      NAMNACE == 3 | ACE_SUBSTANCE == "LISINOPRIL" ~ "Lisinopril",
      NAMNACE == 4 | ACE_SUBSTANCE == "TRANDOLAPRIL" ~ "Trandolapril",
      NAMNACE == 5 | ACE_SUBSTANCE == "KINAPRIL" ~ "Kinapril",
      NAMNACE == 6 | ACE_SUBSTANCE == "CILAZAPRIL" ~ "Cilazapril",
      NAMNACE == 7 | ACE_SUBSTANCE == "FOSINOPRIL" ~ "Fosinopril",
      ACE_SUBSTANCE == "PERINDOPRIL" ~ "Perindopril"
    ),
    shf_aceidose = if_else(!is.na(shf_acei) & shf_acei == "Yes", coalesce(
      ACE_DOSE_KAPTOPRIL, ACE_DOSE_ENALAPRIL,
      ACE_DOSE_RAMIPRIL, ACE_DOSE_LISINOPRIL,
      ACE_DOSE_TRANDOLAPRIL,
      ACE_DOSE_KINAPRIL, ACE_DOSE_CILAZAPRIL,
      ACE_DOSE_FOSINOPRIL, ACE_DOSE_PERINDOPRIL,
      DOSACE
    ), NA_real_),
    shf_arb = yncomb(A2BLOCKERARE, A2_BLOCKER_ARB),
    shf_arbsub = case_when(
      is.na(shf_arb) | shf_arb == "No" ~ NA_character_,
      NAMNA2 == 0 | A2_ARB_SUBSTANCE == "LOSARTAN" ~ "Losartan",
      NAMNA2 == 1 | A2_ARB_SUBSTANCE == "EPROSARTAN" ~ "Eprosartan",
      NAMNA2 == 2 | A2_ARB_SUBSTANCE == "VALSARTAN" ~ "Valsartan",
      NAMNA2 == 3 | A2_ARB_SUBSTANCE == "IRBESARTAN" ~ "Irbesartan",
      NAMNA2 == 4 | A2_ARB_SUBSTANCE == "KANDESARTAN" ~ "Candesartan",
      NAMNA2 == 5 | A2_ARB_SUBSTANCE == "TELMISARTAN" ~ "Telmisartan"
    ),
    shf_arbdose = if_else(!is.na(shf_arb) & shf_arb == "Yes",
      coalesce(
        A2_ARB_DOSE_TELMISARTAN,
        A2_ARB_DOSE_VALSARTAN,
        A2_ARB_DOSE_KANDESARTAN, A2_ARB_DOSE_IRBESARTAN,
        A2_ARB_DOSE_EPROSARTAN, A2_ARB_DOSE_LOSARTAN,
        DOSA2
      ), NA_real_
    ),
    shf_arni = yncomb(ARNI_old, ARNI),
    # arni dose, väntar och ser om någon behöver, ARNI_DOSE, L_ARNI_DOSE, ARNI_SAKUBITRIL_2426_DOSE, ARNI_SAKUBITRIL_4951_DOSE
    # ARNI_SAKUBITRIL_97103_DOSE

    shf_ras = case_when(
      is.na(shf_arb) | is.na(shf_acei) ~ NA_real_,
      shf_arb == "Yes" | shf_acei == "Yes" | shf_arni == "Yes" ~ 1,
      TRUE ~ 0
    ),
    shf_ras = ynfac(shf_ras),
    
    shf_bbl = yncomb(BETABLOCKERARE, BETA_BLOCKER),
    shf_bblsub = case_when(
      is.na(shf_bbl) | shf_bbl == "No" ~ NA_character_,
      NAMNBETA == 0 | BETA_SUBSTANCE == "METOPROLOL" ~ "Metoprolol",
      NAMNBETA == 1 | BETA_SUBSTANCE == "BISOPROLOL" ~ "Bisoprolol",
      NAMNBETA == 2 | BETA_SUBSTANCE == "KARVEDILOL" ~ "Carvedilol",
      NAMNBETA == 3 | BETA_SUBSTANCE == "PINDOLOL" ~ "Pindolol",
      NAMNBETA == 4 | BETA_SUBSTANCE == "PROPANOLOL" ~ "Propanolol",
      NAMNBETA == 5 | BETA_SUBSTANCE == "TIMOLOL" ~ "Timolol",
      NAMNBETA == 6 | BETA_SUBSTANCE == "ATENOLOL" ~ "Atenolol",
      NAMNBETA == 7 | BETA_SUBSTANCE == "BETAXOLOL" ~ "Betaxolol",
      NAMNBETA == 8 | BETA_SUBSTANCE == "LABETALOL" ~ "Labetalol",
      NAMNBETA == 9 | BETA_SUBSTANCE == "SOTALOL" ~ "Sotalol"
    ),

    shf_bbldose = if_else(!is.na(shf_bbl) & shf_bbl == "Yes",
      coalesce(
        BETA_DOSE_METOPROLOL, BETA_DOSE_PROPANOLOL, BETA_DOSE_BISOPROLOL, BETA_DOSE_ATENOLOL, BETA_DOSE_SOTALOL,
        BETA_DOSE_LABETALOL, BETA_DOSE_KARVEDILOL, BETA_DOSE_PINDOLOL, L_BETA_DOSE_BETAXOLOL, L_BETA_DOSE_TIMOLOL,
        DOSBETA
      ), NA_real_
    ),
    shf_mra = yncomb(ALDOSTERONANTAGONIST, MRA),
    shf_mrasub = case_when(
      is.na(shf_mra) | shf_mra == "No" ~ NA_character_,
      NAMNMRA == 1 | MRA_TYPE == "EPLERENON" ~ "Eplerenon",
      NAMNMRA == 0 | MRA_TYPE == "SPIRONOLAKTON" ~ "Spironalakton"
    ),
    shf_mradose = if_else(!is.na(shf_mra) & shf_mra == "Yes",
      coalesce(MRA_DOSE_EPLERENON, MRA_DOSE_SPIRONOLAKTON, DOSMRA),
      NA_real_
    ),

    shf_digoxin = yncomb(DIGITALIS, DIGOXIN),
    shf_asaantiplatelet = yncomb(ASATRC, ASA_ANTIPLATELET),
    shf_anticoagulantia = case_when(
      ANTIKOAGULANTIA == 0 | ANTICOAGULANT == "NO" ~ 0,
      ANTIKOAGULANTIA == 1 | ANTICOAGULANT %in% c("YES", "NOAK", "WARAN") ~ 1
    ),
    shf_anticoagulantia = ynfac(shf_anticoagulantia),
    
    shf_statin = yncomb(STATINER, STATIN),
    shf_nitrate = yncomb(NITRATER, LONG_ACTING_NITRATE),

    shf_ferrocarboxymaltosis = yncomb(JARNIV, FERROCARBOXYMALTOSIS),
    shf_ferrocarboxymaltosisdose = coalesce(JARNMG, FERRO_LAST_MG),
    shf_ferrocarboxymaltosisdate = coalesce(JARNDATUM, FERRO_LAST_DATE),

    shf_device = case_when(
      DEVICETERAPI == 0 | DEVICE_THERAPY == "NO" ~ 0,
      DEVICETERAPI == 1 | DEVICE_THERAPY == "PACEMAKER" ~ 1,
      DEVICETERAPI == 2 | DEVICE_THERAPY == "CRT" ~ 2,
      DEVICETERAPI == 3 | DEVICE_THERAPY == "CRT_D" ~ 3,
      DEVICETERAPI == 4 | DEVICE_THERAPY == "ICD" ~ 4
    ),
    shf_device = factor(shf_device, labels = c("No", "Pacemaker", 
                                               "CRT", "CRT & ICD", "ICD")),
    # shf_pacemaker = case_when(
    #  is.na(DEVICETERAPI) & is.na(DEVICE_THERAPY) ~ NA_character_,
    #  DEVICETERAPI == 1 | DEVICE_THERAPY == "PACEMAEKER" ~ "Yes",
    #  TRUE ~ "No"
    # ),
    # shf_crt = case_when(
    #  is.na(DEVICETERAPI) & is.na(DEVICE_THERAPY) ~ NA_character_,
    #  DEVICETERAPI %in% c(2, 3) | DEVICE_THERAPY %in% c("CRT", "CRT_D") ~ "Yes",
    #  TRUE ~ "No"
    # ),
    # shf_icd = case_when(
    #  is.na(DEVICETERAPI) & is.na(DEVICE_THERAPY) ~ NA_character_,
    #  DEVICETERAPI %in% c(3, 4) | DEVICE_THERAPY %in% c("ICD", "CRT_D") ~ "Yes",
    #  TRUE ~ "No"
    # ),
    shf_xray = case_when(
      RONTGEN == 0 | CHEST_X_RAY == "NO" ~ 0,
      RONTGEN == 1 | CHEST_X_RAY == "NORMAL" ~ 1,
      RONTGEN == 2 | CHEST_X_RAY == "PULMONARY_CONGESTION" ~ 2,
      RONTGEN == 3 | CHEST_X_RAY == "CARDIOMEGALY" ~ 3,
      RONTGEN == 4 | CHEST_X_RAY == "PULMONARY_CONGESTION_AND_CARDIOMEGALY" ~ 4,
    ),
    shf_xray = factor(shf_xray, labels = c("No", "Normal", "Pulmonary congestion", 
                                           "Cardiomegaly", 
                                           "Pulmonary congestion & cardiomegaly")),
    
    # comorbidities
    shf_diabetes = case_when(
      DIABETES_old == 0 | DIABETES == "NO" ~ 0,
      DIABETES_old %in% c(1, 2, 3, 4, 5) | DIABETES %in% c("TYPE_1", "TYPE_2") ~ 1
    ),
    shf_diabetes = ynfac(shf_diabetes),
    
    shf_hypertension = yncomb(HYPERTONI, HYPERTENSION),
    shf_af = yncomb(FORMAKSFLIMMER, ATRIAL_FIBRILLATION_FLUTTER),
    shf_lungdisease = yncomb(LUNGSJUKDOM, CHRONIC_LUNG_DISEASE),
    shf_valvedisease = yncomb(KARVOC, HEART_VALVE_DISEASE),
    shf_dcm = yncomb(DCM, DILATED_CARDIOMYOPATHY),
    shf_revascularization = case_when(
      is.na(REVASKULARISERING) & is.na(REVASCULARIZATION) ~ NA_real_,
      REVASKULARISERING == 0 | REVASCULARIZATION == "NO" ~ 0,
      TRUE ~ 1
    ),
    shf_revascularization = ynfac(shf_revascularization),
    
    shf_valvesurgery = case_when(
      is.na(KLAFFOP) & is.na(HEART_VALVE_SURGERY) ~ NA_real_, 
      KLAFFOP == 0 | HEART_VALVE_SURGERY == "NO" ~ 0,
      TRUE ~ 1
    ),
    shf_valvesurgery = ynfac(shf_valvesurgery),
    
    shf_ekg = case_when(
      EKGSENAST == 1 | EKG_RHYTHM == "SINUS_RHYTHM" ~ 1,
      EKGSENAST == 2 | EKG_RHYTHM == "ATRIAL_FIBRILLATION" ~ 2,
      EKGSENAST %in% c(3, 4, 8) | EKG_RHYTHM %in% c("OTHER_RHYTHM", "PACE_MAKER_RHYTHM") ~ 3
    ),
    shf_ekg = factor(shf_ekg, labels = c("Sinus", "Atrial fibrillation", "PM/Other")),

    # follow-up
    shf_followuphfunit = yncomb(UPPF_HSVIKT, FOLLOWUP_HF_UNIT),
    shf_followuplocation = case_when(
      UPPF_VARDNIVA == 1 | FOLLOWUP_HC_LEVEL == "HOSPITAL" ~ 1,
      UPPF_VARDNIVA == 2 | FOLLOWUP_HC_LEVEL == "PRIMARY_CARE" ~ 2,
      UPPF_VARDNIVA == 3 | FOLLOWUP_HC_LEVEL == "OTHER" ~ 3
    ),
    shf_followuplocation = factor(shf_followuplocation, c("Hospital", "Primary care", "Other")),
    
    # outcomes
    shf_deathdtm = coalesce(d_befdoddtm, befdoddtm),
    shf_deathdtm = if_else(shf_deathdtm > ymd("2018-12-31"), as.Date(NA), shf_deathdtm)
  ) %>%
  select(-starts_with("tmp_"))