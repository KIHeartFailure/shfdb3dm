# 1. Set options in config/global.dcf
# 2. Load packages listed in config/global.dcf
# 3. Import functions and code in lib directory
# 4. Load data in data directory
# 5. Run data manipulations in munge directory

ProjectTemplate::reload.project(
  reset = TRUE,
  data_loading = TRUE,
  munging = TRUE
)

#ProjectTemplate::cache("flow")
#ProjectTemplate::cache("ncontrols")
#ProjectTemplate::cache("rsdata")
#ProjectTemplate::cache("imp.org")
#ProjectTemplate::cache("noimpvars")

# save to RData, txt. numeric and factor. Also flow and ncontrols for webbsite