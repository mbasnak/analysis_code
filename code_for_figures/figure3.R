## Code to plot all figures and do all statistical analyses for the Figure 2 of the paper

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)
library(rstatix)

#load data
data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial_including_rest_10_sec.csv")


#1) Relationship between offset precision and rotational speed
ggplot(data = subset(data,!is.na(rolling_rot_speed)), aes(x = rolling_rot_speed)) +
  geom_histogram()

p1 <- data %>% 
  filter(between(rolling_rot_speed, 0, 70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "gray0",alpha = .2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = 'Rotational speed (°/s)', y='HD certainty', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 



#running model
summary(lme(offset_precision ~ rolling_rot_speed,random=~1|fly,data, control = lmeControl(opt = "optim"),na.action=na.omit))



#2) Relationship between bump pars and rotational speed
p2 <-data %>% 
  filter(!is.nan(rolling_bump_width)) %>%
  filter(between(rolling_rot_speed, 0,70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bw = mean(rolling_bump_width)) %>%
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean_bw - bin_sem_bw, ymax=bin_mean_bw + bin_sem_bw), fill = "gray0",alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color='gray0')+
  labs(x = 'Rotational speed (°/s)', y='Bump width (z-scored)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.42,0.62)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 


p3 <-data %>% 
  filter(!is.nan(rolling_bump_mag)) %>%
  filter(between(rolling_rot_speed, 0,70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bm = mean(rolling_bump_mag)) %>%
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean_bm - bin_sem_bm, ymax=bin_mean_bm + bin_sem_bm), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x = 'Rotational speed (°/s)', y='Bump amplitude (z-scored)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.42,0.62)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 



#running model
summary(lme(rolling_bump_mag ~ rolling_rot_speed,random=~1|fly,data,na.action=na.omit))
summary(lme(rolling_bump_width ~ rolling_rot_speed,random=~1|fly,data,na.action=na.omit))


row_1 <- p1 + p2 + p3
full_plot <- row_1
full_plot + plot_annotation(tag_levels = list(c('B','C','D')))


ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bottom_figure_3.svg",device = 'svg', width=15, height=6)



### Repeat without z-scoring

#load data
nonz_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial_including_rest_10_sec_nonz.csv")
nonz_data$rolling_bump_width <- rad2deg(nonz_data$rolling_bump_width)

#1) Relationship between offset precision and rotational speed
ggplot(data = subset(nonz_data,!is.na(rolling_rot_speed)), aes(x = rolling_rot_speed)) +
  geom_histogram()

p1 <- nonz_data %>% 
  filter(between(rolling_rot_speed, 0, 70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "gray0",alpha = .2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = 'Fly\'s rotational speed (°/s)', y='HD encoding accuracy', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 



#running model
summary(lme(offset_precision ~ rolling_rot_speed,random=~1|fly,nonz_data, control = lmeControl(opt = "optim"),na.action=na.omit))



#2) Relationship between bump pars and rotational speed
p2 <-nonz_data %>% 
  filter(!is.nan(rolling_bump_width)) %>%
  filter(between(rolling_rot_speed, 0,70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bw = mean(rolling_bump_width)) %>%
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean_bw - bin_sem_bw, ymax=bin_mean_bw + bin_sem_bw), fill = "gray0",alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color='gray0')+
  labs(x = 'Fly\'s rotational speed (°/s)', y='Bump width (°)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(70,130)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 


p3 <-nonz_data %>% 
  filter(!is.nan(rolling_bump_mag)) %>%
  filter(between(rolling_rot_speed, 0,70)) %>% 
  mutate(rot_bin = cut(rolling_rot_speed,
                       breaks = seq(0,70,5),
                       right = TRUE)) %>%
  group_by(rot_bin, fly) %>% 
  summarise(mean_fly_bin_bm = mean(rolling_bump_mag)) %>%
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean_bm - bin_sem_bm, ymax=bin_mean_bm + bin_sem_bm), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x = 'Fly\'s rotational speed (°/s)', y='Bump amplitude (\u0394F/F)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2.5)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,70)) 



#running model
summary(lme(rolling_bump_mag ~ rolling_rot_speed,random=~1|fly,nonz_data,na.action=na.omit))
summary(lme(rolling_bump_width ~ rolling_rot_speed,random=~1|fly,nonz_data,na.action=na.omit))


row_1 <- p1 + p2 + p3
full_plot <- row_1
full_plot + plot_annotation(tag_levels = list(c('B','C','D')))

#running model
summary(lme(rolling_bump_mag ~ rolling_rot_speed,random=~1|fly,nonz_data,na.action=na.omit))
summary(lme(rolling_bump_width ~ rolling_rot_speed,random=~1|fly,nonz_data,na.action=na.omit))


ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/ExtraFigures", file="bump_pars_vs_rot_speed.svg",device = 'svg', width=15, height=6)
