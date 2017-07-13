#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tourr)
library(tidyverse)
library(plotly)

data(olive)
#olive_mds <- cmdscale(dist(apply(olive[,3:10], 2, scale)),
#                      k=2, x.ret=TRUE)
olive$region <- factor(olive$region, levels=1:3, labels=c("South", "Sardinia", "North"))
load("olive_tsne.rda")
olive <- olive %>% mutate(MDS1=tsne_olive[,1],
                          MDS2=tsne_olive[,2])
myscale <- function(x) (x - mean(x)) / sd(x)
scale.dat.melt <- olive %>%
  select(region, palmitic:eicosenoic) %>%
  mutate_each(funs(myscale), -region) %>%
  mutate(ids = 1:nrow(olive)) %>%
  gather(var, Value, -region, -ids, convert=TRUE) %>%
  mutate(Variables = as.numeric(factor(var),
                                levels=c("eicosenoic", "oleic",
                                         "linoleic", "arachidic",
                                         "linolenic", "palmitic",
                                         "palmitoleic", "stearic")))
colnames(scale.dat.melt)[1] <- "Class"

# Define UI for application that draws a histogram
ui <- fluidPage(

   # Application title
   titlePanel("Parallel coordinate plot linked to t-SNE plot"),
   fluidRow(column(
     width = 3,
     align = "center",
     plotlyOutput("mdsplot", width = 300, height = 300)), column(
     width = 7, align = "center",
     plotlyOutput("parallel", width=500, height = 400))
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  #Define reactive values for MDS plot and vote matrix plots
  rv <- reactiveValues(data = data.frame(
    MDS1 = tsne_olive[,1], MDS2 = tsne_olive[,2],
    Class = olive[,1], ids = 1:nrow(olive),
    fill = logical(nrow(olive))))

  #function to update selected elements in each plot
  updateRV <- function(selected) {
    fill <- logical(length(rv$data$fill))
    fill[selected] <- TRUE
    rv$data$fill <- fill
  }

  observeEvent(event_data("plotly_selected"),{
    selected <- rv$data$ids %in% event_data("plotly_selected")$key
    updateRV(selected)
  })

  observeEvent(event_data("plotly_click"),{
    k <- event_data("plotly_click")$key
    if (any(k %in% unique(rv$data$ids))){
      selected <- rv$data$ids %in% k
    }

    updateRV(selected)
  })

  output$parallel <- renderPlotly({
    yy <- rv$data$ids[rv$data$fill]

      p <- ggplot(scale.dat.melt, aes(x = Variables, y = Value,
                  group = ids, key = ids, colour = Class, var = var)) +
        geom_line(alpha = 0.5) +
        scale_x_discrete(limits = levels(as.factor(scale.dat.melt$var)),
                         expand = c(0.01,0.01)) +
        ggtitle("PCP") +
        theme(legend.position = "none",
              axis.text.x  = element_text(angle = 90, vjust = 0.5)) +
        scale_colour_brewer(type = "qual", palette = "Dark2")

      if (length(yy) > 0) {
        dat <-   scale.dat.melt %>% dplyr::filter(ids %in% yy)
        p <- ggplot(scale.dat.melt, aes(x = Variables, y = Value,
                group = ids, key = ids, color = Class, var = var)) +
          geom_line(alpha = 0.05) +
          scale_x_discrete(limits = levels(as.factor(scale.dat.melt$var)),
                           expand = c(0.01,0.01)) +
          ggtitle("PCP") +
            theme(legend.position = "none",
                  axis.text.x  = element_text(angle = 90, vjust = 0.5)) +
          scale_colour_brewer(type = "qual",palette = "Dark2")

        p <- p + geom_line(data = dat, size=1)
      }
    ggplotly(p,tooltip = c("var","colour","y","key")) %>%
      layout(dragmode = "select")
  })

  #MDS plot
  output$mdsplot <- renderPlotly({
    yy <- rv$data$ids[rv$data$fill]

    p <- ggplot(data = rv$data, aes(x = MDS1, y = MDS2,
                                    colour = Class, key = ids)) +
      geom_point(size = I(3), alpha = .5)  +
      theme(legend.position = "none",
            legend.text = element_text(angle = 90),
            legend.key = element_blank(),
            aspect.ratio = 1) +
      labs(y = "MDS 2", x = "MDS 1",
           title = "t-SNE") +
      scale_colour_brewer(type = "qual",palette = "Dark2")

    if (length(yy) > 0) {
      dat <- rv$data %>% dplyr::filter(ids %in% yy)
      p <- ggplot(data = rv$data,
                  aes(x = MDS1, y = MDS2, color = Class, key = ids)) +
             geom_point(size = I(3), alpha = .1) +
             theme(legend.position = "none",
                   legend.text = element_text(angle = 90),
                   legend.key = element_blank(), aspect.ratio = 1) +
        labs(y = "MDS 2", x = "MDS 1", title = "t-SNE")  +
        scale_colour_brewer(type =   "qual",palette = "Dark2")

      p <- p + geom_point(data = dat, size =  I(3))

    }
    ggplotly(p,tooltip = c("colour","x","y","key")) %>% layout(dragmode = "select")

  })
}

# Run the application
shinyApp(ui = ui, server = server)

