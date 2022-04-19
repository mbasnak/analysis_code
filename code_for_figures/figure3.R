#code for figure 3

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)


#Evolution of offset precision
precision_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/precision_evo_data_bar_trial.csv")

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

# p1 <- ggplot(precision_evo_data_bar_trial, aes(time, offset_precision))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2)+ 
#   labs(y='HD encoding reliability', color = '',fill = '')
# 
# 
# #Evolution of bump width
# bump_pars_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/bump_pars_evo_data_bar_trial.csv")
# 
# bump_pars_evo_data_bar_trial$bump_width <- rad2deg(bump_pars_evo_data_bar_trial$bump_width)
# 
# p2 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_width))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2)+ 
#   labs(y='Bump width (deg)', color = '',fill = '')
# 
# p <- plot_grid(p1, p2, ncol = 1)
# p

p1 <- precision_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,100),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(offset_precision)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), alpha = .3) + 
  geom_line(aes(group=1), lwd=2)+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Time (sec)', y='HD encoding reliability', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0.5,1))


#Evolution of bump width
bump_pars_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/bump_pars_evo_data_bar_trial.csv")

bump_pars_evo_data_bar_trial$bump_width <- rad2deg(bump_pars_evo_data_bar_trial$bump_width)

p2 <- bump_pars_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,100),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(bump_width)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = '#FAAF0F', alpha = .3) + 
  geom_line(aes(group=1), lwd=2, color='#FAAF0F')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Time (sec)', y='Bump width (deg)', color = '',fill = '')+ 
  coord_cartesian(ylim=c(85,125))

p <- plot_grid(p1, p2, ncol = 1)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="offset_precision_bump_width_evo.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="offset_precision_bump_width_evo.png",device = 'png', width=12, height=8)


#Evolution of bump mag
p1 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag))+ 
  fig1_theme+
  geom_smooth(alpha=0.2)+ 
  labs(y='Bump amplitude (DF/F)', color = '',fill = '')

#Evolution of movement (test both tot mvt and rot speed)
p2 <- ggplot(bump_pars_evo_data_bar_trial, aes(time,total_mvt))+ 
  fig1_theme+
  geom_smooth(alpha=0.2) +
  labs(y='Total movement (deg/s)', color = '',fill = '')

p <- plot_grid(p1, p2, ncol = 1)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_total_mvt_evo.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_total_mvt_evo.png",device = 'png', width=12, height=8)

bump_pars_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,60),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(bump_mag)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = '#14BDFA', alpha = .3) + 
  geom_line(aes(group=1), lwd=2, color= '#14BDFA')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Time (sec)', y='Bump magnitude (DF/F)', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0.5,2.5))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_evo.svg",device = 'svg', width=12, height=4)



#test with rot speed instead of movement

# p1 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2)+ 
#   labs(y='Bump amplitude (DF/F)', color = '',fill = '')
# 
# #Evolution of movement (test both tot mvt and rot speed)
# p2 <- ggplot(bump_pars_evo_data_bar_trial %>% filter(rot_speed<250), aes(time,rot_speed))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2) +
#   labs(y='Rot speed (deg/s)', color = '',fill = '')
# 
# p <- plot_grid(p1, p2, ncol = 1)
# p


#Evolution of heading precision
ggplot(precision_evo_data_bar_trial, aes(time, heading_precision))+ 
  fig1_theme+
  geom_smooth(alpha=0.2) +
  coord_cartesian(ylim=c(0.3,0.7)) +
  labs(y='Heading reliability', color = '',fill = '')

precision_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,120),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(heading_precision)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), alpha = .3) + 
  geom_line(aes(group=1), lwd=2)+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Time (sec)', y='Heading reliability', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0.2,0.7))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="initial_heading_precision_evo.svg",device = 'svg', width=12, height=4)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="initial_heading_precision_evo.png",device = 'svg', width=12, height=4)
