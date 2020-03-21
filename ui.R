library(shiny)
library(leaflet)
require(shinydashboard)
library(shinyWidgets)
library(dygraphs)

source("global.R")
# header board
header <- dashboardHeader(
  
  title = "Migration Map",
  dropdownMenu(
               notificationItem(
                 text = " Share on Facebook",
                 icon = icon("facebook"),
                 href = urlFacebook
                 
               ),
               notificationItem(
                 text = " Share on Twitter",
                 icon = icon("twitter"),
                 href = urlTwitter
               ),
               notificationItem(
                 text = " View on Github",
                 icon = icon("github"),
                 href = urlGithub
               )
  )
  )
# Side bar boardy
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = 'menu_tabs'
    , menuItem('Migration Map', tabName = 'MigrationMap')
    , menuItem('Statistics', tabName = 'Statistics')
    , menuItem('Comparative Statistics' , tabName = "ComparableStatistics")

  ) # Combine text with url variable
  
  
  
)
# Body board
body <- dashboardBody(
  tags$head(includeCSS("www/style.css")), 
  
  
  tabItems(
    tabItem(
      tags$style(type = "text/css", "#map {height: calc(100vh - 30px) !important;}"),
      tags$head(tags$style(
        HTML(
          ".content { padding-top: 0;padding-right:0;padding-left:0;margin-bottom:0;}"
        )
      )),
      
      ### Navbar text start ####################################################################################
      tags$head(tags$style(
        HTML(
          ".myClass {font-size: 20px;font-weight:bold;line-height: 50px;text-align: left;font-family: \"Helvetica Neue\",Helvetica,Arial,sans-serif;padding: 0 12px;overflow: hidden;color: black;}"
        )
      )),
      tags$script(
        HTML(
          '
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Monitoring Refugee Crisis in the Aegean Sea </span>\');
      })
     '
        )
      ),
      
      ### Navbar text ended ####################################################################################
      
      
      tags$style(HTML(".content-wrapper{margin-bottom:0px;}")),
      
      tabName = 'MigrationMap'
      ,
      leafletOutput('map')
      ,
      verbatimTextOutput('summary')
      ,
      absolutePanel(
        id = "controls",
        
        fixed = TRUE,
        draggable = TRUE,
        class = "panel",
        top = "auto",
        left = "14%",
        right = "auto",
        bottom = "8%",
        width = "80%",
        height = 20,
        
        
        radioGroupButtons(
          inputId = "Month",
          choices = c(
            "January",
            "February",
            "March" ,
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
          ) ,
          status = "success"
        ),
        radioGroupButtons(
          inputId = "Year",
          choices = c("2019", "2018") ,
          status = "success"
        ),
        
      ),
    ),
    
    
    tabItem(tabName = 'Statistics'
            ,
            statistics()),
    tabItem(tabName = 'ComparableStatistics'
            ,
            statisticsComparable())
  )
)

shinyUI(
  dashboardPage(
    skin = "black",
    title = 'Monitoring Refugee Crisis in the Aegean Sea',
    header,
    sidebar,
    body
  )
)
