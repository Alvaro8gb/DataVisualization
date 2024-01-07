library(rsconnect)


# Set your Shiny app directory
app_directory <- "./App/app"

# Specify the application name
application_name <- "HepatitisVisualizationApp"

# Deploy the Shiny app
deployApp(
  appDir = app_directory,
  appName = application_name,
)