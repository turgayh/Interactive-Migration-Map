# load the required packages
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(htmltools)
library(hrbrthemes)
library(dygraphs)


# create the server functions for the dashboard  
shinyServer(function(input, output, session) {
  filteredData <- reactive({
    data[data$Year == input$Year & data$Month == input$Month,]
  })
  
  filteredStatisticsData <- reactive({
    data[data$Islands == input$statisticsDataIsland,]
  })
  
  
  filteredComparableStatisticsData <- reactive({
    data2[data2 == input$CStatisticsDataIsland,]
  })
  
  data_by_island <- data_mig %>%
    arrange(Islands)%>%
    group_by(Islands)
  
  #--------------------------------------------------------------------------------------------------
  #----------------------------    MAP  -------------------------------------------------------------
  #--------------------------------------------------------------------------------------------------
  
  max_lng = 19.336
  min_lng = 33.223
  max_lat = 42.952
  min_lat = 33.004
  
  output$map <- renderLeaflet({
    leaflet(data) %>% addTiles(group = "OSM (default)") %>%
      addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Esri.WorldImagery") %>%
      fitBounds(min_lng, min_lat, max_lng, max_lat)  %>%
      addLayersControl(position = "bottomright",
                       baseGroups = c("Esri.WorldImagery", "OSM (default)", "Toner"),
                       options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  
  
  #--------------------------------------------------------------------------------------------------
  #----------------------------    Makers by filter -------------------------------------------------
  #--------------------------------------------------------------------------------------------------
  labels <- function(islands,boatsArrived,totalArrivals,tranfersMainland,totalPopulation){sprintf(
    "<strong text-align=\"center\">%s</strong>
    <br/> <h5  class=\"section\"> Boats Arrived  :    <span class=\"number\">%s</span></h5>
     <h5  class=\"section\"> Total Arrivals  :    <span class=\"number\">%s</span></h5>
     <h5  class=\"section\"> Transfers to Greece Mainland  :    <span class=\"number\">%s</span></h5>
     <h5  class=\"section\"> Total Refugee Population  :    <span class=\"number\">%s</span></h5>

     ",
    islands,boatsArrived,totalArrivals,tranfersMainland,totalPopulation 

  ) %>% 
    lapply(htmltools::HTML)
  }
  
  observe({
    leafletProxy("map", data = filteredData()) %>%
      clearMarkerClusters() %>% 
      addMarkers(~Lng, ~Lat,
                 
                 label = ~labels(Islands,`Boats Arrived`,`Total Arrivals`,`Transfers to mainland`,`Total population`)
                   , 
                 labelOptions = labelOptions(style = list("font-weight" = "normal", 
                                                          padding = "3px 8px"),
                                             textsize = "15px",
                                             direction = "auto"),                 clusterOptions = markerClusterOptions()
      )
  })
  
  yazi <-function(str){
    tags$p(str, style = "font-size: 25;")
  }


  ################ [Start]  Statistics Tab ##############################################################
  
  
  output$BoatArrived <- renderDygraph({
    island <- filteredStatisticsData()
    tseries <- ts(island$`Boats Arrived`, start = c(2018,1), end = c(2020,0), frequency = 12)
    dygraph(tseries, main = "Boats Arrived ") %>%
      dySeries("V1", label = "Frequency") %>%
      dyOptions(fillGraph = TRUE, fillAlpha = 0.4) %>%
      dyHighlight(highlightCircleSize = 5)
  }
  )
  
  output$TotalArrivals <- renderDygraph({
    island <- filteredStatisticsData()
    tseries <- ts(island$`Total Arrivals`, start = c(2018,1), end = c(2020,0), frequency = 12)
    dygraph(tseries, main = "Total Arrivals ") %>%
      dySeries("V1", label = "Frequency") %>%
      dyOptions(fillGraph = TRUE, fillAlpha = 0.4) %>%
      dyHighlight(highlightCircleSize = 5)
  }
  )
  
  output$TransferToMainland <- renderDygraph({
    island <- filteredStatisticsData()
    tseries <- ts(island$`Transfers to mainland`, start = c(2018,1), end = c(2020,0), frequency = 12)
    dygraph(tseries, main = "Transfers to Greece Mainland") %>%
      dySeries("V1", label = "Frequency") %>%
      dyOptions(fillGraph = TRUE, fillAlpha = 0.4) %>%
      dyHighlight(highlightCircleSize = 5)
  }
  )
  
  output$TotalPopulation <- renderDygraph({
    island <- filteredStatisticsData()
    tseries <- ts(island$`Total population`, start = c(2018,1), end = c(2020,0), frequency = 12)
    dygraph(tseries, main = "Total Refugee Population") %>%
      dySeries("V1", label = "Frequency") %>%
      dyOptions(fillGraph = TRUE, fillAlpha = 0.4) %>%
      dyHighlight(highlightCircleSize = 5)
  }
  )
  
  ################ [Start] Comparable Statistics Tab ##############################################################
  
  #Total arrivals
  output$CBoatArrived <- renderDygraph({
    
    ts_boats <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Boats.Arrived, start = c(2018,1), end = c(2020,0), frequency = 12) )
  #Excluding "5"th element.  It is "Other island"
    data_boats <- cbind("Chios"=ts_boats[[1]],"Kos"=ts_boats[[2]], "Leros"=ts_boats[[3]], "Lesvos"=ts_boats[[4]],"Samos"=ts_boats[[6]])
    
    
    dygraph(data_boats, main = "Boats Arrived")%>%
      dyAxis("y", valueRange = c(0, 150)) 

  
    
  })
  #Transfer to mainland
  output$CTotalArrivals <- renderDygraph({
    
    ts_arrivals <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Total.Arrivals, start = c(2018,1), end = c(2020,0), frequency = 12) )
  #Excluding "5"th element.  It is "Other island"
    data_arrivals <- cbind("Chios"=ts_arrivals[[1]],"Kos"=ts_arrivals[[2]], "Leros"=ts_arrivals[[3]], "Lesvos"=ts_arrivals[[4]],"Samos"=ts_arrivals[[6]])
    
    dygraph(data_arrivals, main = "Total Arrivals")%>%
      dyAxis("y", valueRange = c(0, 6000))

    
  })
  #Transfers to mainland
  output$CTransferToMainland <- renderDygraph({
    
    ts_mainland <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Transfers.to.mainland, start = c(2018,1), end = c(2020,0), frequency = 12) )
  #Excluding "5"th element.  It is "Other island"
    data_mainland  <- cbind("Chios"=ts_mainland [[1]],"Kos"=ts_mainland [[2]], "Leros"=ts_mainland [[3]], "Lesvos"=ts_mainland [[4]],"Samos"=ts_mainland [[6]])
    
    dygraph(data_mainland, main = "Transfers to Greece Mainland")%>%
      dyAxis("y", valueRange = c(0, 5000)) 
  
  
  
  })
  #Total population
  output$CTotalPopulation <- renderDygraph({
    
    ts_population <- lapply(1:6, function(i) ts(group_split(data_by_island)[[i]]$Total.population, start = c(2018,1), end = c(2020,0), frequency = 12) )
  #Excluding "5"th element.  It is "Other island"
    data_population  <- cbind("Chios"=ts_population[[1]],"Kos"=ts_population[[2]], "Leros"=ts_population[[3]], "Lesvos"=ts_population[[4]],"Samos"=ts_population[[6]])
    
    dygraph(data_population, main = "Total Refugee Population ")%>%
      dyAxis("y", valueRange = c(0, 26000))
  })
}
)
