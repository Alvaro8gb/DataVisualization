# server.R
library(shiny)
library(quantmod)

members <- list("Alvaro", "Maxi", "Mikel")

server <- function(input, output) {

  output$members <- renderText({
    paste("Authors:", paste(members, collapse = ", "))
  })

}
