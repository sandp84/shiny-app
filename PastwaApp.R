

library(shiny)
library(shinythemes)

########################
ui <- fluidPage(theme = shinytheme("united"),
                navbarPage("Insulin Replacement Calculator:",
                           tabPanel("Home",
                                    # Input values
                                    sidebarPanel(
                                      HTML("<h3>Input parameters</h3>"),
                                      sliderInput("Premealbs", 
                                                  label = "Premeal Blood Sugar", 
                                                  value = 120, 
                                                  min = 60, 
                                                  max = 350),
                                      sliderInput("Mealcarbs", 
                                                  label = "Meal Carbohydrates", 
                                                  value = 50, 
                                                  min = 10, 
                                                  max = 225),
                                      sliderInput("carbtoins", 
                                                  label = "Carbohydrate to Insulin Ratio", 
                                                  value = 10, 
                                                  min = 5, 
                                                  max = 200),
                                      sliderInput("BSgoal", 
                                                  label = "Blood Sugar Goal", 
                                                  value = 100, 
                                                  min = 80, 
                                                  max = 130),
                                      sliderInput("ISF", 
                                                  label = "Insulin Sensitivity Factor", 
                                                  value = 10, 
                                                  min = 5, 
                                                  max = 200),
                                      
                                      actionButton("submitbutton", 
                                                   "Submit", 
                                                   class = "btn btn-primary")
                                    ),
                                    mainPanel(
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata')
                                      )),
                                    tabPanel("About", 
                                             titlePanel("About"),
                                             div(includeMarkdown("about.md"),
                                                 align="justify"))))
                                    

####################################

server <- function(input, output, session) {
  datasetInput <- reactive({  
    total <- input$Mealcarbs/input$carbtoins + ((input$Premealbs - input$BSgoal)/input$ISF)
    total <- data.frame(total)
    names(total) <- "Total Insulin"
    print(total)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


####################################
shinyApp(ui = ui, server = server)
