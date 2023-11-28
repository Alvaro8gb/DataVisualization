library(shiny)

departament <- list("d1", "d2")

ui <- fluidPage(
  titlePanel("Hepatitis Visualization App"),
  verbatimTextOutput("members"),
  sidebarPanel(
      sliderInput("age", "Age", min = 32, max = 61, value = c(32, 61)),
      selectInput("gender", "Gender", choices = c("Male", "Female")),
      sliderInput("bmi", "BMI (Body Mass Index)", min = 22, max = 35, value = c(22, 35)),
      checkboxGroupInput("symptoms", "Symptoms", choices = c("Fever", "Nausea/Vomiting", "Headache", "Diarrhea", "Fatigue and generalized", "Bone ache", "Jaundice", "Epigastric pain")),
      sliderInput("wbc", "WBC (White blood cell)", min = 299, max = 12101, value = c(299, 12101)),
      sliderInput("rbc", "RBC (Red blood cells)", min = 3816422, max = 5018451, value = c(3816422, 5018451)),
      sliderInput("hgb", "HGB (Hemoglobin)", min = 10, max = 15, value = c(10, 15)),
      sliderInput("plat", "Platelet", min = 93013, max = 226464, value = c(93013, 226464))
    ),
    
    mainPanel(
      textOutput("selectedValues")
    ),
  fluidRow(
    style = "background-color: #F4F5F5;padding: 5px;",
    helpText("1. Idiom."),
    column(5, selectInput("var1",
      label = "Choose a personal information",
      choices = list(
        "Department",
        "HispanicLatino",
        "CitizenDesc",
        "MaritalDesc",
        "RaceDesc",
        "RecruitmentSource",
        "Sex"
      ),
      selected = "Department"
    )),
    column(5, selectInput("var2",
      label = "Choose a working situation indicator",
      choices = list(
        "Salary",
        "PerformanceScore",
        "EmpSatisfaction"
      ),
      selected = "Salary"
    )),
  ),
  fluidRow(
    style = "background-color: #F4F5F5;padding: 5px;",
    helpText("2. Idiom"),
    column(5, selectInput("var",
      label = "Choose a job industry",
      choices = c("Production", "IT_IS", "Software_Engineering", "Sales", "Admin_Offices", "Executive_Office"),
      selected = "Production"
    )),
    column(5, sliderInput("range",
      label = "Range of Salary:",
      min = 45046, max = 250000, value = c(45046, 250000), pre = "$"
    )),
  ),
  fluidRow(
    style = "background-color: #F4F5F5;padding: 5px;",
    helpText("3. Idiom"),
    column(
      3,
      selectInput("depart",
        label = "Choose the area of the job title",
        choices = departament, selected = "IT_IS"
      )
    )
  )
)
