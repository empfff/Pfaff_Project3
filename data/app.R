library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Frequent Collaborators of UNC-CH Investigators"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Output: HTML table with requested number of observations ----
      tableOutput("view"),
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a Top Collaborator:",
                  choices = c("Boston", "Durham", "New York", "Houston","Seattle","Chicago","Los Angeles","Philadelphia,","Bethesda","Rochester")),
      
      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "obs",
                   label = "Number of words to view:",
                   value = 10)

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the dataset for the plot ----
  datasetInput <- reactive({
    switch(input$dataset,
           "Boston" = read.csv("wordCounts_Boston.csv"),
           "Durham" = read.csv("wordCounts_Durham.csv"),
           "New York" = read.csv("wordCounts_New York.csv"),
           "Houston" = read.csv("wordCounts_New York.csv"),
           "Seattle" = read.csv("wordCounts_New York.csv"),
           "Chicago" = read.csv("wordCounts_New York.csv"),
           "Los Angeles" = read.csv("wordCounts_New York.csv"),
           "Philadelphia" = read.csv("wordCounts_New York.csv"),
           "Bethesda" = read.csv("wordCounts_New York.csv"),
           "Rochester" = read.csv("wordCounts_New York.csv")
           )
  })
  
  # Return the dataset for the table ----
  datasetInput2 <- read.csv("collabCounts.csv",colClasses=c("NULL",NA,NA),col.names = c("blah","Collaborator","Abstracts"))
  
  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput2, n = 10)
  })
  
  # Histogram of chosen dataset
  output$distPlot <- renderPlot({
    dataset <- datasetInput()
    dataset <- head(dataset,n=input$obs)
    plottitle <- paste("Term Frequencies Between UNC and",input$dataset)
    ggplot(dataset, mapping=aes(x=reorder(word,-freq),y=freq)) + 
      geom_bar(stat="identity",fill="cyan4") +
      labs(title = plottitle,x="Word",y="Frequency Word Used") + 
      theme(axis.text.x = element_text(size=12,angle=90)) + 
      theme(axis.text.y = element_text(size=12))
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)