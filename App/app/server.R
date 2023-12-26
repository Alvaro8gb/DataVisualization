# server.R
library(shiny)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(stringr)


colors <- brewer.pal(n = 4, name = "Blues")

dataset <- read.csv("../dataset/ds-final.csv")

members <- list("Alvaro", "Maxi", "Mikel")

time_series_1 <- c("ALT.1", "ALT.4", "ALT.12", "ALT.24", "ALT.36", "ALT.48")

TARGET <- "Baselinehistological.staging"


# Map input values to corresponding values in the dataset
gender_mapping <- c("Male" = "1", "Female" = "2", "Both" = "3")

server <- function(input, output) {
  # TODO -sintoms filtering and others

  filter_dataset <- reactive({
    dataset %>%
      filter(
        Age >= input$age[1] & Age <= input$age[2],
        (Gender == gender_mapping[input$gender] | input$gender == "Both"),
        BMI >= input$bmi[1] & BMI <= input$bmi[2],
        WBC >= input$wbc[1] & WBC <= input$wbc[2],
        RBC >= input$rbc[1] & RBC <= input$rbc[2],
        HGB >= input$hgb[1] & HGB <= input$hgb[2],
        Platelet >= input$plat[1] & Platelet <= input$plat[2]
      ) %>%
      filter(if_any(all_of(str_replace_all(input$symptoms, c(" " = ".", "/" = "."))), ~ . == 1))
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
      ",\nPlatelet:", input$plat[1], "-", input$plat[2],
      "Feature:", input$featureidiom2,
      "Levels:", paste(input$levels, collapse = ", ")
    )
  })

  output$idiom1 <- renderPlot({
    req(input$xaxis, input$yaxis)
    x_axis <- input$xaxis
    y_axis <- input$yaxis

    data <- filter_dataset()

    # Compute min and max values for x-axis
    min_value_x <- min(dataset[[x_axis]], na.rm = TRUE)
    max_value_x <- max(dataset[[x_axis]], na.rm = TRUE)
    min_value_y <- min(dataset[[y_axis]], na.rm = TRUE)
    max_value_y <- max(dataset[[y_axis]], na.rm = TRUE)

    # Create the scatterplot
    p <- ggplot(data, aes(x = as.numeric(.data[[x_axis]]), y = as.numeric(.data[[y_axis]]))) +
      geom_point() +
      theme(legend.position = "top") +
      labs(title = paste("Scatterplot", x_axis, " vs ", y_axis), x = x_axis, y = y_axis) +
      coord_cartesian(xlim = c(min_value_x, max_value_x), ylim= c(min_value_y, max_value_y))

    return(p)
  })

  output$idiom2 <- renderPlot({
    req(input$featureidiom2)

    data <- filter_dataset()

    feature <- input$featureidiom2

    # Create a bar plot
    plot <- ggplot(data = data, aes(x = factor(.data[[TARGET]]), y = .data[[TARGET]])) +
      geom_violin(fill = "lightblue", draw_quantiles = c(0.25, 0.5, 0.75)) +
      geom_jitter(color = "darkblue", width = 0.2) +
      labs(
        title = paste("Distribution of", feature, "with respect to", TARGET),
        x = TARGET, y = feature
      ) +
      coord_cartesian(ylim = c(0, 8))


    return(plot)
  })


  output$idiom3 <- renderPlot({
    req(input$levels)

    data <- filter_dataset()

    data <- data %>% filter(.data[[TARGET]] %in% input$levels)


    df_plot <- data[, time_series_1]


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


    df_plot_long %>%
      group_by(Time) %>%
      summarise(
        mean_value = mean(Value),
        sd_value = sd(Value)
      ) -> df_mean_orders


    df_mean_orders$Value <- 0
    df_mean_orders$RowID <- 0

    p <- ggplot(data = df_plot_long, aes(x = Time, y = Value, group = RowID)) +
      geom_line(data = df_mean_orders, aes(x = Time, y = mean_value), color = "red", linetype = "dotted", linewidth = 1.5) +
      geom_line(color = "#629bdb") +
      geom_ribbon(
        data = df_mean_orders,
        aes(x = Time, ymin = mean_value - sd_value, ymax = mean_value + sd_value),
        fill = "#a3b349", alpha = 0.3
      ) +
      theme_minimal() +
      labs(x = "Time", y = "Value") +
      theme(
        aspect.ratio = 1 / 4
      ) +
      theme(legend.position = "none") +
      coord_cartesian(ylim = c(0, 150))


     if (input$inplot3) {
        p <- p +
          geom_hline(yintercept = 56, linetype = "dashed", color = "green", size = 1) + # Max normal ALT value # https://www.ncbi.nlm.nih.gov/books/NBK559278/
          geom_hline(yintercept = 7, linetype = "dashed", color = "orange", size = 1)   # Min normal ALT value
      }


    return(p)
  })
}
