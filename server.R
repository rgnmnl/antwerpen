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
# library(jsonlite)
# library(lubridate)
# library(viridis)
library(scales)
library(ggplot2)
library(forcats)
library(tidyr)
library(ggrepel)
library(sf)


shinyServer(function(input, output) {
  # Import Data and clean it
  load('antwerp_places.RData')
  
  tf_api_key <- Sys.getenv('TF_API_KEY')
  
  antwerp <- antwerp %>% 
    mutate(color = case_when(type == "Bars" ~ "orange",
                             type == "Food and Drinks" ~ "lightred",
                             type == "Hotels" ~ "blue",
                             type == "Museums and Galleries" ~ "green",
                             type == "Shopping" ~ "pink",
                             type == "Sights" ~ "purple",
                             type == "Venue" ~ "red"),
           icon = case_when(type == "Bars" ~ "beer",
                            type == "Food and Drinks" ~ "cutlery",
                            type == "Hotels" ~ "bed",
                            type == "Museums and Galleries" ~ "paint-brush",
                            type == "Shopping" ~ "shopping-bag",
                            type == "Sights" ~ "binoculars",
                            type == "Venue" ~ "star")) 
  # %>%
    # mutate(., color = ifelse(Name == "Felix Pakhuis", "red", color),
    #        icon = ifelse(Name == "Felix Pakhuis", "star", icon))

  
    # create the leaflet map  
  output$antwerp_map <- renderLeaflet({
    
    if(length(input$marker_type) == 0){
      antwerp <- antwerp[antwerp$type == "Venue", ]
    } else {
      antwerp <- antwerp[antwerp$type %in% c(input$marker_type, "Venue"), ]
    }
    
    my_icons <- awesomeIcons(icon = antwerp$icon,
                             # iconColor = "white",
                             markerColor = antwerp$color,
                             library = "fa")
    
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
        # onClick=JS("function(btn, map) { map.setView(new L.LatLng(51.206787,4.3993921)); }")))
        onClick=JS("function(btn, map) { map.setView(new L.LatLng(51.2279206,4.4077035)); }")))
  })

})