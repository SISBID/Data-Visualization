library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        if (input$dist == "Normal") {
            dist <- rnorm(n = input$obs, input$mean, input$sd)
        } else if (input$dist == "Gamma") {
            dist <- rgamma(n = input$obs, shape = input$shape, rate = input$rate)
        }

        hist(dist)
    })
})
