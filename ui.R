#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

setwd("~/Documents/R/BVR/WQDashboard")
library(shiny)
library(bslib)  # For page_navbar
library(plotly)
library(dplyr)
library(shiny)
library(readr)
library(writexl)

max_df <- read_csv("Scenarios_Max.csv")


# # Define UI for application
ui <- page_navbar(
  title = "Water Quality and Wildfires",
  theme = bs_theme(bootswatch = "flatly"),
  
  nav_panel("Background",
            layout_sidebar(
              sidebar = sidebar(
                h3("Check Your Understanding"),
                
                radioButtons("surface_water", "Surface water sources are important sources of drinking water?",
                             choices = c("True", "False"),
                             selected = character(0)),
                textOutput("surface_water_feedback"), #displays right/wrong
                
                radioButtons("wildfire_effect", "Which of the following is a possible effect of increased nutrients in water sources?",
                             choices = c("Decreased algae growth", "Decreased nitrate", "Increased algae growth", "Lower water temperature"),
                             selected = character(0)),
                textOutput("wildfire_effect_feedback"), # display right/wrong
                
                radioButtons("ash_effect", "Burned watersheds may result in an increase of ____ in water sources.",
                             choices = c("ash", "nutrients", "sediments", "all of the above"),
                             selected = character(0)),
                textOutput("ash_effect_feedback") # display right/wrong
              ),
              # Add wrapper div to control layout overflow
              div(style = "overflow-x: hidden; overflow-y: auto;",
                  layout_columns(
                    col_widths = c(8, 4), 
                    
                    # Text Section (8 columns)
                    p("Surface water is a vital source of drinking water. 
                    Natural and human activities can affect the water quality of these sources that are then distributed for human consumption. 
          Recently, the western United States has experienced intense wildfires. Burning the landscape surrounding a body of water can negatively impact its quality. 
          Wildfires are a natural and necessary part of many landscapes in the western United States, the frequency and intensity of these fires create risks for drinking water quality.
          The frequency of extreme wildfire events has more than doubled from 2003 - 2023 (Cunningham et al., 2024).
          Within the last 7 years, 6 of the most extreme wildfires have occurred, exemplifying the importance of understanding how they affect water quality (Cunningham et al., 2024).
          However, wildfires are a natural and necessary part of many landscapes in the western United States, the frequency and intensity of these fires create risks for drinking water quality."),
                    
                    # Image (4 columns)
                    tags$img(src = "BVR.png", 
                             style = "width: 80%; height: auto; margin-bottom: 10px;")
                  ),
                  
                  layout_columns(
                    col_widths = c(8, 4),  
                    
                    p("Causes of wildfires can be attributed to the changing climate, including increasing temperatures, drought, reduced snowpack, less rainfall, and extreme flood events."),
                    
                    tags$img(src = "SEKI-mudslide_corr_2000.webp", 
                             style = "width: 80%; height: auto; margin-bottom: 10px;")
                  ), #closes second layout_columns()
                  
                  layout_columns(
                    col_widths = c(8, 4),  
                    
                    p("Fires can negatively affect drinking water sources durring, immediately after the fire or for months to years afterwards. Wildfires may lead to dangerous algal blooms which severely affect water quality."),
                    
                    tags$img(src = "AlgalBloomE.webp", 
                             style = "width: 80%; height: auto; margin-bottom: 10px;")
                  ),# closes third layout_columns()
                  
                  layout_columns(
                    col_widths = c(2,10),
                    
                    p("Conceptual figure"),
                    tags$img(src = "RoLConcept.png", 
                             style = "width: 50%; height: auto;")
                  )# closes 4th layout_columns()
              )# closes layout_sidebar()
            )# Closes div
  ),
  
  ### Conceptual Activity and Gauges
  nav_panel("Conceptual Activity",
            layout_sidebar(
              width = 1,
              # Sidebar for selecting scenario and nutrient
              sidebar = sidebar(
                p("1. Start with the unburned scenario which represents a normal watershed.  
                Record the maximum value for each nutrient and each scenario."),
                selectInput("scenario", "Choose a Scenario:",
                            choices = max_df$Scenario, selected = "baseline"),
              ),
              layout_column_wrap(
                width = 1/3,
                plotlyOutput("gaugePlot_Nitrate", width = "100%", height = "300px"),
                plotlyOutput("gaugePlot_Phosphorus", width = "100%", height = "300px"),
                # plotlyOutput("gaugePlot_DOC", width = "100%", height = "300px")
              )
            ),
            layout_column_wrap(
              p("2. Find the percent change in nutrient input between different burn
                intensities using the formula: Percent Change = ((value 1 - value 2) / value 1) *100. 
                Download the excel file including the data used above and a percent change calculator."),
                downloadButton("download_calculator", "Download percent change calculator and nutrient data"),

            )
  ),
  
  ### Data activity 1
  nav_panel("Total Chlorophyll-a",
            ## T-chla Download and plot
            layout_sidebar(
              height = "15000px",
              sidebar = sidebar(
                style = "height:100%;overflow-y: scroll;",
                p("1. Total chlorophyll a concentrations can be used as an indicator for algal blooms. Download excel file of a time series of total chlorophyll a concentrations for a year.
                  Plot time on the x axis and concentrations on the y axis. An example of what this may look like is to the right."),
                downloadButton("download_chla", "Download chlorophyll data")
              ),
              layout_column_wrap(
                width = 1,
                plotlyOutput("TChla_timeseries")
              )
            ),
            
            # Div for side-by-side questions (chla questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question chla 1 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                tags$div(
                  "Question: Based on your total chlorophyll-a plot, what time of year would we expect an algal bloom to occur?",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "chla_bloom",
                  label = NULL,
                  choices = c("Spring to Summer", "Summer to Fall"),
                  selected = character(0)
                ),
                textOutput("chla_bloom_feedback")
              ),
              
              # Question chla 2 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                tags$div(
                  "Question: Did the high intensity burn increase, decrease, or not change total chlorophyll-a concentrations compared to no-burn baseline conditions.",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "chla_bloom2",
                  label = NULL,
                  choices = c("increase", "decrease", "no change"),
                  selected = character(0)
                ),
                textOutput("chla_bloom_feedback2")
              )
            )
  ),
  
 
  ### Data activity 2
  nav_panel("Water Temperature",  
            # Download Water Temp plot
            layout_sidebar(
              height = "15000px",
              sidebar = sidebar(
                style = "height:100%;overflow-y: scroll;",
                p("1. Download excel file of a time series of water tempurate for a year comparing baseline water temperatures and water temperatures from the most intense fire.
                  Plot time on the x axis and temperatures on the y axis. An example of what this may look like is to the right."),
                downloadButton("download_temp", "Download temperature data"),
                downloadButton("download_directions", "Download plotting directions")
              ),
              layout_column_wrap(
                width = 1,
                plotlyOutput("temp_timeseries")
              )
            ),
            
            # Div for side-by-side questions (temp questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question temp 1 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Moccasin color box
                tags$div(
                  "Question: Would you expect a lower intensity wildfire to cause water temperatures to increase or decrease in comparison to the highest burn intensity water temperature?",
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp",
                  label = NULL,
                  choices = c("Increase", "Decrease"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback")
              ),
              
              # Question temp 2 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Pale green box
                tags$div(
                  "Question: What is the water temperature for both scenarios on July 20, 2020?",                
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp2",
                  label = NULL,
                  choices = c("Baseline = 28.8   Fire 100 = 29.0", "Baseline = 25.8   Fire 100 = 32.1",
                              "Baseline = 28.2   Fire 100 = 28.9", "Baseline = 26.0   Fire 100 = 29.8"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback2")
              )
            )
  ),
 
  # Vocabulary words
  nav_panel("Vocabulary",
            layout_column_wrap(
              width = 1, 
              h2("List of vocabulary words used in the background."),
              p(
                tags$b("algal bloom:"), 
                " An episode of excessive nutrient content in a river, stream, or lake, which causes a proliferation of living algae. 
        The end result is a depletion of much needed oxygen in the water.
        Excessive algae blooms can lead to the death of the fish and aquatic organisms of the given waterbody through oxygen deprivation called a 'fish kill'."
              ),
              p(
                tags$b("ash:"), 
                "The mineral content of a product remaining after complete combustion."
              ),
              p(
                tags$b("chlorophyll a:"), 
                " A green pigment found in photosynthetic organisms; used as an indicator of algal biomass."
              ),
              p(
                tags$b("nitrate (NO3):"), 
                " A compound containing nitrogen that can exist in the atmosphere or as a dissolved gas in water and which can have harmful effects on humans and animals.
        Nitrates in water can cause severe illness in infants and domestic animals. A plant nutrient and inorganic fertilizer, nitrate is found in septic systems, animal feed lots, agricultural fertilizers, manure, industrial waste waters, sanitary landfills, and garbage dumps."
              ),
              p(
                tags$b("nutrients:"), 
                "Substances such as nitrogen and phosphorus compounds necessary for growth and survival. Elevated levels can cause unwanted growth of algae, and can result in the lowering of the amount of oxygen in the water when the algae die and decay."
              ),
              p(
                tags$b("phosphorus:"), 
                " An essential chemical food element that can contribute to the eutrophication of lakes and other water bodies. Contributes to poor water quality. Elevated phosphorus levels cause more algae to grow, blocking out sunlight and reducing oxygen for fish."
              ),
              p(
                tags$b("reservoir:"), 
                "Any natural or artificial holding area used to store, regulate, or control water."
              ),
              p(
                tags$b("sediment:"), 
                " Soil, particles, sand, and other mineral matter eroded from land and carried in surface waters."
              ),
              p(
                tags$b("watershed:"), 
                " The land area from which water drains into a stream, river, or reservoir."
              ),
              p(
                tags$b("wildfire:"), 
                " An unplanned, unwanted fire burning in a natural area."
              ),
              p(
                tags$b("source:"), 
                " https://sor.epa.gov/sor_internet/registry/termreg/searchandretrieve/termsandacronyms/search.do"
              )
            )
  ),
  
  
  ### References Page
  nav_panel("References",
            layout_column_wrap(
              width = 1,
              h3("References"),
              p("Caldwell PV, Elliott KJ, Liu N, Vose JM, Zietlow DR, Knoepp JD. Watershed-scale vegetation, water quantity, and water quality responses to wildfire in the southern Appalachian mountain region, United States. Hydrological Processes. 2020; 34: 5188–5209. https://doi.org/10.1002/hyp.13922"),
              p("Cunningham, C.X., Williamson, G.J. & Bowman, D.M.J.S. Increasing frequency and intensity of the most extreme wildfires on Earth. Nat Ecol Evol 8, 1420–1425 (2024). https://doi.org/10.1038/s41559-024-02452-2")
            )),
  
  # How the dashboard was set up         
  nav_panel("Dashboard Setup",
            layout_column_wrap(
              width =1, 
              p("The dashboard was designed using a general lake model (GLM) of a secondary drinking water reservoir in Virginia. 
                A literature review of how nutrients (nitrate, phosphorus, dissolved organic carbon) are affected in a reservoir following different burn intensities was used to manipulate the model.")
            )),

  # Page for teacher use
  nav_panel("Teachers",
            layout_column_wrap(
              width =1, 
              h2("Lesson Summary: How can wildfires impact water quality in drinking water reservoirs in southwest Virginia?"),
              tags$ul(
                tags$li("Review background material"),
                tags$li("Work with water quality data to investigate how wildfire impacts water quality in drinking water reservoirs"),
                tags$li("Plot time series data of water quality variables in drinking water reservoirs affected by wildfire and answer questions about the trends")
              ),
              h2("Student Learning Objectives", style = "margin-bottom: 0px;"), 
                p("After completing this lesson, students will be able to: ", style = "margin-bottom: 0px;"),
              tags$ul(
                style = "margin-top: 0px; margin-bottom: 0px",
                tags$li("Describe the impact of wildfire burning on water quality"),
                tags$li("Compare the impacts of wildfire burning on water quality using a dashboard containing model simulation data"),
                tags$li("Plot and explore time series data to investigate how wildfire in a watershed impacts water temperature")
              ),
              h2("Lesson Plan Activities"),
               tags$ul(
                 tags$li("Students review wildfire impacts on water quality via backgorund readings built into the dashboard and answer 'Check my Understanding' questions"),
                 tags$li("Students explore a conceptual activiting using the dashbard to examine nutrient input to a reservoir from a watershed with different fire scenarios (none, 25%, 50%, or 100% burned), plot those data using a spreading/graphing progam, calculate percent change using excel template, and answer questions"),
                 tags$li("Students download time series data")
               )

            ))
  

  
)
