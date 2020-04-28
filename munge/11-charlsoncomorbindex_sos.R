
# Charlson comobidity index -----------------------------------------------

# Myocardial infarction

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_mi",
  diakod = " 410| 412| I21| I22| I252",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Congestive heart failure

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_chf",
  diakod = " 425[E-H]| 425W| 425X| 428| 1099| 1110| 1130| 1132| I255| I420| I42[5-9]| I43| I50| P290",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Peripheral vascular disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_pvd",
  diakod = " 093A| 437D| 440| 441| 443B| 443W| 443X| 447B| 557B| 557X| V43E| I70| I71| I731| I738| I739| 1771| 1790| I1792| K551| K558| K559| Z958| Z959",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Cerebrovascular disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_cd",
  diakod = " 43[0-8]| G45| G46| H340| I6[0-9]",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Dementia

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_dementia",
  diakod = " 290| 294B| 331C| F0[0-3]| F051| G30| G311",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Chronic pulmonary disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_copd",
  diakod = " 416W| 416X| 49[0-6]| 50[0-5]| 506E| 508B| 508W| 1278| 1279| J4[0-7]| J6[0-7]| J684| J701| J703",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Rheumatic disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_rheumatic",
  diakod = " 446F| 710[A-E]| 714[A-C]| 714W| 725| M05| M06| M315| M3[2-4]| M351| M353| M360",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Peptic ulcer disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_pud",
  diakod = " 53[1-4]| K2[5-8]",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Mild liver disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_livermild",
  diakod = " 070[C-G]| 070X| 570| 571| 573D| 573E| 573W| 573X| V42H| B18| K70[0-3]| K709| K71[3-5]| K717| K73| K74| K760| K76[2-4]| K768| K769| Z944",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Diabetes without chronic complication

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_diabetes",
  diakod = " 250[A-C]| 250H| 250X| E100| E101| E106| E108| E109| E110| E111| E116| E118| E119| E120| E121| E126| E128| E129| E130| E131| E136| E138| E139| E140| E141| E146| E148| E149",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Diabetes with chronic complication

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_diabetescompliation",
  diakod = " 250[D-G]| E10[2-5]| E107| E11[2-5]| E117| E12[2-5]| E127| E13[2-5]| E137| E14[2-5]| E147",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Hemiplegia or paraplegia

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_plegia",
  diakod = " 334B| 342| 343| 344[A-G]| 344X| G041| G114| G801| G802| G81| G82| G83[0-4]| G839",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Renal disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_renal",
  diakod = " 403A| 403B| 403X| 404A| 404B| 404X| 582| 583[A-C]| 583E| 583G| 583H| 585| 586| 588W| V42A| V45B| V56| I120| I131| N03[2-7]| N05[2-7]| N18| N19| N250| Z49[0-2]| Z940| Z992",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Any malignancy, including lymphoma and leukemia, except malignant neoplasm of skin

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_malignancy",
  diakod = " 1[4-6]| 17[0-5]| 179| 18| 19[0-5]| 20[0-8]| 238G| C[0-1]| C2[0-6]| C3[0-4]| C3[7-9]| C40| C41| C43| C4[5-9]| C5[0-8]| C6| C7[0-6]| C8[1-5]| C88| C9[0-7]",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Moderate or severe liver disease

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_livermodsev",
  diakod = " 456[A-C]| 572[C-E]| 572W| I850| I859| I864| I982| K704| K711| K721| K729| K765| K766| K767",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# Metastatic solid tumor

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_metastatictumor",
  diakod = " 19[6-9]| C7[7-9]| C80",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

# AIDS/HIV

rsdata <- create_sosvar(
  sosdata = patreg,
  cohortdata = rsdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  type = "com",
  name = "cci_hiv",
  diakod = " B2[0-2]| B24",
  stoptime = -10 * 365.25,
  valsclass = "num",
  warnings = FALSE
)

rsdata <- rsdata %>%
  mutate(
    sos_com_cci_diabetescompliation = sos_com_cci_diabetescompliation * 2,
    sos_com_cci_plegia = sos_com_cci_plegia * 2,
    sos_com_cci_renal = sos_com_cci_renal * 2,
    sos_com_cci_malignancy = sos_com_cci_malignancy * 2,
    sos_com_cci_livermodsev = sos_com_cci_livermodsev * 3,
    sos_com_cci_metastatictumor = sos_com_cci_metastatictumor * 6,
    sos_com_cci_hiv = sos_com_cci_hiv * 6
  ) %>%
  mutate(sos_com_charlsonci = rowSums(select(., starts_with("sos_com_cci_")))) %>%
  select(-starts_with("sos_com_cci_"))

ccimeta <- metaout
rm(metaout)
