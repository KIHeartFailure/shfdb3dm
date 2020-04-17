dF <- function(vals, dig = 0, p = FALSE, ...) {
  out <- formatC(vals, format = "f", digits = dig, big.mark = ",", ...)
  if (p) {
    out <- replace(
      out,
      out == paste0("0.", paste0(rep(0, dig), collapse = "")), "<0.001"
    )
  }
  return(out)
}
