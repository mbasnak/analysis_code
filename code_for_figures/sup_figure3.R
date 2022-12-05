#code for sup figure 3

#import libraries
library(ggplot2)
library(rCAT)
library(patchwork)
library(nlme)


#Relationship between bump pars and rot speed without smoothing the data
non_smoothed_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/non_smoothed_data_bar_trial.csv")

ggplot(data = subset(non_smoothed_data,!is.na(rot_speed)), aes(x = rot_speed)) +
  geom_histogram()

p1 <- non_smoothed_data %>% 
  filter(!is.nan(rot_speed)) %>%
  filter(between(rot_speed, 0,120)) %>% 
  mutate(rot_bin = cut(rot_speed,
                       breaks = seq(0,120,10),
                       right = TRUE)) %>%
  group_by(rot_bin, fly_num) %>% 
  summarise(mean_fly_bin_bw = mean(bump_width)) %>%
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
  scale_x_continuous(expand = c(0, 0), limits = c(0,120)) 

summary(lme(bump_width ~ rot_speed,random=~1|fly_num,non_smoothed_data,na.action=na.omit))


p2 <- non_smoothed_data %>% 
  filter(!is.nan(rot_speed)) %>%
  filter(between(rot_speed, 0,120)) %>% 
  mutate(rot_bin = cut(rot_speed,
                       breaks = seq(0,120,10),
                       right = TRUE)) %>%
  group_by(rot_bin, fly_num) %>% 
  summarise(mean_fly_bin_bw = mean(bump_mag)) %>%
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
  labs(x = 'Rotational speed (°/s)', y='Bump amplitude (z-scored)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.42,0.62)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,120)) 

summary(lme(bump_mag ~ rot_speed,random=~1|fly_num,non_smoothed_data,na.action=na.omit))


#load data
data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial_including_rest_10_sec.csv")

## Relationship between forward vel and rot speed
p3 <- data %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = 'Forward velocity (mm/s)', y='Rotational speed (°/s)', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0,70)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,12)) 

summary(lme(rolling_rot_speed ~ rolling_for_vel,random=~1|fly,data,na.action=na.omit))


#1) Relationship between offset precision and forward vel
ggplot(data = subset(data,!is.na(rolling_for_vel)), aes(x = rolling_for_vel)) +
  geom_histogram()

p4 <- data %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  labs(x = 'Forward velocity (mm/s)', y='HD certainty', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 12))

#running model
summary(lme(offset_precision ~ rolling_for_vel,random=~1|fly,data, control = lmeControl(opt = "optim"),na.action=na.omit))



#2) Relationship between bump pars and forward vel
p5 <-data %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean_bw - bin_sem_bw, ymax=bin_mean_bw + bin_sem_bw), fill = "gray0",alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color='gray0')+
  labs(x = 'Forward velocity (mm/s)', y='Bump width (z-scored)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.42,0.72)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,12)) 

p6 <-data %>% 
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean_bm - bin_sem_bm, ymax=bin_mean_bm + bin_sem_bm), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x = 'Forward velocity (mm/s)', y='Bump amplitude (z-scored)', color = '',fill = '') +
  scale_y_continuous(expand = c(0, 0), limits = c(-0.42,0.72)) +
  scale_x_continuous(expand = c(0, 0), limits = c(0,12)) 


#running model
summary(lme(rolling_bump_mag ~ rolling_for_vel,random=~1|fly,data,na.action=na.omit))
summary(lme(rolling_bump_width ~ rolling_for_vel,random=~1|fly,data,na.action=na.omit))




## passive rotation of the stimulus around the fly
passive_rotation_data <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/GCaMP_control/data/all_data.csv')
passive_rotation_data$nanmean_bump_width_thresh <- rad2deg(passive_rotation_data$nanmean_bump_width_thresh)

# Function for min, max values

p7 <- passive_rotation_data %>% 
  group_by(stim_vel) %>%
  summarise(bin_mean = mean(nanmean_offset_precision,na.rm=TRUE), 
            n = n(),
            bin_sem = sd(nanmean_offset_precision,na.rm=TRUE)/sqrt(n)
  ) %>% 
  ggplot(aes(stim_vel, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x="Stimulus angular speed (°/s)", y="HD certainty") +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))

summary(lme(nanmean_offset_precision ~ stim_vel,random=~1|Fly,passive_rotation_data,na.action=na.omit))



p8 <- passive_rotation_data %>% 
  group_by(stim_vel) %>%
  summarise(bin_mean = mean(nanmean_bump_width_thresh,na.rm=TRUE), 
            n = n(),
            bin_sem = sd(nanmean_bump_width_thresh,na.rm=TRUE)/sqrt(n)
  ) %>% 
  ggplot(aes(stim_vel, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x="Stimulus angular speed (°/s)", y="Bump width (°)") +
  scale_y_continuous(expand = c(0, 0), limits = c(70,135))

summary(lme(nanmean_bump_width_thresh ~ stim_vel,random=~1|Fly,passive_rotation_data,na.action=na.omit))


p9 <- passive_rotation_data %>% 
  group_by(stim_vel) %>%
  summarise(bin_mean = mean(nanmean_bump_mag_thresh,na.rm=TRUE), 
            n = n(),
            bin_sem = sd(nanmean_bump_mag_thresh,na.rm=TRUE)/sqrt(n)
  ) %>% 
  ggplot(aes(stim_vel, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "gray0",alpha = 0.2) + 
  geom_line(aes(group=1), lwd=1,color = 'gray0')+
  labs(x="Stimulus angular speed (°/s)", y="Bump amplitude (\u0394F/F)") +
  scale_y_continuous(expand = c(0, 0), limits = c(0,2.7))

summary(lme(nanmean_bump_mag_thresh ~ stim_vel,random=~1|Fly,passive_rotation_data,na.action=na.omit))


row_1 <- p4 + p1 + p2 + p3 + plot_layout(nrow = 1)
row_2 <- p4 + p5 + p6 + p3 + plot_layout(nrow = 1)
row_3 <- p7 + p8 + p9
full_plot <- row_1/row_2/row_3
full_plot + plot_annotation(tag_levels = list(c('','A','B','','C','D','E','F','G','H','I')))
#ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig3", file="full_figure.svg",device = 'svg', width=14, height=16)


#run statistics
summary(lme(nanmean_offset_precision ~ stim_vel, random=~1|Fly, passive_rotation_data))
summary(lme(nanmean_bump_width_thresh ~ stim_vel, random=~1|Fly, passive_rotation_data))
summary(lme(nanmean_bump_mag_thresh ~ stim_vel, random=~1|Fly, passive_rotation_data))