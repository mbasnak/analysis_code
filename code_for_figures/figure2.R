## Code to plot all figures and do all statistical analyses for the Figure 2 of the paper

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)


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


rot_speed_offset_precision %>% 
  filter(between(rot_speed, 20, 200)) %>% 
  mutate(rot_bin = cut(rot_speed,
                       breaks = seq(20, 200, 5),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin = mean(offset_precision)) %>%
  group_by(rot_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(rot_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Rotational speed (deg/s)', y='HD encoding reliability', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0.4, 1))
  
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


p1 <- bump_pars_rot_speed %>% 
  filter(between(rot_speed, 20, 150)) %>% 
  mutate(rot_bin = cut(rot_speed,
                       breaks = seq(20, 150, 10),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bm = mean(zbump_mag)) %>%
  group_by(rot_bin) %>%
  summarise(bin_mean_bm = mean(mean_fly_bin_bm), 
            n = n(),
            bin_sem_bm = sd(mean_fly_bin_bm)/sqrt(n)
  ) %>% 
  separate(rot_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean_bm)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes( ymin=bin_mean_bm - bin_sem_bm, ymax=bin_mean_bm + bin_sem_bm), fill = "#14BDFA",alpha = 0.3) + 
  geom_line(aes(group=1), lwd=2,color = '#14BDFA')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Rotational speed (deg/s)', y='Zscored bump mag', color = '',fill = '')+ 
  coord_cartesian(ylim=c(-0.6,0.6))

p2 <- bump_pars_rot_speed %>% 
  filter(between(rot_speed, 20, 150)) %>% 
  mutate(rot_bin = cut(rot_speed,
                       breaks = seq(20, 150, 10),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bw = mean(zbump_width)) %>%
  group_by(rot_bin) %>%
  summarise(bin_mean_bw = mean(mean_fly_bin_bw), 
            n = n(),
            bin_sem_bw = sd(mean_fly_bin_bw)/sqrt(n)
  ) %>% 
  separate(rot_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean_bw)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes(ymin=bin_mean_bw - bin_sem_bw, ymax=bin_mean_bw + bin_sem_bw), fill = "#FAAF0F",alpha = .3) + 
  geom_line(aes(group=1), lwd=2, color='#FAAF0F')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Rotational speed (deg/s)', y='Zscored bump width', color = '',fill = '')+ 
  coord_cartesian(ylim=c(-0.6,0.6))

p <- plot_grid(p1,p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="zbump_pars_rot_speed_bar_trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="zbump_pars_rot_speed_bar_trial.png",device = 'png', width=12, height=8)


#running model
summary(lme(bump_mag ~ rot_speed,random=~1|fly,bump_pars_rot_speed))
summary(lme(bump_width ~ rot_speed,random=~1|fly,bump_pars_rot_speed))



#3) Bump parameters and transition to mvt 
#compare bump pars in 0-25 deg/s total movement and 25-50 deg/s total mvt
bump_pars_mvt_transition <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/mean_bump_pars_bar_data_mvt_transition.csv')

bump_pars_mvt_transition$bump_width <- rad2deg(bump_pars_mvt_transition$bump_width)

bump_pars_mvt_transition <-
  bump_pars_mvt_transition %>% 
  mutate(movement = factor(
    case_when(movement == 0 ~ "Standing still",
              movement == 1 ~ "Starting movement"),
    levels = c("Standing still", "Starting movement"))
  )

# get mean and sd
mean_and_sd_bump_pars <- bump_pars_mvt_transition %>%
  group_by(movement) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())
# plot
p1 <- ggplot() + 
  geom_line(bump_pars_mvt_transition, mapping = aes(movement, bump_mag, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars,aes(movement,mean_bump_mag,group = 1),color = '#14BDFA',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars, mapping=aes(x=movement, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="#14BDFA") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude (DF/F)")

p2 <- ggplot() + 
  geom_line(bump_pars_mvt_transition, mapping = aes(movement, bump_width, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars,aes(movement,mean_bump_width,group = 1),color = '#FAAF0F',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars, mapping=aes(x=movement, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="#FAAF0F") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)")

p <- plot_grid(p1,p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="mvt_transition.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="mvt_transition.png",device = 'png', width=12, height=8)

