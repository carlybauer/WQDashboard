# Author: Carly Bauer 
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

#setwd("~/Documents/R/BVR/WQDashboard")
library(shiny)
library(bslib)  # For page_navbar and like everything else - what shiny r recomends for nice features
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
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
            layout_sidebar(
              sidebar = sidebar(
                h3("Check Your Understanding"),
                
                radioButtons("surface_water", "Surface water sources are important sources of drinking water.",
                             choices = c("True", "False"),
                             selected = character(0)),
                textOutput("surface_water_feedback"), #displays right/wrong
                
                radioButtons("wildfire_intensity", "Wildfire frequency and intensity has increased over the last decade.",
                             choices = c("True", "False"),
                             selected = character(0)),
                textOutput("wildfire_intensity_feedback"), #displays right/wrong
                
                
                radioButtons("wildfire_causes", "Which of the following likely increases the frequency and severity of a wildfire.",
                             choices = c("increasing temperatures", "droughts", "reduced snowpack", "less rainfall", "all of the above"),
                             selected = character(0)),
                textOutput("wildfire_causes_feedback"), #displays right/wrong
                
                
                radioButtons("wildfire_contaminants", "Burning the landscape surrounding a body of water will release potentially harmful amounts of ash, nutrients, and sediment into the water. ",
                             choices = c("True", "False"),
                             selected = character(0)),
                textOutput("wildfire_contaminants_feedback"), #displays right/wrong
                
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
                    
                    div(
                    # Text Section (8 columns)
                    h4("Water Sources and Wildfires"), 
                    p("Surface water is a vital source of drinking water. 
                    Natural and human activities can affect the quality of water sources that are eventually used for human consumption. 
          Recently, the western United States has experienced increasingly frequent and severe wildfires, which pose growing risks to water sources.
           
          While wildfires are a natural and necessary part of many landscapes, as they can reduce dead vegetation, stimulate new growth, and improve habitat, their increasing frequency and intensity have raised serious concerns.
          From 2003 to 2023, the number of extreme wildfire events more than doubled (Cunningham et al., 2024).
          Six of the most severe wildfires on record occurred within the last seven years (Cunningham et al., 2024), highlighting the urgent need to understand how wildfires affect water quality, especially in regions that depend on surface water for drinking supplies.")
                              ), # close first text div
                    
                    div(
                    # Image (4 columns)
                    tags$img(src = "BVR.png", 
                             style = "width: 100%; height: auto; margin-bottom: 10px;")
                    )# close first image div
                    ),
                  
                  layout_columns(
                    col_widths = c(8, 4),  
                    
                    div(
                    h4("Causes of Wildfires"),  
                    p("This increase in wildfire activity is closely tied to changes in climate. 
                      Rising temperatures, droughts, reduced snowpack, less consistent rainfall, and extreme weather events have all contributed to drier, more fire-prone conditions.")
                    ), # close second text div
                  ), #closes second layout_columns()

                  
                  layout_columns(
                    col_widths = c(8, 4),  
                    
                    div(
                    h4("Effects of Wildfires on Water Quality"),
                    p("Wildfires can impact drinking water sources during the fire, immediately afterward, and even for months or years following the event. 
                    Fires release ash, sediments, nutrients, metals, and other contaminants that can be transported into lakes, rivers, and reservoirs. 
                    After a wildfire, intense rainstorms often lead to mudslides and debris flows, which carry large amounts of ash and sediments into water bodies."),
                    p("Nutrient pollution is another major concern. 
                      Nutrients such as nitrogen and phosphorus are released from burned vegetation and soils, and when they enter aquatic systems, they can lead to excessive algal growth. 
                      These algal blooms decrease water quality and reduce oxygen levels as the algae die and decompose. 
                      Low oxygen levels can harm aquatic organisms, including fish. 
                      In addition, the loss of shade-providing vegetation can raise stream temperatures, which further contributes to oxygen depletion and makes water bodies more susceptible to algal blooms."),
                       tags$img(src = "RoLConcept.png",
                                style = "width: 100%; height: auto;")
                    ), # closes third text div
                    
                    div(
                    tags$img(src = "AlgalBloom.png", 
                             style = "width: 100%; height: auto; margin-bottom: 10px;"),
                     tags$img(src = "Debrisflow.png", 
                              style = "width: 100%; height: auto; margin-bottom: 10px;")
                    ), # closes third image div

                  )# closes third layout_columns()
                  

              )# closes layout_sidebar()
            )# Closes div
            )#closes div for scroll
  ),
  
  ### Conceptual Activity and Gauges
  nav_panel("Nutrients",
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
            layout_sidebar(
              width = 1,
              # Sidebar for selecting scenario and nutrient
              sidebar = sidebar(
                p("1. Observe the maximum nutrient measured for each scenario."),
                selectInput("scenario", "Choose a Scenario:",
                            choices = max_df$Scenario, selected = "baseline"),
              ),
              layout_column_wrap(
                width = 1/2, #change to 1/3 if showing DOC
                plotlyOutput("gaugePlot_Nitrate", width = "100%", height = "350px"),
                plotlyOutput("gaugePlot_Phosphorus", width = "100%", height = "350px")
                # plotlyOutput("gaugePlot_DOC", width = "100%", height = "300px")
              )
            ),
            layout_column_wrap(
              p("2. Find the percent change in nutrient input between different burn
                intensities using the formula: Percent Change = ((value 1 - value 2) / value 1) *100. 
                Download the excel file including the data used above and a percent change calculator. Then answer the questions below."),
                downloadButton("download_calculator", "Download percent change calculator and nutrient data"),

            ),
            # Div for side-by-side questions (gauge / percent change questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question nutrients1 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                tags$div(
                  "Question: What is the percent change in nitrate between the unburned and the 100% burned scenario?",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "nit_pchange",
                  label = NULL,
                  choices = c("160%", "121%", "116%", "201%"),
                  selected = character(0)
                ),
                textOutput("nit_pchange_feedback")
              ),
              # Question p_pchange 2 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                tags$div(
                  "Question: What is the percent change in phosphorus between the 25% burned and 100% burned scenario?",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "p_pchange",
                  label = NULL,
                  choices = c("10.8%", "33.0%", "24.9%", "50.4%"), 
                  selected = character(0)
                ),
                textOutput("p_pchange_feedback")
              )
            ),
            # Div for side-by-side questions (gauge / percent change questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question nutrients3 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                tags$div(
                  "Question: What is the percent change in nitrate between the 25% and the 50% burned scenario?",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "nit_pchange2",
                  label = NULL,
                  choices = c("20.8%", "52.0%", "115%", "41.9%"),
                  selected = character(0)
                ),
                textOutput("nit_pchange_feedback2")
              ),
              # Question p_pchange 4 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                tags$div(
                  "Question: What is the percent change in phosphorus between the 50% burned and 100% burned scenario?",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "p_pchange2",
                  label = NULL,
                  choices = c("51.5%", "20.1%", "20.8%", "13.0%"), 
                  selected = character(0)
                ),
                textOutput("p_pchange_feedback2")
              )
            ),# closes div for side-by-side
            
            
            # Div for side-by-side questions (gauge / percent change questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question nutrients5 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                tags$div(
                  "Question: Nitrate and phosphorus increase following a wildfire.",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "nutrients1",
                  label = NULL,
                  choices = c("True", "False"),
                  selected = character(0)
                ),
                textOutput("nutrients_feedback1")
              ),
              
              # Question nutrients6 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                tags$div(
                  "Question: Increasing nutrients (nitrate and phosphorus), increases total chlorophyll-a concentrations and thus the likelihood of algal blooms.",
                  style = "margin-bottom: 5px;"
                ),
                radioButtons(
                  "nutrients2",
                  label = NULL,
                  choices = c("True", "False"), 
                  selected = character(0)
                ),
                textOutput("nutrients_feedback2")
              )
            )# closes div for side-by-side
            ) #closes div for scrollable page   
  ),
  
 
  ### Data activity 1
  nav_panel("Water Temperature",  
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
            # Download Water Temp plot
            layout_sidebar(
              sidebar = sidebar(
                style = "height:100%;overflow-y: scroll;",
                p(tags$b("Practice your plotting skills:"), 
                "Download excel file of a time series of water temperature for a year comparing the water temperatures of an unburned watershed to a watershed that experienced the most intense burn.
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
                  "Question: Would you expect an unburned watershed to have higher water temperatures than a watershed that experienced a high intensity burn?",
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp",
                  label = NULL,
                  choices = c("Yes", "No"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback")
              ),
              
              # Question temp 2 box
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Pale green box
                tags$div(
                  "Question: Find the date November 12th, 2020 (2020-11-12) by hovering over the points on the graph. 
                  What is the water temperature for both scenarios on that date?",                
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp2",
                  label = NULL,
                  choices = c("Unburned = 18.8   Fire 100 = 17.0", "Unburned = 14.7   Fire 100 = 17.7",
                              "Unburned = 14.5   Fire 100 = 17.5", "Unburned = 17.7   Fire 100 = 14.7"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback2")
              )
            ),
            # Div for side-by-side questions (temp questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question temp 3
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Moccasin color box
                tags$div(
                  "Question: Find the date August 14th, 2020 (2020-08-14) by hovering over the points on the graph. 
                  What is the water temperature for both scenarios on that date?",
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp3",
                  label = NULL,
                  choices = c("Unburned = 27.7 Fire 100 = 28.4", "Unburned = 27.8  Fire100 = 29.1", 
                              "Unburned = 28.4  Fire100 = 27.7", "Unburned =  27.9  Fire100 =  29.2"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback3")
              ),
              
              # Question temp 4
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Pale green box
                tags$div(
                  "Question: When do you see the greatest difference between water temperature between the two scenarios?",                
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp4",
                  label = NULL,
                  choices = c("April", "July", "September", "December"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback4")
              )
            ),
            
            # Div for side-by-side questions (temp questions)
            div(
              style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
              # Question temp 5 
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Moccasin color box
                tags$div(
                  "Question: Warmer water temperature could cause algal blooms which deplete oxygen and may kill fish.",
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp5",
                  label = NULL,
                  choices = c("True", "False"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback5")
              ),
              
              # Question temp 6
              div(
                style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Pale green box
                tags$div(
                  "Question: Water temperature is the highest during what time of year?",                
                  style = "width: 100%; margin-bottom: 5px;"
                ),
                radioButtons(
                  "water_temp6",
                  label = NULL,
                  choices = c("Summer", "Winter"),
                  selected = character(0)
                ),
                textOutput("water_temp_feedback6")
              )
            )
            )# closes div for scroll
  ),
  
  ### Data activity 2
  nav_panel("Total Chlorophyll-a",
            ## T-chla Download and plot
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
              layout_sidebar(
                sidebar = sidebar(
                  style = "height:100%;overflow-y: scroll;",
                  p(tags$b("Practice your plotting skills:"),
                  "Total chlorophyll a concentrations can be used as an indicator for algal blooms. Download excel file of a time series of total chlorophyll a concentrations for a year in an unburned watershed and a 100% burned watershed.
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
                    "Question: Did the high intensity burn increase, decrease, or not change total chlorophyll-a concentrations compared to no-burn conditions.",
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
              ),
              # Div for side-by-side questions (chla questions)
              div(
                style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
                # Question chla 3 box
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                  tags$div(
                    "Question: Find the date September 29th, 2020 (2020-09-29) by hovering over the points on the graph. What is the total 
                  chlorophyll-a concentration rounding to one decimal place for the unburned and 100% burned (Fire100) scenario on that day?",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "chla_bloom3",
                    label = NULL,
                    choices = c("Unburned = 23.2 mg/L, Fire100 = 33.0 mg/L", "Unburned = 18.3 mg/L, Fire100 = 35.2 mg/L", "Unburned = 23.9 mg/L , Fire100 = 34.7 mg/L", "Unburned = 16.2 mg/L, Fire100 = 20.8 mg/L"),
                    selected = character(0)
                  ),
                  textOutput("chla_bloom_feedback3")
                ),
                
                # Question chla 4 box
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                  tags$div(
                    "Question: What caused total chlorophyll-a concentrations to change based on what you learned in the background information?",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "chla_bloom4",
                    label = NULL,
                    choices = c("increase in dead fish", "increase in nutrients", "decrease in nutrients", "increase in rain"),
                    selected = character(0)
                  ),
                  textOutput("chla_bloom_feedback4")
                )
              ),
              # Div for side-by-side questions (chla questions)
              div(
                style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
                # Question chla 5 box
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                  tags$div(
                    "Question: Find the max chlorophyll-a concentration for the 100% burned (Fire100) scenario.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "chla_bloom5",
                    label = NULL,
                    choices = c("34.7 mg/L", "32.4 mg/L", "37.2 mg/L", "35.2 mg/L"),
                    selected = character(0)
                  ),
                  textOutput("chla_bloom_feedback5")
                ),
                
                # Question chla 6 box
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                  tags$div(
                    "Question: Warmer water temperatures increase total chlorophyll-a concentrations.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "chla_bloom6",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("chla_bloom_feedback6")
                )
              )
            )#close first div that allows scroll page
  ),
 
  # Key Takeaways
  nav_panel("Key Takeways",
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              tags$br(), #adds a line break
              h3("What have you learned about wildfires and water quality from these activities?"),
              
              tags$br(), #adds a line break
              # Div for side-by-side questions (takeaways)
              div(
                style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
                # Question takeaway1
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                  tags$div(
                    "T/F: It is important to study wildfires and how they affect water quality.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway1",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback1")
                ),
                # Question takeaway2
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                  tags$div(
                    "T/F: Wildfires can pose a threat to water quality by introducing nutrients, ash and other contaminants to water supplies.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway2",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback2")
                )
                ),
                
                # Div for side-by-side questions (takeaways)
                div(
                  style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
                # Question takeaway3
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                  tags$div(
                    "T/F: Wildfires decrease nutrients and algal blooms.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway3",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback3")
                ),
                # Question takeaway4
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                  tags$div(
                    "T/F: Algal blooms are bad for water quality because they deplete the oxygen in the water.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway4",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback4")
                )
              ),
              
              # Div for side-by-side questions (takeaways)
              div(
                style = "display: flex; gap: 20px; flex-wrap: wrap;",  # Flexbox layout with some space between the boxes
                # Question takeaway5
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light yellow box
                  tags$div(
                    "T/F: Models can be used to simulate water quality conditions to forecast what could happen if there are wildfires in the region.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway5",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback5")
                ),
                # Question takeaway6
                div(
                  style = "flex: 1 1 45%; padding: 10px; background-color: #f0f8ff; border: 1px solid #ccc;",  # Light blue box
                  tags$div(
                    "T/F: Scientific research, water quality monitoring and careful management of drinking water sources are important for protecting human and ecosystem health.",
                    style = "margin-bottom: 5px;"
                  ),
                  radioButtons(
                    "takeaway6",
                    label = NULL,
                    choices = c("True", "False"),
                    selected = character(0)
                  ),
                  textOutput("takeaway_feedback6")
                )
              )
            )# close div scroll
  ), # close nav_panel
                
  
  
  # Vocabulary words
  nav_panel("Vocabulary",
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
            layout_column_wrap(
              width = 1, 

              # tags$br(), #adds a line break
              p(
                tags$b("algal bloom:"), #tags$b bolds the text
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
                tags$b("debris flow:"), 
                " A type of landslide made up of a mixture of water-saturated rock debris and soil with a consistency similar to wet cement. 
                Debris flows move rapidly downslope under the influence of gravity. Sometimes referred to as earth flows or mud flows."
              ),
              p(
                tags$b("nitrate (NO3):"), 
                " A compound containing nitrogen that can exist in the atmosphere or as a dissolved gas in water which can have harmful effects on humans and animals.
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
                tags$b("turbidity:"), 
                " A measure of the cloudy condition in water due to suspended solids or organic matter."
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
            ) #closes div for scroll
  ),
  
  
  ### Resources Page
  nav_panel("Resources",
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
            ### YouTube videos
            layout_column_wrap(
              width = 1,
              div(
              p(tags$b("Youtube Videos:")),
              p("https://youtube.com/playlist?list=PLr5bB3qcMRzS7TXGbmTYTkNRSTLtFNUrZ&feature=shared "),
              p("https://www.youtube.com/watch?v=rrhz_kcYU2g&list=PLr5bB3qcMRzS7TXGbmTYTkNRSTLtFNUrZ&index=3"),
              p("https://www.youtube.com/watch?v=Y9yEERskots&list=PLr5bB3qcMRzS7TXGbmTYTkNRSTLtFNUrZ&index=4"),
              )# close div
            ),
            
            ### Websites
            layout_column_wrap(
              width = 1,
              div(
              p(tags$b("Websites:")),
              p("Wildland Fires Could be Putting Your Health at Risk: 
                https://www.nps.gov/articles/000/wildland-fires-could-be-putting-your-drinking-water-at-risk.htm#:~:text=Burned%20areas%20release%20carbon%20compounds,miles%20away%20from%20the%20fires."),
              p("Water Quality After a Wildfire: 
                https://www.usgs.gov/centers/california-water-science-center/science/water-quality-after-wildfire"),
              p("Wildfires and Water:
                https://ca.water.usgs.gov/wildfires/"),
              p("Benefits of Wildfire:
                https://www.nps.gov/subjects/fire/upload/benefits-of-fire.pdf"),
              )#close div
            ),
            
            ### Citations
            layout_column_wrap(
              width = 1,
              div(
              p(tags$b("References:")),
              p("Caldwell PV, Elliott KJ, Liu N, Vose JM, Zietlow DR, Knoepp JD. Watershed-scale vegetation, water quantity, and water quality responses to wildfire in the southern Appalachian mountain region, United States. Hydrological Processes. 2020; 34: 5188–5209. https://doi.org/10.1002/hyp.13922"),
              p("Cunningham, C.X., Williamson, G.J. & Bowman, D.M.J.S. Increasing frequency and intensity of the most extreme wildfires on Earth. Nat Ecol Evol 8, 1420–1425 (2024). https://doi.org/10.1038/s41559-024-02452-2"),
              p("De Palma‐Dow, A., McCullough, I. M., & Brentrup, J. A. (2022). Turning up the heat: Long‐term water quality responses to wildfires and climate change in a hypereutrophic lake. Ecosphere, 13(12), e4271."),
              p("Murphy, S. F., Alpers, C. N., Anderson, C. W., Banta, J. R., Blake, J. M., Carpenter, K. D., ... & Ebel, B. A. (2023). A call for strategic water-quality monitoring to advance assessment and prediction of wildfire
impacts on water supplies. Frontiers in Water, 5, 1144225."),
              p("Olson, N. E., Boaggio, K. L., Rice, R. B., Foley, K. M., & LeDuc, S. D. (2023). Wildfires in the western United States are mobilizing PM 2.5-associated nutrients and may be contributing to downwind cyanobacteria
blooms. Environmental Science: Processes & Impacts, 25(6), 1049-1066."),
              p("Wandersee, M., Zimmerman, D., Kachurak, K., Angelo Gumapas, L., DeVault Wendt, K., & Kesteloot, K. (2023, July). Wildland fires could be putting your drinking water at risk (U.S. National Park Service). 
                National Parks Service. https://www.nps.gov/articles/000/wildland-fires-could-be-putting-your-drinking-water-at-risk.htm#:~:text=Burned%20areas%20release%20carbon%20compounds,miles%20away%20from%20the%20fires. ")
              )# close div
            ) # closes div scroll
            )),
  
  # How the dashboard was set up         
  nav_panel("Dashboard Setup",
            div(style = "overflow-x: hidden; overflow-y: auto;",
            layout_column_wrap(
              width =1, 
              div(
              p(
              "We used a hydrologic model (GLM-AED) to simulate inflows of water into a drinking water reservoir in southwestern Virginia. 
              The reservoir has not experienced a wildfire."),
              p("We found scientific studies on reservoirs that had experienced wildfires. The studies measured concentrations of nutrients (N, P) before and after the wildfires."),
              p("We then input the different concentrations of N and P from the literature into our model that simulated different scenarios of various burn intensities (unburned, 25%, 50%, and 100% burned) to generate N and P input data for the dashboard."),
              p(
              "The data used in this dashboard was generated using a General Lake Model (GLM) coupled with an Aquatic EcoDynamics library (AED) of a secondary drinking water reservoir in Virginia.
              GLM is a water balance and one-dimensional vertical stratification hydrodynamic model and AED is a water quality modeling library. The dashboard was created using the Shiny package in R."),
                tags$img(src = "DashboardWorkflow.png", 
                         style = "width: 60%; height: auto; margin-top:0;")
              )# close div
              ),
            
            div(
            layout_column_wrap(
              width =1, 
              p("Created by: Dr. Madeline Schreiber and Carly Bauer")
            )
            )# closes created by div
            )# closes div scroll
            ),

  # Page for teacher use
  nav_panel("Teachers",
            div(
              style = "height: 90vh; overflow-y: auto; padding-right: 1rem;", #allows scrollable page
              
            layout_column_wrap(
              width =1, 
              div(
              h3("Lesson Summary: How can wildfires impact water quality in drinking water reservoirs in southwest Virginia?"),
              
              tags$ul(
                tags$li("Review background material"),
                tags$li("Work with water quality data to investigate how wildfire impacts water quality in drinking water reservoirs"),
                tags$li("Plot time series data of water quality variables in drinking water reservoirs affected by wildfire and answer questions about the trends")
              )# close div
                ),
              
              
              layout_column_wrap(
                width =1, 
                div(
              h3("Student Learning Objectives", style = "margin-bottom: 0px;"), 
                p("After completing this lesson, students will be able to: ", style = "margin-bottom: 0px;"),
              tags$ul(
                style = "margin-top: 0px; margin-bottom: 0px",
                tags$li("Describe the impact of wildfire burning on water quality"),
                tags$li("Compare the impacts of wildfire burning on water quality using a dashboard containing model simulation data"),
                tags$li("Plot and explore time series data to investigate how wildfire in a watershed impacts water temperature")
              )
                )# close div
                ),
              
              layout_column_wrap(
                width =1, 
                div(
              h3("Lesson Plan Activities"),
               tags$ul(
                 tags$li("Students review wildfire impacts on water quality via backgorund readings built into the dashboard and answer 'Check my Understanding' questions"),
                 tags$li("Students explore a conceptual activiting using the dashbard to examine nutrient input to a reservoir from a watershed with different fire scenarios (unburned, 25%, 50%, or 100% burned), plot those data using a spreading/graphing progam, calculate percent change using excel template, and answer questions"),
                 tags$li("Students download time series data")
               )
                )# close div
                 ),
              

            )
            )
  )# closes div for scroll
  

  
)
