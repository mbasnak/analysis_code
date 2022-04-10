#Code to analyze the evolution of parameters during the offset stabilizer bout

#load useful libraries
library(nlme)
library(lme4)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)


#set working directory
setwd("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts")


#load the data
bump_pars_evo_data_bar_trial <- read.csv("bump_pars_evo_data_bar_trial.csv")
precision_evo_data_bar_trial <- read.csv("precision_evo_data_bar_trial.csv")

fig1_theme <-  
  list(
    theme(legend.position=c(0.70, 0.15),
          legend.background = element_rect(color=NA, fill=NA),
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=18),axis.text = element_text(size = 16))
  )

p1 <- ggplot(precision_evo_data_bar_trial, aes(time, offset_precision))+ 
  fig1_theme+
  geom_smooth(alpha=0.2)+ 
  labs(y='Offset precision', color = '',fill = '')

p2 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag))+ 
  fig1_theme+
  geom_smooth(alpha=0.2)+ 
  labs(y='Bump magnitude', color = '',fill = '')

p3 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_width))+ 
  fig1_theme+
  geom_smooth(alpha=0.2)+ 
  labs(y='Bump width', color = '',fill = '')

p <- plot_grid(p1, p2, p3, ncol = 1)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak", file="initial_pars_evo.svg",device = 'svg', width=12, height=8)



#heading precision evolution
ggplot(precision_evo_data_bar_trial, aes(time, heading_precision))+ 
  fig1_theme+
  geom_smooth(alpha=0.2) +
  coord_cartesian(ylim=c(0.3,0.7)) +
  labs(y='Heading precision', color = '',fill = '')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak", file="initial_heading_precision_evo.svg",device = 'svg', width=12, height=8)


#look at total movement evo
ggplot(bump_pars_evo_data_bar_trial, aes(time,total_mvt))+ 
  fig1_theme+
  geom_smooth(alpha=0.2) +
  labs(y='Total movement', color = '',fill = '')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak", file="initial_total_mvt_evo.svg",device = 'svg', width=12, height=4)
