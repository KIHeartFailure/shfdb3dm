ynfac <- function(var){
  var <- factor(var, 
                levels = c(0, 1), 
                labels = c("No", "Yes"))
}