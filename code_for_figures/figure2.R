#code for figure 3

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)

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

#model
summary(lme(offset_precision ~ time, random=~1|fly,precision_evo_data_bar_trial))



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

#model
summary(lme(bump_width ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))


#Evolution of bump mag
# p1 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2)+ 
#   labs(y='Bump amplitude (DF/F)', color = '',fill = '')
# 
# #Evolution of movement (test both tot mvt and rot speed)
# p2 <- ggplot(bump_pars_evo_data_bar_trial, aes(time,total_mvt))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2) +
#   labs(y='Total movement (deg/s)', color = '',fill = '')
# 
# p <- plot_grid(p1, p2, ncol = 1)
# p
# 
# ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_total_mvt_evo.svg",device = 'svg', width=12, height=8)
# ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_total_mvt_evo.png",device = 'png', width=12, height=8)

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
  labs(x = 'Time (sec)', y='Bump amplitude (DF/F)', color = '',fill = '')+ 
  coord_cartesian(ylim=c(1,2.2))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig3", file="bump_mag_evo.svg",device = 'svg', width=12, height=4)

#model
summary(lme(bump_mag ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))



#Evolution of heading precision
# ggplot(precision_evo_data_bar_trial, aes(time, heading_precision))+ 
#   fig1_theme+
#   geom_smooth(alpha=0.2) +
#   coord_cartesian(ylim=c(0.3,0.7)) +
#   labs(y='Heading reliability', color = '',fill = '')

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

#model
summary(lme(heading_precision ~ time, random=~1|fly,precision_evo_data_bar_trial))





# code to plot the entire figure ------------------------------------------

#1) evolution of HD encoding certainty
#example flies
Fly1 <- precision_evo_data_bar_trial %>% filter(precision_evo_data_bar_trial$fly == 17)
p1 <- ggplot(Fly1,aes(time, offset_precision,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deepskyblue')+
  labs(x = '', y='HD certainty', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) 
  
Fly2 <- precision_evo_data_bar_trial %>% filter(precision_evo_data_bar_trial$fly == 14)
p2 <- ggplot(Fly2,aes(time, offset_precision,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))  
  
#average data
p3 <- precision_evo_data_bar_trial %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), alpha = .2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) 
  
# 2) Consistency of orientation behavior
#example flies
p4 <- ggplot(Fly1,aes(time, heading_precision,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deepskyblue')+
  labs(x = '', y='Consistency of \n orientation behavior', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))  
  
p5 <- ggplot(Fly2,aes(time, heading_precision,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))  
  
#average data
p6 <- precision_evo_data_bar_trial %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), alpha = .2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) 
  
#3) Evolution of bump width
#example flies
fly1 <- bump_pars_evo_data_bar_trial %>% filter(bump_pars_evo_data_bar_trial$fly == 17)
p7 <- ggplot(fly1,aes(time, bump_width,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deepskyblue')+
  labs(x = '', y='Bump width (°)', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(70,135)) 
  

fly2 <- bump_pars_evo_data_bar_trial %>% filter(bump_pars_evo_data_bar_trial$fly == 14)
p8 <- ggplot(fly2,aes(time, bump_width,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(70,135)) 
  

#average data
p9 <- bump_pars_evo_data_bar_trial %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = 'gray0', alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color='gray0')+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(70,135)) 
  

# 4) Evolution of bump magnitude
#example flies
p10 <- ggplot(fly1,aes(time, bump_mag,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deepskyblue')+
  labs(x = 'Time (min)', y='Bump amplitude (\u0394F/F)', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2.7)) 
  
p11 <- ggplot(fly2,aes(time, bump_mag,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = 'Time (min)', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2.7)) 
  
#avergage data
p12 <- bump_pars_evo_data_bar_trial %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = 'gray0', alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color= 'gray0')+
  labs(x = 'Time (min)', y='', color = '',fill = '')+ 
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2.7))
  


row_1 <- p1 + p2 + p3
row_2 <- p4 + p5 + p6
row_3 <- p7 + p8 + p9
row_4 <- p10 + p11 + p12
full_plot <- row_1 / row_2 /row_3 / row_4
full_plot + plot_annotation(tag_levels = list(c('A','','','B','','','C','','','D')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="all_figure_2.svg",device = 'svg', width=11, height=14)
