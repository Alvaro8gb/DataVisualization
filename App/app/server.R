# server.R
library(shiny)
library(dplyr)
library(RColorBrewer)
library(ggplot2)

colors <- brewer.pal(n = 4, name = "Blues")

dataset <- read.csv("../dataset/ds-final.csv")

members <- list("Alvaro", "Maxi", "Mikel")

time_series_1 <- c("ALT.1", "ALT.4", "ALT.12", "ALT.24", "ALT.36", "ALT.48")

server <- function(input, output) {
  # TODO -sintoms filtering and others
  
  # Map input values to corresponding values in the dataset
  gender_mapping <- c('Male' = '1', 'Female' = '2')

    filter_dataset <- reactive({
    dataset %>%
      filter(
        Age >= input$age[1] & Age <= input$age[2],
        Gender == gender_mapping[input$gender],
        BMI >= input$bmi[1] & BMI <= input$bmi[2],
        WBC >= input$wbc[1] & WBC <= input$wbc[2],
        RBC >= input$rbc[1] & RBC <= input$rbc[2],
        HGB >= input$hgb[1] & HGB <= input$hgb[2],
        Platelet >= input$plat[1] & Platelet <= input$plat[2]
      )
  })

  output$members <- renderText({
    paste("Authors:", paste(members, collapse = ", "))
  })

  output$selectedValues <- renderText({
    paste(
      "Selected values:",
      "\nAge:", input$age[1], "-", input$age[2],
      ",\nGender:", input$gender,
      ",\nBMI:", input$bmi[1], "-", input$bmi[2],
      ",\nSymptoms:", ifelse(length(input$symptoms) > 0, paste(input$symptoms, collapse = ", "), "None"),
      ",\nWBC:", input$wbc[1], "-", input$wbc[2],
      ",\nRBC:", input$rbc[1], "-", input$rbc[2],
      ",\nHGB:", input$hgb[1], "-", input$hgb[2],
      ",\nPlatelet:", input$plat[1], "-", input$plat[2]
    )
  })

  output$idiom1 <- renderPlot({
    req(input$xaxis, input$yaxis)
    x_axis <- input$xaxis
    y_axis <- input$yaxis

    data <- filter_dataset()

    p <- ggplot(data = data, aes(x = as.numeric(.data[[input$xaxis]]), y = as.numeric(.data[[input$yaxis]]))) +
      geom_point() +
      theme(legend.position = "top") +
      labs(title = paste("Scatterplot", input$xaxis, " vs ", input$yaxis), x = input$xaxis, y = input$yaxis)
    return(p)
  })

  output$idiom2 <- renderPlot({
    data <- filter_dataset()
    histo_staging_counts <- table(data$Baselinehistological.staging)
    barplot(histo_staging_counts, main = "Barplot of Baseline Histological Staging",
            xlab = "Histological Staging", ylab = "Frequency", col = "lightblue")
  })


  output$idiom3 <- renderPlot({
    data <- filter_dataset()

    cols <- c(time_series_1, c("Baselinehistological.staging"))
    df_subset <- data[, cols]

    size <- 8
    df_plot <- head(df_subset, size)

    df_plot_long <- df_plot %>%
      mutate(RowID = row_number())

    df_plot_long <- df_plot_long %>%
      tidyr::pivot_longer(
        cols = starts_with("ALT"),
        names_to = "Time",
        values_to = "Value"
      )


    df_plot_long$Time <- factor(df_plot_long$Time,
      levels = paste0("ALT.", c(1, 4, 12, 24, 36, 48)),
      ordered = TRUE
    )

    df_plot_long$Baselinehistological.staging <- as.factor(df_plot_long$Baselinehistological.staging)

    df_mean_orders <- df_plot_long %>%
      group_by(Time) %>%
      summarise(mean_value = mean(Value))

    df_mean_orders$RowID <- 0

    p <- ggplot(data = df_plot_long, aes(x = Time, y = Value, group = RowID)) +
      scale_color_manual(values = colors) +
      geom_line(aes(color = Baselinehistological.staging)) +
      geom_line(data = df_mean_orders, aes(x = Time, y = mean_value), color = "red", linetype = "dotted", linewidth = 1.5) +
      theme_minimal() +
      labs(x = "Time", y = "Value") +
      theme(
        aspect.ratio = 1 / 3, # Establecer una relación de aspecto para que el gráfico sea tres veces más ancho que alto
      )

    return(p)
  })
}
