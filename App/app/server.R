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


categorical_features <- c(
  "Gender",
  "Fever",
  "Nausea.Vomting",
  "Headache",
  "Diarrhea",
  "Fatigue.generalized.bone.ache",
  "Jaundice",
  "Epigastric.pain",
  "Baselinehistological.staging"
)

continius_features <- c(
  "WBC", "HGB", "RBC", "Age",
  "BMI", "Platelet"
)


server <- function(input, output) {
  # TODO -sintoms filtering and others

  filter_dataset <- reactive({
    dataset %>%
      filter(
        Age >= input$age[1] & Age <= input$age[2],
        (Gender == input$gender | input$gender == "Both"),
        BMI >= input$bmi[1] & BMI <= input$bmi[2],
        WBC >= input$wbc[1] & WBC <= input$wbc[2],
        RBC >= input$rbc[1] & RBC <= input$rbc[2],
        HGB >= input$hgb[1] & HGB <= input$hgb[2],
        Platelet >= input$plat[1] & Platelet <= input$plat[2],
        (Fever == input$Fever | input$Fever == "--"),
        (Nausea.Vomting == input$Nausea.Vomting | input$Nausea.Vomting == "--"),
        (Headache == input$Headache | input$Headache == "--"),
        (Diarrhea == input$Diarrhea | input$Diarrhea == "--"),
        (Fatigue.generalized.bone.ache == input$Fatigue.generalized.bone.ache | input$Fatigue.generalized.bone.ache == "--"),
        (Jaundice == input$Jaundice | input$Jaundice == "--"),
        (Epigastric.pain == input$Epigastric.pain | input$Epigastric.pain == "--")
      )
  })

  output$meta_info <- renderText({
    paste("Authors:", paste(members, collapse = ", "))
  })


  output$n_patients <- renderText({
    data <- filter_dataset()
    paste("Number of patients being shown: ", paste(nrow(data), collapse = ", "))
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
    s_value <- input$svalue
    c_value <- input$color

    data <- filter_dataset()

    # Compute min and max values for x-axis and y-axis
    # min_value_x <- min(dataset[[x_axis]], na.rm = TRUE)
    # max_value_x <- max(dataset[[x_axis]], na.rm = TRUE)
    # min_value_y <- min(dataset[[y_axis]], na.rm = TRUE)
    # max_value_y <- max(dataset[[y_axis]], na.rm = TRUE)

    # Create the scatterplot
    p <- ggplot(data, aes(x = as.numeric(.data[[x_axis]]), y = as.numeric(.data[[y_axis]]), size = as.numeric(.data[[s_value]]))) +
      geom_point(alpha = 0.5, color = "steelblue") +
      scale_size(range = c(2, 10), name = s_value) +
      theme(legend.position = "top") +
      labs(title = paste("Bubble Chart :", x_axis, " vs ", y_axis, "with", s_value), x = x_axis, y = y_axis)
    + # coord_cartesian(xlim = c(min_value_x, max_value_x), ylim= c(min_value_y, max_value_y))

      return(p)
  })


  output$idiom2 <- renderPlot({
    req(input$featureidiom2)
    req(input$featureidiom2_)

    data <- filter_dataset()

    feature <- str_replace_all(input$featureidiom2, c(" " = ".", "/" = "."))
    
    feature_ <- str_replace_all(input$featureidiom2_, c(" " = ".", "/" = "."))

    if (feature %in% categorical_features) {
      p <- ggplot(data, aes(x = factor(.data[[feature]]), fill = factor(.data[[feature_]]))) +
        geom_bar(position = "dodge", stat = "count") +
        labs(title = paste("Distribution of ", feature, ", grouped by", feature_), x = paste(feature," value"), y = "Frequency")
    }
    else if (feature %in% continius_features) {
      p <- ggplot(data, aes(x = .data[[feature]], fill = factor(.data[[feature_]]))) +
        geom_bar(position = "stack", stat = "count") +
        labs(title = paste("Distribution of ", feature, ", stacked by", feature_), x = paste(feature, " value"), y = "Frequency")
    }else{
      paste("Error:", paste(members, collapse = ", "))
    }      
    return(p)
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
        geom_hline(yintercept = 56, linetype = "dashed", color = "green", linewidth = 1) + # Max normal ALT value # https://www.ncbi.nlm.nih.gov/books/NBK559278/
        geom_hline(yintercept = 7, linetype = "dashed", color = "orange", linewidth = 1) # Min normal ALT value
    }


    return(p)
  })
}
