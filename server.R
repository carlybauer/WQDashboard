# Author: Carly Bauer
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

#setwd("~/Documents/R/BVR/WQDashboard")
library(shiny)
library(bslib)  # For page_navbar
library(plotly)
library(dplyr)
library(shiny)
library(readr)
library(writexl)
max_df <- read_csv("Scenarios_Max.csv")
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  
  # Feedback for Surface water question
  output$surface_water_feedback <- renderText({
    req(input$surface_water)  # Ensure user has selected an answer
    if (input$surface_water == "True") {
      "✅ Correct! People rely on surface water sources for clean drinking water!"
    } else {
      "❌ Incorrect. The correct answer is 'True'."
    }
  })
  
  # Feedback for Wildfire Intensity question
  output$wildfire_intensity_feedback <- renderText({
    req(input$wildfire_intensity)  # Ensure user has selected an answer
    if (input$wildfire_intensity == "True") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for Wildfire Intensity question
  output$wildfire_causes_feedback <- renderText({
    req(input$wildfire_causes)  # Ensure user has selected an answer
    if (input$wildfire_causes == "all of the above") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for Wildfire Intensity question
  output$wildfire_contaminants_feedback <- renderText({
    req(input$wildfire_contaminants)  # Ensure user has selected an answer
    if (input$wildfire_contaminants == "True") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for Wildfire Effect question
  output$wildfire_effect_feedback <- renderText({
    req(input$wildfire_effect)  # Ensure user has selected an answer
    if (input$wildfire_effect == "Increased algae growth") {
      "✅ Correct! Wildfires can increase nutrients, leading to more algal blooms."
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for Ash Effect question
  output$ash_effect_feedback <- renderText({
    req(input$ash_effect)  # Ensure user has selected an answer
    if (input$ash_effect == "all of the above") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Reactive: Filter the selected scenario and nutrient
  selected_data <- reactive({
    data <- filter(max_df, Scenario == input$scenario)
    # nutrient_column <- paste(input$nutrient, "Max", sep = "_", "mgL")
    # data$value <- data[[nutrient_column]]
    return(data)
  })
  
  # Function to create a gauge
  create_gauge <- function(value, title, max_value) {
    plot_ly(
      type = "indicator",
      mode = "gauge+number",
      value = value,
      title = list(text = title),
      gauge = list(
        axis = list(range = c(0, max_value)),
        bar = list(color = "brown")
      )
    )
  }
  
  # Render the selected gauge (Nitrate, Phosphorus, or DOC) based on user input
  output$gaugePlot_Nitrate <- renderPlotly({
    req(selected_data())  # Ensure data is available
    create_gauge(selected_data()$Nitrate_Max_mgL, "Nitrate Max (mg/L)", max(max_df$Nitrate_Max_mgL))
  })
  
  output$gaugePlot_Phosphorus <- renderPlotly({
    req(selected_data())  # Ensure data is available
    create_gauge(selected_data()$Phosphorus_Max_mgL, "Phosphorus Max (mg/L)", max(max_df$Phosphorus_Max_mgL))
  })
  
  output$download_calculator <- downloadHandler(
    filename = function() {
      "percent_change_calculator.xlsx"
    },
    content = function(file) {
      file.copy("percent_change_calculator.xlsx", file)
    })
  
  # Feedback for nit percent change question 1
  output$nit_pchange_feedback <- renderText({
    req(input$nit_pchange)  # Ensure user has selected an answer
    if (input$nit_pchange == "160%") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for p percent change question 1
  output$p_pchange_feedback <- renderText({
    req(input$p_pchange)  # Ensure user has selected an answer
    if (input$p_pchange == "33.0%") {####CHANGE THIS
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for nit percent change question 2
  output$nit_pchange_feedback2 <- renderText({
    req(input$nit_pchange2)  # Ensure user has selected an answer
    if (input$nit_pchange2 == "41.9%") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for p percent change question 2
  output$p_pchange_feedback2 <- renderText({
    req(input$p_pchange2)  # Ensure user has selected an answer
    if (input$p_pchange2 == "20.1%") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for nutrients question 5
  output$nutrients_feedback1 <- renderText({
    req(input$nutrients1)  # Ensure user has selected an answer
    if (input$nutrients1 == "True") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for nutrients question 6
  output$nutrients_feedback2 <- renderText({
    req(input$nutrients2)  # Ensure user has selected an answer
    if (input$nutrients2 == "True") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # output$gaugePlot_DOC <- renderPlotly({
  #   req(selected_data())  # Ensure data is available
  #   create_gauge(selected_data()$DOC_Max_mgL, "DOC Max (mg/L)", max(max_df$DOC_Max_mgL))
  # })  
  

  
  temp_data <- read_csv("TimeSeries_Temp.csv")
  output$download_temp <- downloadHandler(
    filename = function() {
      paste("temp_data", ".xlsx", sep = "")
    },
    content = function(file){
      write_xlsx(temp_data, file)
    }
  )
  
  output$download_directions <- downloadHandler(
    filename = function() {
      "HowToPlotTimeSeries.pdf"
    },
    content = function(file) {
      file.copy("HowToPlotTimeSeries.pdf", file)
    }
  )
  
  output$temp_timeseries <- renderPlotly({
    t <- ggplot(temp_data)+
      theme_bw()+
      theme(panel.grid = element_blank()) +  # Remove gridlines
      geom_line(aes(Date, Unburned_temp_C, color = "Unburned"))+
      geom_line(aes(Date, Fire100_temp_C, color = "Fire100"))+
      scale_color_manual(values = c("Unburned" = "black", "Fire100" = "red")) +  # Custom colors
      labs(x= 'Date',
           y = 'Water temperature (C)',
           color = 'Scenario')
    
    ggplotly(t)
  })
  
  # Feedback for Water temp question
  output$water_temp_feedback <- renderText({
    req(input$water_temp)  # Ensure user has selected an answer
    if (input$water_temp == "Yes") {
      "✅ Correct! We would expect an unburned watershed to have lower surface water temperatures compared to a watershed that experienced a wildfire based on our plot."
    } else {
      "❌ Incorrect. We would expect an unburned watershed to have lower surface water temperatures compared to a watershed that experienced a wildfire based on our plot."
    }
  })
  
  # Feedback for Water temp question
  output$water_temp_feedback2 <- renderText({
    req(input$water_temp2)  # Ensure user has selected an answer
    if (input$water_temp2 == "Unburned = 14.7   Fire 100 = 17.7") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again."
    }
  })
  
  # Feedback for Water temp question
  output$water_temp_feedback3 <- renderText({
    req(input$water_temp3)  # Ensure user has selected an answer
    if (input$water_temp3 == "Unburned = 27.7 Fire 100 = 28.4") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again."
    }
  })
  
  # Feedback for Water temp question
  output$water_temp_feedback4 <- renderText({
    req(input$water_temp4)  # Ensure user has selected an answer
    if (input$water_temp4 == "December") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again."
    }
  })
  
  
  # Feedback for Water temp question
  output$water_temp_feedback5 <- renderText({
    req(input$water_temp5)  # Ensure user has selected an answer
    if (input$water_temp5 == "True") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again."
    }
  })
  
  # Feedback for Water temp question
  output$water_temp_feedback6 <- renderText({
    req(input$water_temp6)  # Ensure user has selected an answer
    if (input$water_temp6 == "Summer") {
      "✅ Correct! The air temperature is warmer which warms the water temperature." 
    } else {
      "❌ Incorrect. Try again."
    }
  })
  
  chlorophyll_data <- read_csv("TimeSeries_TotalChla.csv") #download data as csv
  output$download_chla <- downloadHandler(
    filename = function() {
      paste("chlorophyll_data", ".xlsx", sep = "")
    },
    content = function(file) {
      write_xlsx(chlorophyll_data, file)  # Save as Excel file
    }
  )
  
  output$TChla_timeseries <- renderPlotly({
    c <- ggplot(chlorophyll_data) +
      theme_bw() +
      theme(panel.grid = element_blank()) +  # Remove gridlines
      geom_point(aes(Date, Unburned_Chlorophylla_mgL, color = "Unburned"), size = 0.5) +
      geom_point(aes(Date, Fire100_Chlorophylla_mgL, color = "Fire100"), size = 0.5)+
      scale_color_manual(values = c("Unburned" = "black", "Fire100" = "green")) +  # Custom colors
      labs (x = 'Date',
            y = 'Total chlorophyll a concentrations (mg/L)',
            color = 'Scenario')
    
    ggplotly(c)
  })
  
  # Feedback for chla bloom question 1
  output$chla_bloom_feedback <- renderText({
    req(input$chla_bloom)  # Ensure user has selected an answer
    if (input$chla_bloom == "Summer to Fall") {
      "✅ Correct! Total chlorophyll-a concentrations begin increasing in late summer, and peak in the fall suggesting an algal bloom is likely."
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for chla bloom question 2
  output$chla_bloom_feedback2 <- renderText({
    req(input$chla_bloom2)  # Ensure user has selected an answer
    if (input$chla_bloom2 == "increase") {
      "✅ Correct! High burn intensities release more nutrients into water sources, causing an increase in total chlorophyll-a concentrations."
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for chla bloom question 3
  output$chla_bloom_feedback3 <- renderText({
    req(input$chla_bloom3)  # Ensure user has selected an answer
    if (input$chla_bloom3 == "Unburned = 23.9 mg/L , Fire100 = 34.7 mg/L") {
      "✅ Correct!"
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for chla bloom question 4
  output$chla_bloom_feedback4 <- renderText({
    req(input$chla_bloom4)  # Ensure user has selected an answer
    if (input$chla_bloom4 == "increase in nutrients") {
      "✅ Correct! The high intensity burn caused nutrients like nitrate and phosphorus to increase which cause total chlorophyll-a concentrations to increase."
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for chla bloom question 5
  output$chla_bloom_feedback5 <- renderText({
    req(input$chla_bloom5)  # Ensure user has selected an answer
    if (input$chla_bloom5 == "35.2 mg/L") {
      "✅ Correct! "
    } else {
      "❌ Incorrect. Try again"
    }
  })
  
  # Feedback for chla bloom question 6
  output$chla_bloom_feedback6 <- renderText({
    req(input$chla_bloom6)  # Ensure user has selected an answer
    if (input$chla_bloom6 == "True") {
      "✅ Correct! Algae likes warmer water, so higher water temperatures increase total chlorophyll-a concentrations and thus algal blooms."
    } else {
      "❌ Incorrect. Try again"
    }
  })
  

# Feedback for key takeaway question 1
output$takeaway_feedback1 <- renderText({
  req(input$takeaway1)  # Ensure user has selected an answer
  if (input$takeaway1 == "True") {
    "✅ Correct! It's important to study how changing environments affect our vital sources of water."
  } else {
    "❌ Incorrect. Try again"
  }
})

# Feedback for key takeaway question 2
output$takeaway_feedback2 <- renderText({
  req(input$takeaway2)  # Ensure user has selected an answer
  if (input$takeaway2 == "True") {
    "✅ Correct!"
  } else {
    "❌ Incorrect. Try again"
  }
})

# Feedback for key takeaway question 3
output$takeaway_feedback3 <- renderText({
  req(input$takeaway3)  # Ensure user has selected an answer
  if (input$takeaway3 == "False") {
    "✅ Correct! Wildfires increase nutrients (nitrate and phosphorus) and thus algal blooms."
  } else {
    "❌ Incorrect. Try again"
  }
})

# Feedback for key takeaway question 4
output$takeaway_feedback4 <- renderText({
  req(input$takeaway4)  # Ensure user has selected an answer
  if (input$takeaway4 == "True") {
    "✅ Correct! Algae deplete the oxygen within the water which causes fish to die because they can't breathe without oxygen."
  } else {
    "❌ Incorrect. Try again"
  }
})

# Feedback for key takeaway question 5
output$takeaway_feedback5 <- renderText({
  req(input$takeaway5)  # Ensure user has selected an answer
  if (input$takeaway5 == "True") {
    "✅ Correct! Click on the Dashboard Setup tab to learn more!"
  } else {
    "❌ Incorrect. Try again"
  }
})

# Feedback for key takeaway question 6
output$takeaway_feedback6 <- renderText({
  req(input$takeaway6)  # Ensure user has selected an answer
  if (input$takeaway6 == "True") {
    "✅ Correct!"
  } else {
    "❌ Incorrect. Try again"
  }
})


}

# # Run the application 
# shinyApp(ui = ui, server = server)

