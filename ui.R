library(shiny)
library(leaflet)

navbarPage("Antwerpen", id="main", collapsible = TRUE,
           navbarMenu("Menu",
                      tabPanel("Our Favorite Spots", 
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
                               absolutePanel(id = "intro_panel",
                                             draggable = TRUE,
                                             top = 270, right = 20,
                                             width = 200, 
                                             # height = 300,
                                             fixed = TRUE,
                                             style="opacity: 0.8; z-index:400;",
                                             class = "panel panel-default",
                                             HTML('<button data-toggle="collapse" data-target="#info">Hide</button>'),
                                             fluidRow(
                                               column(width = 12, align = "center", h4(strong("Our Favorite Spots"))),
                                               tags$div(id = 'info',  class="collapse",
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
                                             )
                               ),
                      ),
                      # tabPanel("Data", DT::dataTableOutput("data")),
                      tabPanel("Travel Tips",
                               fluidRow(
                                 column(width = 12, align = "center", h3(strong("Travel Tips and Information"))),
                                 column(width = 12, align = "left",
                                        tags$p('As of 09 August 2021, travel to Belgium from the United States is allowed.'),
                                        tags$p('The US is currently listed as a red zone due to the rising cases of the Delta variant, 
                                    therefore you will need a negative PCR test and a completed',
                                               tags$a(href='https://travel.info-coronavirus.be/public-health-passenger-locator-form',
                                                      target='_blank',
                                                      'Passenger Health Locator Form'),
                                               'to enter the country.'),
                                        tags$p('An EU Digital COVID Certificate is currently not necessary to enter Belgium for US residents 
                                    but it is highly recommended to bring your CDC vaccination card on your trip.
                                           The majority of EU member states accept the CDC vaccination card as proof of your vaccination status.'),
                                        br(),
                                        tags$h4('Useful Links:'),
                                        tags$a(href='https://unitedstates.diplomatie.belgium.be/en/coronavirus-covid-19',
                                               target='_blank',
                                               'Belgium Travel Guidance for US nationals'),
                                        br(),
                                        tags$a(href='https://www.info-coronavirus.be/en/',
                                               target='_blank',
                                               'Belgian Coronavirus Information'),
                                        br(),
                                        tags$a(href='https://reopen.europa.eu/en',
                                               target='_blank',
                                               'European Travel Guidance')
                                 )
                               )
                      )
                      # tabPanel("Info",
                      #          fluidRow(
                      #            column(width = 12, align = "center", h5(strong("About"))),
                      #            column(width = 12, align = "left",
                      #                   tags$p(paste0('A curated map of some places we love in Antwerp and places on our still-need-to-visit list.')),
                      #                   tags$p(paste0('Web app was created by Reggie and last updated on 09 August 2021.')),
                      #                   tags$p('Click ',
                      #                          tags$a(href='http://withjoy.com/regina-and-korneel',
                      #                                 target='_blank',
                      #                                 'here'),
                      #                          paste0('to return to our website.')
                      #                   )
                      #            )
                      #          )
                      #          
                      # )
           )
           
)