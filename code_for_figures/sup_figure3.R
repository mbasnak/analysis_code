#code for sup figure 3

#import libraries
library(ggplot2)
library(rCAT)
library(patchwork)


## Relationship between rotational speed and forward velocity
#load data
data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial.csv")

## Relationship between the 3 variables in figure 3 in forward velocity
p1 <- data %>% 
  filter(between(rolling_for_vel, 0, 12)) %>% 
  mutate(for_bin = cut(rolling_for_vel,
                       breaks = seq(0,12,1),
                       right = TRUE)) %>%
  group_by(for_bin, fly) %>% 
  summarise(mean_fly_bin = mean(rolling_rot_speed,na.rm=TRUE)) %>%
  group_by(for_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin,na.rm=TRUE), 
            n = n(),
            bin_sem = sd(mean_fly_bin,na.rm=TRUE)/sqrt(n)
  ) %>% 
  separate(for_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  labs(x = 'Forward velocity (mm/s)', y='Rotational speed (deg/s)', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,70))

#1) Relationship between offset precision and forward vel
ggplot(data = subset(data,!is.na(rolling_for_vel)), aes(x = rolling_for_vel)) +
  geom_histogram()

p2 <- data %>% 
  filter(between(rolling_for_vel, 0, 12)) %>% 
  mutate(for_bin = cut(rolling_for_vel,
                       breaks = seq(0,12,1),
                       right = TRUE)) %>%
  group_by(for_bin, fly) %>% 
  summarise(mean_fly_bin = mean(offset_precision,na.rm=TRUE)) %>%
  group_by(for_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin,na.rm=TRUE), 
            n = n(),
            bin_sem = sd(mean_fly_bin,na.rm=TRUE)/sqrt(n)
  ) %>% 
  separate(for_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  labs(x = 'Forward velocity (mm/s)', y='HD encoding certainty', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0.65, 1))


#running model
summary(lme(offset_precision ~ rolling_for_vel,random=~1|fly,data, control = lmeControl(opt = "optim"),na.action=na.omit))



#2) Relationship between bump pars and forward vel
p3 <-data %>% 
  filter(between(rolling_for_vel, 0,12)) %>% 
  mutate(for_bin = cut(rolling_for_vel,
                       breaks = seq(0,12,1),
                       right = TRUE)) %>%
  group_by(for_bin, fly) %>% 
  summarise(mean_fly_bin_bw = mean(rolling_bump_width,na.rm=TRUE)) %>%
  group_by(for_bin) %>%
  summarise(bin_mean_bw = mean(mean_fly_bin_bw,na.rm=TRUE), 
            n = n(),
            bin_sem_bw = sd(mean_fly_bin_bw,na.rm=TRUE)/sqrt(n)
  ) %>% 
  separate(for_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean_bw)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes(ymin=bin_mean_bw - bin_sem_bw, ymax=bin_mean_bw + bin_sem_bw), fill = "gray0",alpha = .3) + 
  geom_line(aes(group=1), lwd=2, color='gray0')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Forward velocity (mm/s)', y='Bump width (z-scored)', color = '',fill = '')

p4 <-data %>% 
  filter(between(rolling_for_vel, 0,12)) %>% 
  mutate(for_bin = cut(rolling_for_vel,
                       breaks = seq(0,12,1),
                       right = TRUE)) %>%
  group_by(for_bin, fly) %>% 
  summarise(mean_fly_bin_bm = mean(rolling_bump_mag,na.rm=TRUE)) %>%
  group_by(for_bin) %>%
  summarise(bin_mean_bm = mean(mean_fly_bin_bm,na.rm=TRUE), 
            n = n(),
            bin_sem_bm = sd(mean_fly_bin_bm,na.rm=TRUE)/sqrt(n)
  ) %>% 
  separate(for_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean_bm)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes( ymin=bin_mean_bm - bin_sem_bm, ymax=bin_mean_bm + bin_sem_bm), fill = "gray0",alpha = 0.3) + 
  geom_line(aes(group=1), lwd=2,color = 'gray0')+
  #geom_point(size=5, color="red")+ 
  labs(x = 'Forward velocity (mm/s)', y='Bump amplitude (z-scored)', color = '',fill = '')


#running model
summary(lme(rolling_bump_mag ~ rolling_for_vel,random=~1|fly,data,na.action=na.omit))
summary(lme(rolling_bump_width ~ rolling_for_vel,random=~1|fly,data,na.action=na.omit))




## passive rotation of the stimulus around the fly
passive_rotation_data <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/GCaMP_control/data/all_data.csv')
passive_rotation_data$nanmean_bump_width_thresh <- rad2deg(passive_rotation_data$nanmean_bump_width_thresh)

p5 <- ggplot(passive_rotation_data,aes(stim_vel,nanmean_offset_precision)) +
  geom_line(aes(group=Fly),color = 'gray50',size=0.5) +
  stat_summary(fun=mean, geom="line", size=1.5, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x="Stimulus angular speed (deg/s)", y="HD encoding certainty") 

p6 <- ggplot(passive_rotation_data,aes(stim_vel,nanmean_bump_width_thresh)) +
  geom_line(aes(group=Fly),color = 'gray50',size=0.5) +
  stat_summary(fun=mean, geom="line", size=1.5, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x="Stimulus angular speed (deg/s)", y="Bump width (deg)") 

p7 <- ggplot(passive_rotation_data,aes(stim_vel,nanmean_bump_mag_thresh)) +
  geom_line(aes(group=Fly),color = 'gray50',size=0.5) +
  stat_summary(fun=mean, geom="line", size=1.5, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x="Stimulus angular speed (deg/s)", y="Bump amplitude (\u0394F/F)") 

row_1 <- p1 + plot_spacer() + plot_spacer()
row_2 <- p2 + p3 + p4
row_3 <- p5 + p6 + p7
full_plot <- row_1/row_2/row_3
full_plot + plot_annotation(tag_levels = list(c('A','B','','','C','','')))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig3", file="full_figure.svg",device = 'svg', width=14, height=18)


#run statistics
summary(lme(nanmean_offset_precision ~ stim_vel, random=~1|Fly, passive_rotation_data))
summary(lme(nanmean_bump_width_thresh ~ stim_vel, random=~1|Fly, passive_rotation_data))
summary(lme(nanmean_bump_mag_thresh ~ stim_vel, random=~1|Fly, passive_rotation_data))