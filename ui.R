library(shiny)
library(leaflet)
# library(bslib)
library(shinythemes)

navbarPage("Antwerpen", id="main", collapsible = TRUE,
           # theme = bs_theme(version = 4, bootswatch = "lux"),
           theme = shinytheme("united"),
           navbarMenu("Menu",
                      tabPanel("Map", 
                               # tags$style(type = "text/css", "html, body {width:100%;height:100%}"), 
                               # tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                               leafletOutput('antwerp_map', height = 1000),
                               absolutePanel(id = "options_panel",
                                             class = "panel panel-default",
                                             fixed = TRUE,
                                             draggable = TRUE,
                                             top = 80, left = "auto", right = 20, bottom = "auto",
                                             width = 200, height = "auto",
                                             style="opacity: 0.7; z-index:400;",
                                             checkboxGroupInput("marker_type",
                                                                label = "Filter by:",
                                                                choices = c("Food and Drinks", "Bars", "Hotels", "Sights", "Museums and Galleries", "Shopping"),
                                                                selected = c("Food and Drinks", "Bars", "Hotels", "Sights", "Museums and Galleries", "Shopping"))
                               ),
                               # absolutePanel(id = "intro_panel",
                               #               draggable = TRUE,
                               #               top = 270, right = 20,
                               #               width = 200, 
                               #               # height = 300,
                               #               fixed = TRUE,
                               #               style="opacity: 0.8; z-index:400;",
                               #               class = "panel panel-default",
                               #               HTML('<button data-toggle="collapse" data-target="#info">Hide</button>'),
                               #               fluidRow(
                               #                 column(width = 12, align = "center", h4(strong("Our Favorite Spots"))),
                               #                 tags$div(id = 'info',  class="collapse",
                               #                          column(width = 12, align = "left",
                               #                                 tags$p(paste0('A curated map of some places we love in Antwerp and places on our still-need-to-visit list.')),
                               #                                 tags$p(paste0('Web app was created by Reggie and last updated on 09 August 2021.')),
                               #                                 tags$p('Click ',
                               #                                        tags$a(href='http://withjoy.com/regina-and-korneel',
                               #                                               target='_blank',
                               #                                               'here'),
                               #                                        paste0('to return to our website.')
                               #                                 )
                               #                          )
                               #                 )
                               #               )
                               # ),
                      ),
                      tabPanel("Info",
                               fluidRow(
                                 column(width = 12, align = "center", h3(strong("About"))),
                                 column(width = 12, align = "left",
                                        tags$p(paste0('A curated map of some places we love in Antwerp and places on our still-need-to-visit list.')),
                                        tags$p(paste0('Web app was created by Reggie')),
                                        tags$p('Click ',
                                               tags$a(href='http://withjoy.com/regina-and-korneel',
                                                      target='_blank',
                                                      'here'),
                                               paste0('to return to our website.')
                                        )
                                 )
                               )
                               
                      ),
                      tabPanel("Travel Tips", includeMarkdown("travel_info.Rmd"))
           )
           
)