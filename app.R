#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(DT)
library(highcharter)
library(shinycssloaders)
library(shinyWidgets)
library(shinyBS)
library(dplyr)
library(jsonlite)
library(lubridate)
library(viridis)
library(scales)
library(ggplot2)
library(forcats)
library(tidyr)
library(ggrepel)
library(sf)

load('antwerp_places.RData')

tf_api_key <- Sys.getenv('TF_API_KEY')

antwerp <- antwerp %>% 
    mutate(color = case_when(type == "Bars" ~ "orange",
                             type == "Food and Drinks" ~ "lightred",
                             type == "Hotels" ~ "blue",
                             type == "Museums and Galleries" ~ "green",
                             type == "Shopping" ~ "pink",
                             type == "Sights" ~ "purple"),
           icon = case_when(type == "Bars" ~ "beer",
                             type == "Food and Drinks" ~ "cutlery",
                             type == "Hotels" ~ "bed",
                             type == "Museums and Galleries" ~ "paint-brush",
                             type == "Shopping" ~ "shopping-bag",
                             type == "Sights" ~ "binoculars")) %>%
    mutate(., color = ifelse(Name == "Felix Pakhuis", "red", color),
           icon = ifelse(Name == "Felix Pakhuis", "star", icon))

my_icons <- awesomeIcons(icon = antwerp$icon,
                         # iconColor = "white",
                         markerColor = antwerp$color,
                         library = "fa")

# Define UI for application
ui <-  bootstrapPage(
    tags$head(
        tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
        tags$style('#intro_panel {position: fixed}'),
        tags$style("#travel_panel {overflow-y: auto; overflow-x: hidden;}")
    ),
    
    leafletOutput('antwerp_map', width = "100%", height = "100%"),
    
    absolutePanel(id = "intro_panel",
                  top = 20, right = 20,
                  width = 220,
                  style="opacity: 0.8; z-index:400;",
                  class = "panel panel-default",
                  fluidRow(
                      column(width = 12, align = "center", h4(strong("Our Favorite Spots"))),
                      column(width = 12, align = "left", 
                             tags$p(paste0('A curated map of some places we love in Antwerp and places on our still-need-to-visit list.')), 
                             tags$p(paste0('Web app was created by Reggie and last updated on 09 August 2021.')),
                             tags$p('Click ',
                                     tags$a(href='http://withjoy.com/regina-and-korneel',
                                                              target='_blank',
                                                              'here'),
                                     paste0('to return to our website.')
                                     )
                             
                             )
                  )
            
    ),    
    
    absolutePanel(id = "travel_panel",
                  top = 240, right = 20,
                  width = 220, height = 300,
                  style="opacity: 0.8; z-index:400;",
                  class = "panel panel-default",
                  fluidRow(
                      column(width = 12, align = "center", h4(strong("Travel Tips and Information"))),
                      column(width = 12, align = "left",
                             tags$p('As of 09 August 2021, travel to Belgium from the United States is allowed.'),
                             tags$p('The US is currently listed as a red zone due to the rising cases of the Delta variant, therefore you will need a negative PCR test and a completed', 
                                    tags$a(href='https://travel.info-coronavirus.be/public-health-passenger-locator-form', 
                                           target='_blank',
                                           'Passenger Health Locator Form'),
                                     'to enter the country.'),
                             tags$p('An EU Digital COVID Certificate is currently not necessary to enter Belgium for US residents but it is highly recommended to bring your CDC vaccination card on your trip. 
                                    The majority of EU member states accept the CDC vaccination card as proof of your vaccination status.'),
                             tags$p('Click ',
                                    tags$a(href='https://unitedstates.diplomatie.belgium.be/en/coronavirus-covid-19',
                                           target='_blank',
                                           'here'),
                                    paste0('for up-to-date travel requirements for US citizens.')
                                    ),
                             tags$p('Click ',
                                    tags$a(href='https://www.info-coronavirus.be/en/',
                                           target='_blank',
                                           'here'),
                                    paste0('for up-to-date travel information and requirements for Belgium.')
                                    ),
                             tags$p('Click ',
                                    tags$a(href='https://reopen.europa.eu/en',
                                           target='_blank',
                                           'here'),
                                    paste0('for up-to-date travel requirements for all other EU countries.')
                                    )
                             )
                      )
                        
    ),
    
    absolutePanel(top = 560, right = 20,
                  # top = 160, right = 10,
                  width = 220,
                  style="opacity: 0.8; z-index:400;",
                  class = "panel panel-default",
                  draggable = FALSE, 
                  checkboxGroupInput("marker_type",
                                     label = "Filter by:",
                                     choices = unique(antwerp$type),
                                     selected = unique(antwerp$type))
                  # selectInput("marker_type", 
                  #             label = "Filter by:",
                  #             choices = antwerp$type,
                  #             multiple = TRUE,
                  #             selectize = TRUE,
                  #             selected = unique(antwerp$type))
                  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # })
    
    output$antwerp_map <- renderLeaflet({
        
        antwerp <- antwerp[antwerp$type %in% input$marker_type, ]

        leaflet(data = antwerp) %>% 
            # addProviderTiles(providers$Stamen.TonerLite) %>%
            addTiles(
                urlTemplate = "https://{s}.tile.thunderforest.com/{variant}/{z}/{x}/{y}.png?apikey={apikey}",
                attribution = "&copy; <a href='http://www.thunderforest.com/'>Thunderforest</a>,  &copy; <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>",
                options = tileOptions(variant='atlas', apikey = tf_api_key)
            ) %>%
            # addMarkers(~long, ~lat, popup = ~as.character(Name), label = ~as.character(type)) %>%
            addAwesomeMarkers(~long, ~lat, 
                              popup = paste0(antwerp$Name, 
                                             "<br>", 
                                             # "<a href='https://www.google.com/maps/place/", antwerp$Name, "/@", antwerp$lat, ",", antwerp$long, ",15z' target='_blank'>", 
                                             antwerp$Address,
                                             "<br><br>",
                                             antwerp$Description,
                                             "<br>"
                                             # "</a>"
                                             ), 
                              icon=my_icons, 
                              label=~as.character(Name)) %>%
            addEasyButton(easyButton(
                icon="glyphicon-refresh", title="Reset Map",
                onClick=JS("function(btn, map) { map.setView(new L.LatLng(51.206787,4.3993921)); }")))
        # %>%
            # addLegend("topright", 
            #           colors = c("red","orange","blue","purple","green","pink"),
            #           labels= c("Food and Drinks","Bars","Hotels","Sights","Museums and Galleries","Shopping"),
            #           title= "Categories",
            #           opacity = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
