library(readxl)
data_mig <- read.csv("./data/2018-2019_data.csv", header=T)[,1:7]
data <- read_excel("./data/2018-2019_migdata.xlsx")
data2 <- read_excel("./data/2018-2019_data.xlsx")
ISLANDS <- c("Kos","Chios","Leros","Samos","Lesvos","Other")

################ [Start]  Statistics Tab ##############################################################

statistics <- 
  function(){
  fluidRow(
    radioGroupButtons(inputId = "statisticsDataIsland",choices = ISLANDS ,size = "s",status = "primary",justified = TRUE),
    
    
    box(
      status = 'success',
      dygraphOutput("BoatArrived",height = "300px" ),
    ),
    
    box(
      status = 'success',
      dygraphOutput("TotalArrivals" ,height = "300px"),
    ),
    
    box(
      status = 'success',
      dygraphOutput("TransferToMainland" ,height = "300px"),
    ),
    
    box(
      status = 'success',
      dygraphOutput("TotalPopulation" ,height = "300px"),
    )
  )
  
  }


################ [Start] Comparable Statistics Tab ##############################################################

statisticsComparable <- function(){
  fluidRow(
    
    box(
      status = 'success',
      dygraphOutput("CBoatArrived",height = "300px" ),
    ),
    
    box(
      status = 'success',
      dygraphOutput("CTotalArrivals" ,height = "300px"),
    ),
    
    box(
      status = 'success',
      dygraphOutput("CTransferToMainland" ,height = "300px"),
    ),
    
    box(
      status = 'success',
      dygraphOutput("CTotalPopulation" ,height = "300px"),
    )
  )
}


urlFacebook <- "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Ftaylanbt.shinyapps.io%2Finteractive_turkey_map_-_migration%2F"
urlTwitter <- "https://twitter.com/intent/tweet?url=https%3A%2F%2Ftaylanbt.shinyapps.io%2Finteractive_turkey_map_-_migration%2F"
urlGithub <- "https://github.com/turgayh/R-Shiny"