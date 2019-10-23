

library(shiny); library(dplyr); library(plotly); library(caret); library(randomForest)

load("dt1.rds")
load("dtDelays.rds")

rideList <- unique(dt1 %>% arrange(Ride) %>% select(Ride))
dayList <- unique(dt1 %>% arrange(Date) %>% select(Date))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$byRide <- renderPlotly({
      
      dt2 <- dt1 %>% dplyr::filter(Date>=as.Date(input$daterange2[1]), 
                                   Date<=as.Date(input$daterange2[2]),
                                   Ride==input$RideList2)
      dt2$Time <- as.factor(dt2$Time); dt2$Date <- as.factor(dt2$Date)
      plot_ly(dt2,x=~Time, y=~Wait, color=~Date, type="scatter", mode="lines") %>%
          layout(xaxis=list(title="Time of Day"), 
                 yaxis=list(title="Queue Time for Ride"),
                 title=paste0("Queue Times for ",input$RideList," Split by Day"))
      
  })
   
  output$byDay <- renderPlotly({
      
      dt2 <- dt1 %>% dplyr::filter(Date==as.Date(input$DayList3))
      dt2$Time <- as.factor(dt2$Time)
      plot_ly(dt2,x=~Time, y=~Wait, color=~Ride, type="scatter", mode="lines") %>%
          layout(xaxis=list(title="Time of Day"), 
                 yaxis=list(title="Queue Time for Ride"),
                 title=paste0("Queue Times on ",input$DayList3))
      
  })
  
  output$delays <- renderPlotly({
      
      plot_ly(dtDelays,x=~Ride, y=~Count, color=~Ride, type="bar") %>%
          layout(xaxis=list(title="Ride"), 
                 yaxis=list(title="Times Delayed"),
                 title="How many times do rides get delayed?")
      
  })
  
  output$predPlot <- renderPlotly({
      
      load("dt1.rds")
      dt2 <- dt1 %>% dplyr::filter(Date>=as.Date(input$daterange1[1]), 
                                   Date<=as.Date(input$daterange1[2]),
                                   Ride==input$RideList1)
      dt2$Time <- as.factor(dt2$Time)
      model1 <- train(Wait~Time2, data=dt2, method="rf", tuneLength=1)
      times <- unique(dt2 %>% dplyr::select(Time,Time2)) %>% arrange(Time)
      predict1 <- round(predict(model1,times),0)
      
      plot_ly(x=as.factor(times$Time), y=~predict1, type="scatter", mode="markers") %>%
          layout(xaxis=list(title="Time of Day"), 
                 yaxis=list(title="Queue Time for Ride"),
                 title=paste0("Prediction of Queue Times for ",input$RideList))
      
  })
  
})



