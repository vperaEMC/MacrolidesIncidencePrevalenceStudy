library(here)
library(dplyr)
library(scales)
library(ggplot2)
library(stringr)

# empty object to store grpahs
graphs_inc_prev_years <- NULL

# gather duration levels
durations <- list(
  '<30 days' = 'less than 30 days',
  '30-179 days' = 'between 30 and 179 days',
  '≥180 days' = 'equal or more than 180 days'
)

# establish upper limit for years
year_min_max_data <- list()
year_min_max_input <- list('min' = NULL,'max' = NULL)

# make a nice loop
for(j in seq_along(durations)){
  for(k in seq_along(results_inc_prev)){
  
  # select data of interest
  inc_prev_years_focus <-
    results_inc_prev[[k]] %>%
    dplyr::filter(
      analysis_interval == 'years',
      denominator_age_group == 'All ages',
      denominator_sex == 'Both',
      duration == names(durations[j]))
  
  # establish upper limit for graph based on highest value +5%
  upper_limit_2 <- 
    inc_prev_years_focus %>%
    dplyr::select(upper_95CI) %>%
    dplyr::slice_max(order_by = upper_95CI) %>%
    dplyr::pull()*1.05
  
  for(i in seq_along(year_min_max_input)){
    year <-
      inc_prev_years_focus %>%
      dplyr::select(year) %>%
      {if(names(year_min_max_input[i]) == 'min')
        dplyr::slice_min(., order_by = year, with_ties = FALSE) else .} %>%
      {if(names(year_min_max_input[i]) == 'max')
        dplyr::slice_max(., order_by = year, with_ties = FALSE) else .} %>%
      dplyr::pull()
    
    year_min_max_data[i] <- year
    names(year_min_max_data)[i] <- names(year_min_max_input)[i]
  }
  
  
# plot the data, basic graph
  y1 <- ggplot2::ggplot(
    data = inc_prev_years_focus,
    aes(y = point_estimate,
        x = year,
        fill = outcome_cohort_name)
  )
  
 # add lines
  if(names(results_inc_prev)[k] == 'prevalence'){
    y2 <- 
      y1 + geom_line(aes(color=outcome_cohort_name)) + 
      ggplot2::labs(
        y = "Period prevalence",
        x = "Year",
        #title = paste0("Prevalence estimates with 95% confidence intervals of macrolide use in the the study populations through time, ", names(durations)[j],".")
        ) +  
      scale_color_discrete(name="Macrolides")
  } else if(names(results_inc_prev)[k] == 'incidence'){
    y2 <- 
      y1 + geom_line(aes(color=outcome_cohort_name)) + 
      ggplot2::labs(
        y = "Incidence per 100,000 Person Years",
        x = "Year",
        #title = paste0("Incidence estimates with 95% confidence intervals of macrolide use in the the study populations through time, ", names(durations)[j],".")
        ) +
      scale_color_discrete(name="Macrolides")
  }
  
  
  # order seperate lines in seperate graphs in a grid
  y3 <- y2 + ggplot2::facet_grid(
    cols = vars(cdm_name),
    rows = vars(denominator_target_cohort_name))
  
  name_sec_x_axis <- 'Databases'
  name_sec_y_axis <- 'Study cohorts'
  
# breaks expressed in years
year_breaks <- seq(year_min_max_data[["min"]],year_min_max_data[["max"]], by = 2)
  
  if(names(results_inc_prev)[k] == 'prevalence'){
    y4 <- y3 + ggplot2::scale_y_continuous(
      #breaks=seq(0,upper_limit_2,0.02), 
      limits=c(0,upper_limit_2),labels = scales::percent,
      sec.axis = sec_axis(~ . , name = name_sec_y_axis,
                          breaks = NULL, labels = NULL)) +
      scale_x_continuous(breaks = year_breaks,
                         sec.axis = sec_axis(~ . , name = name_sec_x_axis, breaks = NULL, labels = NULL)) + 
      theme(strip.text.y.right = element_text(angle = 0))
  } else if(names(results_inc_prev)[k] == 'incidence'){
    y4 <- y3 + ggplot2::scale_y_continuous(
      limits=c(0,upper_limit_2), labels = comma_format(big.mark = ",",
                                                       decimal.mark = "."), 
      sec.axis = sec_axis(~ . , name = name_sec_y_axis,
                          breaks = NULL, labels = NULL)) +
      scale_x_continuous(breaks = year_breaks,
                         sec.axis = sec_axis(~ . , name = name_sec_x_axis, breaks = NULL, labels = NULL)) + 
      theme(strip.text.y.right = element_text(angle = 0)) 
  }
  
  # add error ribon
  y5 <- y4 + geom_ribbon(
    aes(
      ymin = lower_95CI, 
      ymax = upper_95CI, 
      fill = factor(outcome_cohort_name)
    ), alpha=0.25, show.legend = FALSE
  )
  
  # font size adaption
  size <- 10
  y6 <- y5 + theme(text=element_text(size=size), #change font size of all text
          axis.text=element_text(size=size), #change font size of axis text
          axis.title=element_text(size=size), #change font size of axis titles
          plot.title=element_text(size=size), #change font size of plot title
          legend.text=element_text(size=size), #change font size of legend text
          legend.title=element_text(size=size),#change font size of legend title
          axis.title.y = element_text(margin = margin(r = 10)), #move title Y-axis away
          panel.spacing = grid::unit(5.5, "mm", data = NULL)
          ) 
  
  # put graph in list
  last_graph <- list(
    test_name = y6)
  
  # give new name for graph in list
  names(last_graph) <- paste0(names(results_inc_prev)[k], '_', durations[[j]])
  
  # merge lists so all graphs are together
  graphs_inc_prev_years<- c(graphs_inc_prev_years, last_graph)

  }
}

#export figures in loop style
for(g in seq_along(graphs_inc_prev_years)){

  ggplot2::ggsave(
    plot = graphs_inc_prev_years[[g]],
    filename = paste0('year_trend_',names(graphs_inc_prev_years)[g],'.png'),
    path = here("figures"),
    width = 4000,
    height = 2500,
    units = "px",
    dpi = 300
  )
  }
