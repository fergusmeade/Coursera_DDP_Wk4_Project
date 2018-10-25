library(shiny)
library(dplyr)
library(ggplot2)
options(shiny.reactlog=TRUE)

load("Crops.rda")

shinyServer(function(input, output) {
    
    dat <- reactive({
        url <- "http://www.cso.ie/px/pxeirestat/Database/Eirestat/Regional%20Accounts/ACA03.px"
        ACA03df <- as.data.frame(pxR::read.px(url))
        Crops <- ACA03df %>% 
            filter(Statistic %in% levels(ACA03df$Statistic)[10:16]) %>% #restrict to data about crops
            filter(Region == "State") %>%
            filter(Statistic == input$Statistic)
    })
    
    output$yearplot <- renderPlot({
        
        ggplot(dat(), aes(Year, value, group = Statistic, colour = Statistic)) +
            geom_line() + geom_point() + theme_minimal()
        
    })
    
    output$yeartable <- renderDataTable({
        
        arrange(dat(), desc(value))
        
    })
    
})

