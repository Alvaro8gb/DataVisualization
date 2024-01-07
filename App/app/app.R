library(shiny)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(stringr)

## Static

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

yes_no_ <- c(
    "Gender",
    "Fever",
    "Nausea/Vomting",
    "Headache",
    "Diarrhea",
    "Fatigue generalized bone ache",
    "Jaundice",
    "Epigastric pain"
)

gender_choices <- c("Both", "Male", "Female")
attribute_choices <- c("--", "Yes", "No")

continius_features <- c(
    "WBC", "HGB", "RBC", "Age",
    "BMI", "Platelet"
)

colors <- brewer.pal(n = 4, name = "Blues")

dataset <- read.csv("ds-final.csv")

members <- list("Alvaro", "Maxi", "Mikel")

time_series_1 <- c("ALT.1", "ALT.4", "ALT.12", "ALT.24", "ALT.36", "ALT.48")

TARGET <- "Baselinehistological.staging"

levels <- unique(dataset$Baselinehistological.staging)

style <- "background-color: #F4F5F5;padding: 5px;"

members <- list("Alvaro", "Maxi", "Mikel")


############
## UI/UX ###
############


ui <- fluidPage(
    tags$head(
        tags$style(HTML("
      #sidebar {
        position: fixed;
        width: 30%;
        height: 88%;
        background-color: #f8f9fa;
        border-right: 1px solid #dee2e6;
        overflow-y: auto;
      }
    "))
    ),
    titlePanel("Hepatitis Visualization App"),
    verbatimTextOutput("meta_info"),
    sidebarPanel(
        id = "sidebar",
        titlePanel("Cohort Selection"),
        p(verbatimTextOutput("n_patients")),
        sliderInput("age", "Age", min = min(dataset$Age), max = max(dataset$Age), value = c(min(dataset$Age), max(dataset$Age))),
        selectInput("gender", "Gender", choices = gender_choices),
        sliderInput("bmi", "BMI (Body Mass Index)", min = min(dataset$BMI), max = max(dataset$BMI), value = c(min(dataset$BMI), max(dataset$BMI))),
        selectInput("Fever", "Fever", choices = attribute_choices),
        selectInput("Nausea.Vomting", "Nausea.Vomting", choices = attribute_choices),
        selectInput("Headache", "Headache", choices = attribute_choices),
        selectInput("Diarrhea", "Diarrhea", choices = attribute_choices),
        selectInput("Fatigue.generalized.bone.ache", "Fatigue.generalized.bone.ache", choices = attribute_choices),
        selectInput("Jaundice", "Jaundice", choices = attribute_choices),
        selectInput("Epigastric.pain", "Epigastric.pain", choices = attribute_choices),
        sliderInput("wbc", "WBC (White blood cell)", min = 299, max = 12101, value = c(299, 12101)),
        sliderInput("rbc", "RBC (Red blood cells)", min = 3816422, max = 5018451, value = c(3816422, 5018451)),
        sliderInput("hgb", "HGB (Hemoglobin)", min = 10, max = 15, value = c(10, 15)),
        sliderInput("plat", "Platelet", min = 93013, max = 226464, value = c(93013, 226464))
    ),
    mainPanel(
        # textOutput("selectedValues"),
        fluidRow(
            style = style,
            helpText("1. Idiom."),
            fluidRow(
                column(6, selectInput("xaxis", "X-axis", choices = c("BMI", "WBC", "Baselinehistological.staging", "Baseline.histological.Grading", "Age"))),
                column(6, selectInput("yaxis", "Y-axis", choices = c("Baselinehistological.staging", "WBC", "Baseline.histological.Grading", "BMI", "Age"))),
                column(6, selectInput("svalue", "Size", choices = c("Age", "WBC", "Baselinehistological.staging", "Baseline.histological.Grading", "BMI"))),
            ),
            plotOutput("idiom1"),
        ),
        fluidRow(
            style = style,
            helpText("2. Idiom"),
            fluidRow(
                column(6, selectInput("featureidiom2", "Distribution feature", choices = c(categorical_features, c("Age")))),
                column(6, selectInput("featureidiom2_", "Group feature", choices = yes_no_))
            ),
            plotOutput("idiom2"),
        ),
        fluidRow(
            style = style,
            helpText("3. Idiom"),
            fluidRow(
                column(6, selectInput("levels", "Base line histological Staging", choices = levels, multiple = TRUE, selected = "1")),
                column(6, checkboxInput("inplot3", "Min/Max", value = FALSE))
            ),
            plotOutput("idiom3"),
        )
    )
)



############
## Server ##
############

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

        p <- ggplot(data, aes(x = as.numeric(.data[[x_axis]]), y = as.numeric(.data[[y_axis]]), size = as.numeric(.data[[s_value]]))) +
            geom_point(alpha = 0.5, color = "steelblue") +
            scale_size(range = c(2, 10), name = s_value) +
            theme(legend.position = "top") +
            labs(title = paste("Bubble Chart :", x_axis, " vs ", y_axis, "with", s_value), x = x_axis, y = y_axis)

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
                labs(title = paste("Distribution of ", feature, ", grouped by", feature_), x = paste(feature, " value"), y = "Frequency")
        } else if (feature %in% continius_features) {
            p <- ggplot(data, aes(x = .data[[feature]], fill = factor(.data[[feature_]]))) +
                geom_bar(position = "stack", stat = "count") +
                labs(title = paste("Distribution of ", feature, ", stacked by", feature_), x = paste(feature, " value"), y = "Frequency")
        } else {
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

# Run the app
shinyApp(ui, server)
