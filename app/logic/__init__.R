# Logic: application code independent from Shiny.
# https://go.appsilon.com/rhino-project-structure

box::use(
  ./constants,
  ./arima_simulation,
  
  ./app_body_logic,
  ./app_body_modules/ts_plot_logic,
  ./app_body_modules/auto_correlation_logic, 
  ./app_body_modules/unit_circle_logic,
  
  ./main_info_modal_logic
)