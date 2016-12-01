

library(shiny)
library(ggvis)

# Define UI for application that draws a histogram
ui <- shinyUI((pageWithSidebar(
  div(),
  sidebarPanel(
    fileInput('datfile', " "),
    selectInput('x', 'x:' ,'x'),
    selectInput('y', 'y:', 'y'),
    uiOutput("plot_ui")
  ),
  mainPanel(
    ggvisOutput("plot")
  )
)))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
  
  theData <- reactive({
    infile <- input$datfile        
    if(is.null(infile))
      return(NULL)        
    d <- read.csv(infile$datapath, header = T)
    d        
  })
  
  
  
  # dynamic variable names
  observe({
    data<-theData()
    updateSelectInput(session, 'x', choices = names(data))
    updateSelectInput(session, 'y', choices = names(data))
    
  }) # end observe
  
  #gets the y variable name, will be used to change the plot legends
  yVarName<-reactive({
    input$y
  })
  
  #gets the x variable name, will be used to change the plot legends
  xVarName<-reactive({
    input$x
  })
  
  #make the filteredData frame
  
  filteredData<-reactive({
    data<-isolate(theData())
    #if there is no input, make a dummy dataframe
    if(input$x=="x" && input$y=="y"){
      if(is.null(data)){
        data<-data.frame(x=0,y=0)
      }
    }else{
      data<-data[,c(input$x,input$y)]
      names(data)<-c("x","y")
    }
    data
  })
  
  #plot the ggvis plot in a reactive block so that it changes with filteredData
  vis<-reactive({
    plotData<-filteredData()
    plotData %>%
      ggvis(~x, ~y) %>%
      layer_points() %>%
      add_axis("y", title = yVarName()) %>%
      add_axis("x", title = xVarName()) %>%
      add_tooltip(function(df) format(sqrt(df$x),digits=2))
  })
  vis%>%bind_shiny("plot", "plot_ui")
  
})

# Run the application 
shinyApp(ui = ui, server = server)                        



