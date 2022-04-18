## Code to plot all figures and do all statistical analyses for the Figure 2 of the paper

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)


#1) Relationship between offset precision and rotational speed
rot_speed_offset_precision <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/rot_speed_offset_precision.csv")

fig1_theme <-  
  list(
    theme(legend.position=c(0.70, 0.15),
          legend.background = element_rect(color=NA, fill=NA),
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=22),axis.text = element_text(size = 20)),
    xlim(20,200),
    coord_cartesian(ylim = c(-0.8,0.8))
  )

ggplot(rot_speed_offset_precision, aes(rot_speed, offset_precision))+ 
  fig1_theme+
  geom_smooth(alpha=0.3)+ 
  labs(x = 'Rotational speed (deg/s)', y='HD encoding reliability', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0, 1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="rot_speed_offset_precision.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="rot_speed_offset_precision.png",device = 'png', width=12, height=8)


#running model
summary(lme(offset_precision ~ rot_speed,random=~1|fly,rot_speed_offset_precision))



#2) Relationship between bump pars and rotational speed
#with bar trial data

bump_pars_rot_speed <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial.csv")


fig1_theme <-  
  list(
    theme(legend.position=c(0.70, 0.15),
          legend.background = element_rect(color=NA, fill=NA),
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=22),axis.text = element_text(size = 20)),
    xlim(0,200),
    coord_cartesian(ylim = c(-0.5,0.5))
  )



p1 <- ggplot(bump_pars_rot_speed, aes(rot_speed, zbump_width)) + 
  fig1_theme +
  geom_smooth(alpha=0.1) +
  labs(x = 'Rotational speed (deg/s)', y="Zscored bump width", color = '',fill = '')

p2 <- ggplot(bump_pars_rot_speed, aes(rot_speed, zbump_mag))+ 
  fig1_theme+
  geom_smooth(alpha=0.1)+ 
  labs(x = 'Rotational speed (deg/s)', y='Zscored bump magnitude', color = '',fill = '')

p <- plot_grid(p1, p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="zbump_pars_rot_speed_bar_trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="zbump_pars_rot_speed_bar_trial.png",device = 'png', width=12, height=8)


#running model
summary(lme(bump_mag ~ rot_speed,random=~1|fly,bump_pars_rot_speed))
summary(lme(bump_width ~ rot_speed,random=~1|fly,bump_pars_rot_speed))



#3) Bump parameters and transition to mvt 
#compare bump pars in 0-25 deg/s total movement and 25-50 deg/s total mvt

