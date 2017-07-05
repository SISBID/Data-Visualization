library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Hello Shiny World!"),
    
    # Sidebar with a slider input for the number of bins
	sidebarPanel(
	    sliderInput("obs",
		        "Number of Observations:",
		        min = 0,
		        max = 5000,
		        value = 2500),
	    numericInput("mean", 
	                 "Mean:", value = 0, step=1),
	    numericInput("sd", "Standard Deviation:",
	                 value = 1, min=0, step = .1)
	),

	# Show a plot of the generated distribution
	mainPanel(
	    plotOutput("distPlot")
	)
))
