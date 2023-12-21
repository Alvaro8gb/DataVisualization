library(shiny)

dataset <- read.csv("../dataset/ds-final.csv")

departament <- list("d1", "d2")

style <- "background-color: #F4F5F5;padding: 5px;"

ui <- fluidPage(
  titlePanel("Hepatitis Visualization App"),
  verbatimTextOutput("members"),
  sidebarPanel(
    sliderInput("age", "Age", min = min(dataset$Age), max = max(dataset$Age), value = c(min(dataset$Age), max(dataset$Age))),
    selectInput("gender", "Gender", choices = c("Both", "Male", "Female")),
    sliderInput("bmi", "BMI (Body Mass Index)", min = min(dataset$BMI), max = max(dataset$BMI), value = c(min(dataset$BMI), max(dataset$BMI))),
    checkboxGroupInput("symptoms", "Symptoms", choices = c("Fever", "Nausea/Vomting", "Headache", "Diarrhea", "Fatigue generalized bone ache", "Jaundice", "Epigastric pain")),
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
      column(6, selectInput("xaxis", "X-axis", choices = c("BMI", "Baselinehistological.staging", "Baseline.histological.Grading", "Age"))),
      column(6,  selectInput("yaxis", "Y-axis", choices = c("Baselinehistological.staging", "Baseline.histological.Grading", "BMI", "Age")))
      ),
      plotOutput("idiom1"),
    ),
    fluidRow(
      style = style,
      helpText("2. Idiom"),
      plotOutput("idiom2"),
    ),
    fluidRow(
      style = style,
      helpText("3. Idiom"),
      plotOutput("idiom3"),
    )
  )
)
