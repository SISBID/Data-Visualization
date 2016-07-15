library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Hello Shiny!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarPanel(
        selectInput("dist", 
                    "Distribution", 
                    choices = c("Normal", "Gamma")),
        
        sliderInput("obs",
                    "Number of Observations:",
                    min = 0,
                    max = 1000,
                    value = 500),
        
        conditionalPanel(condition = "input.dist == 'Normal'",
             numericInput("mean",
                          "Mean of Distribution:",
                          value = 0),
             
             numericInput("sd",
                          "SD of Distribution:",
                          min = 0,
                          value = 1)          
        ),
        
        conditionalPanel(condition = "input.dist == 'Gamma'",
             numericInput("shape",
                          "Shape of Distribution:",
                          value = 1,
                          min = 0),
             
             numericInput("rate",
                          "Rate of Distribution",
                          value = 1,
                          min = 0)
        )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("distPlot")
    )
))
