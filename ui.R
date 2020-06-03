library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Predict the next word"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4(br(), "Enter text in the space provided", br()),
            h4(br(), "The algorithm predicts the subsequent word based on the ngram predictive algorithm", br()),
            h4(br(), "Depending on the entered text, a maximum of five words are predicted", br()),
            h4(br(), "Click on the submit button after entering the text"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("This word prediction algorithm using N-grams provides suggestions for next word depending on the entered text", br()),
            textInput("sent", value = "Welcome", label = h4("Enter text here:")),
            submitButton('Submit'),
            h4(br(), "The predictions for next word are:", br()),
            verbatimTextOutput("pred")
                        
        )
    )
))
