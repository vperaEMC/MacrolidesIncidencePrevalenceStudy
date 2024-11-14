library(here)
library(dplyr)
library(scales)
library(ggplot2)
library(stringr)

################################################################################
################################################################################
################ PREVALENCES TREND THROUGH YEARS ###############################
################################################################################
################################################################################

# check existing folder
if (!dir.exists(here::here("figures_v2"))) 
{dir.create(here::here("figures_v2"))}

graphs_prevalence_years <- NULL

# gather duration levels
durations <- list(
  '<30 days' = 'less than 30 days',
  '30-179 days' = 'between 30 and 179 days',
  '≥30 days' = 'equal or more than 30 days',
  '=>180 days' = 'equal or more than 180 days'
)

# establish upper limit for years
year_min_max_data <- list()
year_min_max_input <- list('min' = NULL,'max' = NULL)

for(j in seq_along(durations)){
  
  
  # select data of interest
  prev_years_focus <-
    results_inc_prev[[1]] %>%
    dplyr::filter(
      analysis_interval == 'years',
      denominator_age_group == '0 to 100',
      denominator_sex == 'Both',
      duration == names(durations[j]))
  
  # establish upper limit for graph based on highest value +5%
  upper_limit_2 <- 
    prev_years_focus %>%
    dplyr::select(prevalence_95CI_upper) %>%
    dplyr::slice_max(order_by = prevalence_95CI_upper) %>%
    dplyr::pull()*1.05
  
  
  
  for(i in seq_along(year_min_max_input)){
    year <-
      prev_years_focus %>%
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
    data = prev_years_focus,
    aes(y = prevalence,
        x = year,
        fill = outcome_cohort_name)
  )
  
  # add lines
  y2 <- 
    y1 + geom_line(aes(color=outcome_cohort_name)) + 
    ggplot2::labs(
      y = "Prevalence",
      x = "Year",
      title = paste0("Prevalence estimates with 95% confidence intervals of macrolide use in the the study populations through time, ", names(durations)[j],".")) +  
    scale_color_discrete(name="Macrolides")
  
  # order seperate lines in seperate graphs in a grid
  y3 <- y2 + ggplot2::facet_grid(
    cols = vars(cdm_name),
    rows = vars(denominator_target_cohort_name))
  
  # adjust x- and y-axis 
  y4 <- y3 + ggplot2::scale_y_continuous(
    breaks=seq(0,upper_limit_2,0.02), limits=c(0,upper_limit_2),labels = scales::percent) +
    scale_x_continuous(breaks = seq(year_min_max_data[["min"]],year_min_max_data[["max"]], by = 2)) + 
    theme(strip.text.y.right = element_text(angle = 0))
  y4
  
  # add error ribon
  y5 <- y4 + geom_ribbon(
    aes(
      ymin = prevalence_95CI_lower, 
      ymax = prevalence_95CI_upper, 
      fill = factor(outcome_cohort_name)
    ), alpha=0.25, show.legend = FALSE
  )
  
  size <- 10
  y6 <- y5 + theme(text=element_text(size=size), #change font size of all text
          axis.text=element_text(size=size), #change font size of axis text
          axis.title=element_text(size=size), #change font size of axis titles
          plot.title=element_text(size=size), #change font size of plot title
          legend.text=element_text(size=size), #change font size of legend text
          legend.title=element_text(size=size)) #change font size of legend title
  
  #
  
  graphs_prevalence_years[[j]] <- y6
  names(graphs_prevalence_years)[j] <- names(durations)[j]
  
  #EDIT
  #export figure
  ggplot2::ggsave(
    plot = graphs_prevalence_years[[names(durations)[j]]],
    filename = paste0('prev_years_',durations[[j]],'.png'),
    path = here("figures_v2"),
    width = 4000,
    height = 2500,
    units = "px",
    dpi = 300
  )
  
  
}