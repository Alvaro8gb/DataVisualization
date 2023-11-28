# server.R
library(shiny)
library(quantmod)

members <- list("Alvaro", "Maxi", "Mikel")

server <- function(input, output) {

  output$members <- renderText({
    paste("Authors:", paste(members, collapse = ", "))
  })

  output$selectedValues <- renderText({
    paste("Selected values:",
          "\nAge:", input$age,
          "\nGender:", input$gender,
          "\nBMI:", input$bmi,
          "\nSymptoms:", ifelse(length(input$symptoms) > 0, paste(input$symptoms, collapse = ", "), "None"),
          "\nWBC:", input$wbc,
          "\nRBC:", input$rbc,
          "\nHGB:", input$hgb,
          "\nPlatelet:", input$plat
    )
  })

}
