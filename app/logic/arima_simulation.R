# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  stats[arima.sim]
)

# -------------------------------------------------------
# ----- Function to Simulate ARIMA Model Parameters -----
# -------------------------------------------------------

#' @export
simulate_params <- function() {
  # ----- Randomly generate values for AR, D, MA components (p, d, q) -----
  
  # Number of Autoregressive parameters (range: 0:3)
  p <- sample(0:3, 1)
  
  # Number of differencing parameters (range: 0:1)
  d <- sample(0:1, 1)
  
  # Number of Moving Average parameters (range: 0:3)
  q <- sample(0:3, 1)
  
  # ----- Randomly generate coefficient values -----
  
  # Autoregressive coefficients
  ar <- runif(p, min = .1, max = .3)
  
  # Moving Average coefficients
  ma <- runif(q, min = .1, max = .3)
  
  # Create a list of values to return
  returnList <- list(order = c(p, d, q),
                     model_specs = list(order = c(p, d, q),
                                        ar = ar,
                                        ma = ma))
  
  return(returnList)
}

# --------------------------------------------
# ----- Function to Simulate ARIMA Model -----
# --------------------------------------------

#' @export
simulate_arima <- function(param_list, n = 300) {
  # Simulate ARIMA process (returns a numeric time series vector)
  ts_vector <- arima.sim(n = n,
                         param_list) %>% 
    as.numeric()
  
  return(ts_vector)
}
