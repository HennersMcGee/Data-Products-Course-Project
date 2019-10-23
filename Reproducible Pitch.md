Reproducible Pitch
========================================================
author: Henry
date: 2019/10/19
autosize: true
...5 Pages is not enough...   

*Please view in portrait to see full content.*


Thorpe Park - Theme Park
========================================================

The purpose of the shiny pack is to look at 
theme park waiting times, and build a model to 
predict the queue based on a chosen time frame 
and ride. The date has been collected every 5 
minutes during the theme parks opening hours. 
Delays were also collected.The different sections 
are explained below omn the next slide.  

The hope is that you could use this shiny pack while visisting Thorpe Park and have a more efficient visit. Or you could try your luck below:


```r
Rides <- c("Colossus","Derren Brown","SAW - The Ride","Stealth","Swarm")
paste0("Go on: ",sample(Rides,1))
```

```
[1] "Go on: Colossus"
```



Analysis
========================================================
**Data by Ride**
-  This section allows the user to look at the waiting times for a chosen ride, for many different days. The user can select the ride and date period to view.   

**Data by Day**
- This section allows the user to look at the waiting times for a chosen day, for many different rides. The user can select the day to view.

**Delays**
- This section shows the total number of delays for each ride. A count of one means there was a 5 minute interval where the ride was delayed.  

**Prediction**
- This section allows the user to build a model on the data. The user selects a ride, and date period and then fits a random forest using time of day. The prediction is then plotted showing how the queue for that ride varies by time.

Getting the Data
========================================================

To get the data for the shiny pack I had to webscrape this website below.  <https://queue-times.com/parks/2/queue_times>.  

If you're interested, the github link below contains all the code for how I went about this.
<https://github.com/HennersMcGee/01-Thorpe-Park>


Server Calculation - HTML Page
========================================================

The server performs 3 calculations for 3 different tabs. I have included the main one which fits a random forest for the tab titled "Prediction". It does not fit the page...


```r
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
```



