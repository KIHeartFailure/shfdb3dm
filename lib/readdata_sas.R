
readdata_sas <- function(path, filename, years = NULL, checkdups = FALSE, clean = TRUE) {
  if (is.null(years)) {
    outdata <- read_sas(paste0(path, filename, ".sas7bdat"))
    if (checkdups) dups <- anyDuplicated(outdata$LopNr)
  } else {
    for (y in years) {
      print(y)
      tmp <- read_sas(paste0(path, filename, "_", y, ".sas7bdat"))
      tmp$year <- y
      if (y == min(years)) {
        outdata <- tmp
      } else {
        outdata <- bind_rows(outdata, tmp)
      }
    }
    if (checkdups) dups <- anyDuplicated(outdata[, c("LopNr", "year")])
  }
  if (checkdups) {
    if (dups > 0) cat("Duplicates, please check") else cat("No duplicates")
    if (any(is.na(outdata$LopNr))) cat("Missing lopnr, please check") else cat("No missing lopnr")
  }
  outdata <- zap_formats(outdata)
  outdata <- zap_label(outdata)
  if (clean) {outdata <- clean_data(outdata)}
  return(outdata)
}