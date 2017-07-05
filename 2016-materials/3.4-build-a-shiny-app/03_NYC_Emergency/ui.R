library(shiny)

nyc <- read.csv("nyc_emergency.csv", stringsAsFactors = FALSE)

shinyUI(fluidPage(
    
    titlePanel("NYC Crime Data"),
    
	sidebarPanel(
	    selectInput("incident_type", "Incident Type", choices = sort(unique(nyc$Incident.Type)), selected = "Fire-3rd Alarm")
	),

	mainPanel(
	    plotOutput("crime")
	)
))
