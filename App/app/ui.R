library(shiny)

dataset <- read.csv("../dataset/ds-final.csv")

style <- "background-color: #F4F5F5;padding: 5px;"

members <- list("Alvaro", "Maxi", "Mikel")

yes_no <- c("Fever", "Nausea/Vomting", "Headache", "Diarrhea", "Fatigue generalized bone ache", "Jaundice", "Epigastric pain")
gender_choices <- c("Both", "Male", "Female")

levels <- unique(dataset$Baselinehistological.staging)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      #sidebar {
        position: fixed;
        width: 30%;
        background-color: #f8f9fa;
        border-right: 1px solid #dee2e6;
        overflow-y: auto;
      }
    "))
  ),
  titlePanel("Hepatitis Visualization App"),
  verbatimTextOutput("members"),
  sidebarPanel(
    id = "sidebar",
    titlePanel("Cohort Selection"),
    sliderInput("age", "Age", min = min(dataset$Age), max = max(dataset$Age), value = c(min(dataset$Age), max(dataset$Age))),
    selectInput("gender", "Gender", choices = gender_choices),
    sliderInput("bmi", "BMI (Body Mass Index)", min = min(dataset$BMI), max = max(dataset$BMI), value = c(min(dataset$BMI), max(dataset$BMI))),
    checkboxGroupInput("symptoms", "Symptoms", choices = yes_no),
    sliderInput("wbc", "WBC (White blood cell)", min = 299, max = 12101, value = c(299, 12101)),
    sliderInput("rbc", "RBC (Red blood cells)", min = 3816422, max = 5018451, value = c(3816422, 5018451)),
    sliderInput("hgb", "HGB (Hemoglobin)", min = 10, max = 15, value = c(10, 15)),
    sliderInput("plat", "Platelet", min = 93013, max = 226464, value = c(93013, 226464))
  ),
  mainPanel(
    textOutput("selectedValues"),
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
        column(6, selectInput("featureidiom2", "Distribution feature", choices = yes_no))
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
