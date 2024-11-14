# graphs based o on sex and age groups are similar! Lets merge it all together...



library(here)
library(dplyr)
library(scales)
library(ggplot2)
library(stringr)

################################################################################
################################################################################
################ PREVALENCES RELATED TO AGE GROUPS #############################
################################################################################
################################################################################

# check existing folder
if (!dir.exists(here::here("figures_v2"))) 
{dir.create(here::here("figures_v2"))}

# a list of macrolide groups
macrolides <- list(
  'Macrolides' = 'Macrolides',
  'Azithromycin' = 'Azithromycin',
  'Clarithromycin' = 'Clarithromycin',
  'Erythromycin' = 'Erythromycin'
)

# empty object to store graphs
graphs <- NULL

# I want to produce the same graphs for sex and age groups. So lets make a list
graph_topics <- list(
  'Age' = 'age groups',
  'Sex' = 'sex'
)

for(i in seq_along(macrolides)){
  for(j in seq_along(graph_topics)){
  
  # filter out the appropriate groups
    prev_focus <-
      results_inc_prev[[1]] %>%
      {if(graph_topics[[j]] == 'sex')
        dplyr::filter(.,
                      analysis_interval == 'overall',
                      outcome_cohort_name == macrolides[[i]],
                      denominator_age_group == '0 to 100')
        else .} %>% 
      {if(graph_topics[[j]] == 'age groups') 
        dplyr::filter(.,
                      analysis_interval == 'overall',
                      denominator_sex == 'Both',
                      outcome_cohort_name == macrolides[[i]])
      else .}%>%
      dplyr::select(everything())
  
  
  # establish upper limit for graph based on highest value +5%
  upper_limit <- 
    prev_focus %>%
    dplyr::select(prevalence_95CI_upper) %>%
    dplyr::slice_max(order_by = prevalence_95CI_upper) %>%
    dplyr::pull()*1.05
  
  
  # first visible graph
  a2 <- ggplot2::ggplot(data = prev_focus)
  
  if(graph_topics[[j]] == 'sex') {
    a2 <- a2 + ggplot2::aes(
      x = denominator_target_cohort_name,
      y = prevalence,
      fill = denominator_sex
    )
  }
  
  if(graph_topics[[j]] == 'age groups') {
    a2 <- a2 + ggplot2::aes(
      x = denominator_target_cohort_name,
      y = prevalence,
      fill = denominator_age_group
    )
  }
  
  a2 <- a2 + ggplot2::geom_col(width = 0.8, position = 'dodge', color='black', size = 0.05)
  
  #a2
  
  
  
  # scaling a bit
  b2 <- 
    a2 +
    ggplot2::scale_y_continuous(
      #breaks=seq(0,0.8,0.05), 
      limits=c(0,upper_limit),labels = scales::percent
    ) # some results not shown as <5 people contributed


  # giving proper names
  c2 <- 
    b2 + ggplot2::labs(x = "",
                       y = "Prevalence",
                       fill = names(graph_topics)[j],
                       title = paste0("Prevalence estimates with 95% confidence intervals of prescribed ",tolower(macrolides[[i]]),
                                      ", for various time periods, among study populations of interest, stratified by ", graph_topics[[j]]))
  
  # split graphs based on duration
  d2 <- c2 + ggplot2::facet_grid(
    cols = vars(duration),
    rows = vars(cdm_name))
  
  # adding the error intervals
  e2 <- d2 + geom_errorbar(
    aes(
      ymin = prevalence_95CI_lower,
      ymax = prevalence_95CI_upper
    ),
    linewidth = 0.2,
    width = 0.4,
    position=position_dodge(.8)
  )
  e2
  
  # adding the percentages above the error intervals
  # no need for added text, it adds too much noise
  f2 <- e2 #+
    # ggplot2::geom_text(aes(
    #   y = prevalence_95CI_upper,
    #   label = prev_adj),
    #   position = position_dodge2(0.75),
    #   hjust= 0.3,
    #   vjust= -0.9,
    #   size = 1.8)
  
  

  
  
  # adjusting text on the right side y-axis
  g2 <- f2 + theme(strip.text.y.right = element_text(angle = 0))
  
    size <- 10
    g3 <- g2 + theme(text=element_text(size=size), #change font size of all text
                     axis.text=element_text(size=size), #change font size of axis text
                     axis.title=element_text(size=size), #change font size of axis titles
                     plot.title=element_text(size=size), #change font size of plot title
                     legend.text=element_text(size=size), #change font size of legend text
                     legend.title=element_text(size=size)) #change font size of legend title
  
    # customize color for sex
      if(graph_topics[[j]] == 'sex') {
        g3 <- g3 + scale_fill_manual(values=c('orange', '#F06C6B', '#1C92D8'))
      }

  
  #store all graphs in an object with some listy abracadabra

  if(j == 1){
    graphs[[i]] <- g3
    names(graphs)[i] <- paste0('prev_',names(graph_topics)[j],'_',names(macrolides)[i])
  } else if(j == 2) {
    graphs[[i+length(macrolides)]] <- g3
    names(graphs)[i+length(macrolides)] <- paste0('prev_',names(graph_topics)[j],'_',names(macrolides)[i])
  }

  #export figure
  ggplot2::ggsave(
    plot = graphs[[paste0('prev_',names(graph_topics)[j],'_',names(macrolides)[i])]],
    filename = paste0('prev_',names(graph_topics)[j],'_',names(macrolides)[i],'.png'),
    path = here("figures_v2"),
    width = 4000,
    height = 2500,
    units = "px",
    dpi = 300
  )
  }
}


