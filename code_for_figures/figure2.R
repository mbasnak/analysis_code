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



#model
summary(lme(offset_precision ~ time, random=~1|fly,precision_evo_data_bar_trial))



#Evolution of bump width
bump_pars_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/bump_pars_evo_data_bar_trial.csv")

bump_pars_evo_data_bar_trial$bump_width <- rad2deg(bump_pars_evo_data_bar_trial$bump_width)


#model
summary(lme(bump_width ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))




#model
summary(lme(bump_mag ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))



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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))  
  
p5 <- ggplot(Fly2,aes(time, heading_precision,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = '', y='', color = '',fill = '')+ 
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(82,133)) 


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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(82,133)) 
  

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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(82,133)) 
  

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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0.8,3)) 


p11 <- ggplot(fly2,aes(time, bump_mag,group=fly))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_line(lwd=1,color='deeppink')+
  labs(x = 'Time (min)', y='', color = '',fill = '')+ 
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0.8,3)) 
  
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
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200), breaks=c(0,300,600,900,1200),labels=c('0',"5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0.8,3)) 
  


row_1 <- p1 + p2 + p3
row_2 <- p4 + p5 + p6
row_3 <- p7 + p8 + p9
row_4 <- p10 + p11 + p12
full_plot <- row_1 / row_2 /row_3 / row_4
full_plot + plot_annotation(tag_levels = list(c('A','','','B','','','C','','','D')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig2", file="all_figure_2.svg",device = 'svg', width=13, height=16)
