# server.R
library(shiny)
library(ggplot2)

dataset <- read.csv("../dataset/ds-final.csv")

members <- list("Alvaro", "Maxi", "Mikel")

server <- function(input, output) {
  output$members <- renderText({
    paste("Authors:", paste(members, collapse = ", "))
  })
  
  output$selectedValues <- renderText({
    paste("Selected values:",
          "\nAge:", input$age[1], "-", input$age[2],
          ",\nGender:", input$gender,
          ",\nBMI:", input$bmi[1], "-", input$bmi[2],
          ",\nSymptoms:", ifelse(length(input$symptoms) > 0, paste(input$symptoms, collapse = ", "), "None"),
          ",\nWBC:", input$wbc[1], "-", input$wbc[2],
          ",\nRBC:", input$rbc[1], "-", input$rbc[2],
          ",\nHGB:", input$hgb[1], "-", input$hgb[2],
          ",\nPlatelet:", input$plat[1], "-", input$plat[2])
  })
  
  output$idiom1scatterplot <- renderPlot({
    req(input$xaxis,input$yaxis)
    x_axis <- input$xaxis
    y_axis <- input$yaxis
    
    # Check if "Age" is selected for X or Y axis
    if (x_axis == "Age") {
      x_limits <- c(as.numeric(input$age[1]), as.numeric(input$age[2]))
    } else if (x_axis == sym("BMI")) {
      x_limits <- c(as.numeric(input$bmi[1]), as.numeric(input$bmi[2]))
    } else if (x_axis == "Baselinehistological.staging"){ ##  define x_limits for other variables
      x_limits <- c(1, 4)
    }else if (x_axis == "Baseline.histological.Grading"){ ##  define x_limits for other variables
      x_limits <- c(3, 16)
    }
    
    if (y_axis == "Age") {
      y_limits <- c(as.numeric(input$age[1]), as.numeric(input$age[2]))
    }else if (y_axis == "BMI") {
      y_limits <- c(as.numeric(input$bmi[1]), as.numeric(input$bmi[2]))
    }else if (y_axis == "Baselinehistological.staging"){ ##  define y_limits for other variables
      y_limits <- c(1, 4)
    }else if (y_axis == "Baseline.histological.Grading"){ ##  define y_limits for other variables
      y_limits <- c(3, 16)
    }
    
    p <- ggplot(data = dataset, aes(x = as.numeric(.data[[input$xaxis]]), y = as.numeric(.data[[input$yaxis]]))) +
      geom_point() +
      theme(legend.position = "top") +
      xlim(x_limits) +
      ylim(y_limits) +
      labs(title = paste("Scatterplot", input$xaxis, " vs ", input$yaxis), x = input$xaxis, y = input$yaxis)
    return(p)
  })
}
