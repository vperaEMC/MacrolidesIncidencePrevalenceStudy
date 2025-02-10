library(here)
library(dplyr)
library(scales)
library(ggplot2)
library(stringr)

# check existing folder
if (!dir.exists(here::here("figures"))) 
{dir.create(here::here("figures"))}

# a list of macrolide groups
macrolides <- list(
  'Macrolides' = 'Any macrolides',
  'Azithromycin' = 'Azithromycin',
  'Clarithromycin' = 'Clarithromycin',
  'Erythromycin' = 'Erythromycin'
)

# gather duration levels
durations <- list(
  '<30 days' = 'less than 30 days',
  '30-179 days' = 'between 30 and 179 days',
  '≥180 days' = 'equal or more than 180 days'
)

# empty object to store graphs
graphs <- list()

# I want to produce the same graphs for sex and age groups. So lets make a list
graph_topics <- list(
  'Age' = 'age groups',
  'Sex' = 'sex'
)

# provide order for labels on x-axis
label_ordered <- c('Asthma', 'COPD', 'ACO', 'Gen. pop.')

for(i in seq_along(durations)){
  for(j in seq_along(graph_topics)){
    for(k in seq_along(results_inc_prev)){
      
      # filter out the appropriate groups
      inc_prev_overall_focus <-
        results_inc_prev[[k]] %>%
        {if(graph_topics[[j]] == 'sex')
          dplyr::filter(.,
                        analysis_interval == 'overall',
                        duration == names(durations)[i],
                        denominator_age_group == 'All ages')
          else .} %>% 
        {if(graph_topics[[j]] == 'age groups') 
          dplyr::filter(.,
                        analysis_interval == 'overall',
                        duration == names(durations)[i],
                        denominator_sex == 'Both')
          else .} %>%
        dplyr::select(everything())
      
      
      # establish upper limit for graph based on highest value +5%
      upper_limit <- 
        inc_prev_overall_focus %>%
        dplyr::select(upper_95CI) %>%
        dplyr::slice_max(order_by = upper_95CI) %>%
        dplyr::pull()*1.05
      
      
      # first visible graph
      a2 <- ggplot2::ggplot(data = inc_prev_overall_focus)
      
      if(graph_topics[[j]] == 'sex') {
        a21 <- a2 + ggplot2::aes(
          x = denominator_target_cohort_integer,
          y = point_estimate,
          fill = denominator_sex
        ) # some results not shown as <5 people contributed
      }
      
      if(graph_topics[[j]] == 'age groups') {
        a21 <- a2 + ggplot2::aes(
          x = denominator_target_cohort_integer,
          y = point_estimate,
          fill = denominator_age_group
        )
      }
      
 # naming convention of the secondary axis
      name_sec_x_axis <- 'Macrolides'
      name_sec_y_axis <- 'Databases'
      
      a22 <- a21 + ggplot2::geom_col(
        #width = 0.8,
        position = position_dodge2(width = 0.8, preserve = "single", padding = 0),
        color='black', 
        size = 0.05) + # keeps columns same width
        scale_x_continuous(
          breaks = unique(inc_prev_overall_focus$denominator_target_cohort_integer), 
          labels = label_ordered,
          sec.axis = sec_axis(~ . , name = name_sec_x_axis,
                              breaks = NULL, labels = NULL))
      
      # giving proper names for the legend title
      if(names(graph_topics)[j] == 'Age'){
        fill_name <- 'Age groups \n(in years)'
      } else {
        fill_name <- names(graph_topics)[j]
      }
      
      if(names(results_inc_prev)[k] == 'prevalence'){
        b2 <- 
          a22 + ggplot2::labs(x = "",
                              y = "Period prevalence",
                              fill = fill_name,
                              title = paste0(
"Period prevalence estimates with 95% confidence intervals for time window ",
durations[[i]],", for various macrolides, among study cohorts of interest, stratified by ", 
graph_topics[[j]])) +
          ggplot2::scale_y_continuous(
            #breaks=seq(0,0.8,0.05), 
            expand = c(0.005, 0),
            limits=c(0,upper_limit),labels = scales::percent,
            sec.axis = sec_axis(~ . , name = name_sec_y_axis,
                                breaks = NULL, labels = NULL))
      } else if(names(results_inc_prev)[k] == 'incidence'){
        # giving proper names
        b2 <- 
          a22 + ggplot2::labs(x = "",
                              y = "Incidence per 100,000 Person Years",
                              fill = fill_name,
                              title = paste0(
"Incidence estimates with 95% confidence intervals for time window ",
durations[[i]],", for various macrolides, among study cohorts of interest, stratified by ", 
graph_topics[[j]])) +
          ggplot2::scale_y_continuous(
            #breaks=seq(0,0.8,0.05), 
            expand = c(0.005, 0),
            limits=c(0,upper_limit), labels = comma_format(big.mark = ",",
                                                           decimal.mark = "."),
            sec.axis = sec_axis(~ . , name = name_sec_y_axis,
                                breaks = NULL, labels = NULL))
      }
      
      # split graphs based on duration
      d2 <- b2 + ggplot2::facet_grid(
        cols = vars(outcome_cohort_name),
        rows = vars(cdm_name)
      ) + xlab('Study cohorts')

      # add 95%CIs
      e2 <- d2 + geom_errorbar(
        aes(
          ymin = lower_95CI,
          ymax = upper_95CI
        ),
        position = position_dodge2(width = 0.8, preserve = "single", padding = 0),
        linewidth = 0.1
        #width = 0.4
      )
      
      # adjusting text on the right side y-axis
      g2 <- e2 + theme(strip.text.y.right = element_text(angle = 0))
      
      size <- 10
      g3 <- g2 + theme(text=element_text(size=size), #change font size of all text
                       axis.text=element_text(size=size), #change font size of axis text
                       axis.title=element_text(size=size), #change font size of axis titles
                       plot.title=element_text(size=size-2), #change font size of plot title
                       legend.text=element_text(size=size), #change font size of legend text
                       legend.title=element_text(size=size),#change font size of legend title
                       axis.title.y = element_text(margin = margin(r = 10)), #move title Y-axis away
                       axis.title.x = element_text(margin = margin(t = 6)),
                       panel.spacing = grid::unit(5.5, "mm", data = NULL)
      ) 
      
      # customize color for sex
      if(graph_topics[[j]] == 'sex') {
        g3 <- g3 + scale_fill_manual(values=c('orange', '#F06C6B', '#1C92D8'))
      }
      
      g3 + geom_rect(
        aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf),
        fill = "lightgray", alpha = 0.3) + # Dummy data to define the rectangle
        coord_cartesian(clip = "off") # Ensure the rectangle doesn't get clipped
      
      
      #store all graphs in an object with some listy abracadabra
      
      # put graph in list
      last_graph <- list(
        test_name = g3)
      
      # give new name for graph in list
      names(last_graph) <- paste0(names(results_inc_prev)[k], '_', names(graph_topics)[j],'_',durations[[i]])
      
      # merge lists so all graphs are together
      graphs <- c(graphs, last_graph)
      
    }
  }
}

for (q in seq_along(graphs)){
  #export figure
  ggplot2::ggsave(
    plot = graphs[[q]],
    filename = paste0(names(graphs)[q],'.png'),
    path = here("figures"),
    width = 4000,
    height = 2500,
    units = "px",
    dpi = 300
  )
  
}
