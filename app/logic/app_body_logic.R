# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  stats[arima, fitted],
  forecast[Arima, is.Arima]
)

# -----------------------------------------------------
# ----- Function to Apply User's Model Parameters ----- 
# -----------------------------------------------------

#' @export
train_user_model <- function(arima_sim_data, parameter_p, parameter_d, parameter_q) {
  model_fit <- Arima(arima_sim_data,
                     order = c(parameter_p, 
                               parameter_d, 
                               parameter_q))
  
  return_list <- list(fitted_values = fitted(model_fit),
                      residuals = model_fit$residuals,
                      model = model_fit)
  
  return(return_list)
}
