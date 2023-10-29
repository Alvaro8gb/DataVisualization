library(shiny)

departament <- list("d1", "d2")

ui <- fluidPage(
  titlePanel("Lung Cancer Data Visualization App"),
   verbatimTextOutput("members"),
  
  fluidRow(style ="background-color: #F4F5F5;padding: 5px;",
    helpText("1. Idiom."),
    column(5, selectInput("var1", 
                         label = "Choose a personal information",
                         choices = list("Department", 
                                        "HispanicLatino",
                                        "CitizenDesc",
                                        "MaritalDesc",
                                        "RaceDesc",
                                        "RecruitmentSource",
                                        "Sex"),
                         selected = "Department")),
    
    column(5,selectInput("var2", 
                         label = "Choose a working situation indicator",
                         choices = list("Salary", 
                                        "PerformanceScore",
                                        "EmpSatisfaction"), 
                         selected = "Salary")),
  ),


  fluidRow(style ="background-color: #F4F5F5;padding: 5px;",
           helpText("2. Idiom"),
    column(5,selectInput("var", 
                         label = "Choose a job industry",
                         choices = c("Production", "IT_IS", "Software_Engineering", "Sales", "Admin_Offices", "Executive_Office"),
                         selected = "Production")),
    
    column(5, sliderInput("range", 
                         label = "Range of Salary:",
                         min = 45046, max = 250000, value = c(45046, 250000), pre='$')),
  ),
  
  fluidRow(style ="background-color: #F4F5F5;padding: 5px;",
           helpText("3. Idiom"),
           column(3,
                  selectInput("depart", label="Choose the area of the job title", 
                              choices = departament, selected = "IT_IS"))
  )
)