---
title: 'Wildfire effects on water quality'
tags:
  - R shiny
  - GLM-AED 
  - wildfire
  - water quality
  - algal blooms
authors:
  - name: Carly E. Bauer
    orcid: 0009-0006-5955-8932
    affiliation: 1
  - name: Mary E. Lofton
    orcid: 0000-0003-3270-1330
    affiliation: 1
  - name: Heather L. Wander
    orcid: 0000-0002-3762-6045
    affiliation: 2
  - name: Madeline E. Schreiber
    orcid: 0000-0002-1858-7730
    affiliation: 2
affiliations: 
  - name: Department of Geosciences, Virginia Tech, Blacksburg, Virginia, USA 
    index: 1
  - name: Department of Biological Sciences, Virginia Tech, Blacksburg, Virginia, USA
date: 3 June 2025
bibliography: paper.bib

---

# Summary 
This computational learning module developed in R Shiny introduces participants to the effects that wildfires can pose on surface drinking water quality. 
The module provides hands-on materials for analyzing and interpreting water quality data pre- and post-wildfires of various intensities based on watershed area (unburned, 25%, 50%, 100%). 
The water quality data were simulated using the GLM-AED (General Lake Model – Aquatic Eco-Dynamics) coupled hydrodynamic and water quality model calibrated for a drinking water reservoir in southwestern Virginia. 
The watershed of this reservoir has not yet experienced a wildfire. We used data from scientific reviews [@Paul2022] and studies of burned watersheds in the southern Appalachians [@Caldwell2020] and western United States [@Beyene2022] to generate input concentrations of nutrients and temperature for the model simulations. 
We then embedded the simulation results into the module. Through data-driven activities, participants calculate the percent change of nutrients and plot time series of surface water temperature and chlorophyll-a concentrations for different burn scenarios. 
Following each data-driven activity, participants interpret their findings by answering multiple choice questions with immediate feedback and explanations of incorrect and correct answers. 
This learning module is aimed to broaden the understanding of the effects of wildfires on surface water quality through data visualization and interpretation and can be used in a variety of teaching and learning venues. 

The computational learning module has been made publicly available at:  
<a href="https://macrosystemseddie.shinyapps.io/water-quality-wildfires/">Computational Learning Module: Wildfire Effects on Water Quality</a> © 2025 by  
<a href="https://creativecommons.org">Carly E. Bauer, Mary E. Lofton, Heather L. Wander, Madeline E. Schreiber</a> is licensed under  
<a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a>
<img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg" alt="CC" style="max-width: 1em; max-height:1em; margin-left: .2em;">
<img src="https://mirrors.creativecommons.org/presskit/icons/by.svg" alt="BY" style="max-width: 1em; max-height:1em; margin-left: .2em;">

# Statement of need
Surface water sources are vital for meeting human drinking water needs. Human activities and climatic events affect the quality of drinking water. 
Wildfires are climatic events, often human-induced, that have increased in severity and intensity over the last decade [@Cunningham2024]. 
Although wildfires are a necessary part of forest ecosystems, as they can reduce dead vegetation and stimulate new growth, they may also negatively affect the quality of drinking water [@Bowman2009]. 
While resources to educate K-12 students on water quality exist, there are no known interactive activities that target the effects of wildfires on drinking water quality. 
In response to this gap, we designed this learning module using R Shiny for students interested in learning about water quality and the effects of wildfires through data-driven activities. 

# Development
We simulated physical, chemical, and biological water quality variables in Beaverdam Reservoir (BVR) in southwestern Virginia using the General Lake Model (GLM) paired with Aquatic Eco-Dynamics (AED) modules (GLM-AED v3.3.1; @Hipsey2022; @Hipsey2019). 
For more information on the BVR model calibration, see @Wander2025.

The GLM-AED model was first run for unburned conditions, as the watershed has not experienced a burn since the reservoir was created in the 1920s. 
Subsequently, the model was run for different burn scenarios that correspond to the percentage of the catchment that is burned (unburned, 25%, 50%, 100%) using data from a study conducted in the southeastern U.S. which measured nutrients (nitrate and phosphorus) pre- and post-wildfire of various intensities [@Caldwell2020]. 
We calculated percent differences between the unburned (pre-wildfire) nutrients measured and the burned, post-wildfire nutrients of the different burn scenarios reported in [@Caldwell2020]. 
We then multiplied the percent differences by the nutrient concentrations in the unburned inflow file (i.e., the daily nutrient concentrations that enter the reservoir and serve as driver data for the model) to represent changes in nutrients that would be expected with different burn intensities. 
We also used empirical findings from the literature to manipulate temperature [@Beyene2022] and total chlorophyll-a concentrations [@Paul2022] for the maximum burn intensity (100% burn scenario) to observe changes in surface water temperature and algal blooms. 
We did these manipulations separately from the others because they were from different studies and we were only observing the highest burn scenario. The variables and numbers used to simulate the different burn scenarios are described in Table 1.  

| **Burn Scenario** | **Manipulation to inflow variable**        | **Reference**            |
|-------------------|--------------------------------------------|--------------------------|
| **25%**           | Nitrate * 1.625                            | Caldwell et al., 2020    |
|                   | Phosphorus * 1.125                         |                          |
| **50%**           | Nitrate * 2.25                             | Caldwell et al., 2020    |
|                   | Phosphorus * 1.25                          |                          |
| **100%**          | Nitrate * 3.5                              | Caldwell et al., 2020    |
|                   | Phosphorus * 1.5                           |                          |
|                   | Nitrate * 7                                | Paul et al., 2022        |
|                   | Phosphorus * 9                             |                          |
|                   | Water temperature + 4 degrees C            | Beyene et al., 2022      |


# Audience
The audience for this dashboard includes individuals who: 1) want to learn about the effects of wildfires on water quality; 
2) want a hands-on way to predict how water quality variables are affected by different wildfire burn intensities; and/or  
3) are involved in K-12 Earth Science or Environmental Science education and want a ready-to-use module that includes background information, activities, and resources. 

# Features

## Learning objectives
The overarching objectives of the module are to:  
1. Describe the impact of wildfire burning on water quality 
2. Examine impacts of wildfire burning on nutrient inputs in a drinking water reservoir in southwestern Virginia using a percent change calculator 
3. Plot and explore time series data from a simulated hydrologic model to investigate how nutrient inputs can increase algal growth. 

## Instructional design 
The module is designed using R Shiny [@Bauer2025] and is available through an open-source link. 
The module includes an introductory presentation for instructors, background information for students to review and refer to while completing activities and answering questions, 
three data-driven activities with questions, downloadable directions (PDF format) on how to plot time series data in Microsoft Excel, downloadable data and percent change calculator, 
multiple choice questions that provide immediate feedback on student answer choices and explanations of correct and incorrect answers, a list of vocabulary terms used throughout the module, 
a brief description of how the module was created and how the data were simulated, additional videos, articles, 
and scientific papers for more information on the topics, and learning objectives and outcomes of the module for teachers. 
This module allows for both in-person and virtual participation and can be completed synchronously in an instructor-led class or asynchronously as a self-paced module. 

The module is designed as a 45-60 minute, standalone activity that includes an introductory presentation (~10 minutes), background reading and questions (~5 minutes), 
percent change activity and questions (~10 minutes), water temperature time series plotting and questions (~10 minutes), total chlorophyll-a time series plotting and questions (~10 minutes), 
and key takeaway questions (~5 minutes). If more time is available, the module includes additional content including scientific readings and YouTube videos that further explore the topic.  

# Experience in teaching and learning situations
We received valuable input on the module from colleagues, students at Virginia Tech, and Ms. Sarah Ulrich-Burnett, a science teacher at Cave Spring High School (Roanoke Co., Virginia). 
We piloted the module with students in an Earth Science class at Cave Spring High School in May 2025 and made updates and revisions to the module based on student feedback. 

# Acknowledgements 
This dashboard was supported by the National Science Foundation through grant EF-2318861.  We thank our research group and the many participants who piloted the module for their interest, 
enthusiasm, and feedback that helped improve the module.  

# References