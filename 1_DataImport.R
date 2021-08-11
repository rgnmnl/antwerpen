library(shiny)
library(shinyjs)
library(dplyr)
library(jsonlite)
library(leaflet)
library(lubridate)
library(viridis)
library(scales)
library(ggplot2)
library(forcats)
library(tidyr)
library(ggrepel)
library(sf)
library(shinydashboard)
library(data.table)

map_file <- 'data/Antwerp.kml'
kml_layers <- st_layers(map_file)

details <- fread("data/antwerp_details.txt", sep = "\t", header = TRUE)

category_list <- NULL
for(i in 1:length(kml_layers$name)){
  foo <- read_sf(map_file, layer = kml_layers$name[i]) %>% mutate(., type = kml_layers$name[i]) %>%
    mutate(long = st_coordinates(.)[,1], lat = st_coordinates(.)[,2])
  category_list[[i]] <- foo
}

antwerp <- Reduce('rbind', category_list) %>%
  mutate(., type = ifelse(Name == "Felix Pakhuis", "Venue", type)) %>%
  select(., -Description) %>%
  left_join(., details, by = c("Name", "type"))
  
save(antwerp, file = "antwerp_places.RData")


