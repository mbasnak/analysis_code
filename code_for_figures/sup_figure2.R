#code for sup figure 2

#import libraries
library(ggplot2)
library(cowplot)
library(rCAT)


### For bar trials

#bump pars in moving vs rest
mean_bump_pars_bar_trials <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/mean_bump_pars_bar_data.csv")

#convert bump width to deg
mean_bump_pars_bar_trials$bump_width <- rad2deg(mean_bump_pars_bar_trials$bump_width)

mean_bump_pars_bar_trials <-
  mean_bump_pars_bar_trials %>% 
  mutate(movement = factor(
    case_when(movement == 0 ~ "Standing",
              movement == 1 ~ "Moving"), 
    levels = c("Standing","Moving"))
  )

mean_and_sd_bump_pars_bar_trials <- mean_bump_pars_bar_trials %>%
  group_by(movement) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())
#2) plot
p1 <- ggplot() + 
  geom_line(mean_bump_pars_bar_trials, mapping = aes(movement, bump_mag, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_bar_trials,aes(movement,mean_bump_mag,group = 1),color = '#14BDFA',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_bar_trials, mapping=aes(x=movement, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="#14BDFA") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude (DF/F)") 

p2 <- ggplot() + 
  geom_line(mean_bump_pars_bar_trials, mapping = aes(movement, bump_width, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_bar_trials,aes(movement,mean_bump_width,group = 1),color = '#FAAF0F',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_bar_trials, mapping=aes(x=movement, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="#FAAF0F") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 

p <- plot_grid(p1, p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_standing_moving_Bar_Trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_standing_moving_Bar_Trial.png",device = 'png', width=12, height=8)




#offset precision in moving vs rest
offset_precision_bar_trials <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/offset_precision_bar_data.csv')

offset_precision_bar_trials <-
  offset_precision_bar_trials %>% 
  mutate(movement = factor(
    case_when(movement == 0 ~ "Standing",
              movement == 1 ~ "Moving"), 
    levels = c("Standing","Moving"))
  )

mean_and_sd_offset_precision_bar_data <- offset_precision_bar_trials %>%
  group_by(movement) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(offset_precision_bar_trials, mapping = aes(movement, offset_precision, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_offset_precision_bar_data,aes(movement,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_precision_bar_data, mapping=aes(x=movement, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability") 

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="offset_precision_standing_moving_Bar_Trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="offset_precision_standing_moving_Bar_Trial.png",device = 'png', width=12, height=8)



#individual flies bump pars vs rotational speed
all_mvt_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/all_movement_data_bar_trial.csv")

all_mvt_data_bar_trial <- all_mvt_data_bar_trial %>% filter(between(rot_speed, 20, 150))

all_mvt_data_bar_trial$bump_width <- rad2deg(all_mvt_data_bar_trial$bump_width)

## Plot showing individual lines per fly
p1 <- ggplot(all_mvt_data_bar_trial, aes(rot_speed, bump_mag, group=fly, color=factor(fly))) +
  geom_smooth(se=FALSE) +
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20)) +
  labs(x = 'Rotational speed (deg/s)', y='Bump magnitude (DF/F)', color = '',fill = '')

p2 <- ggplot(all_mvt_data_bar_trial, aes(rot_speed, bump_width, group=fly, color=factor(fly))) +
  geom_smooth(se=FALSE) + 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=22),axis.text = element_text(size = 20)) +
  labs(x = 'Rotational speed (deg/s)', y='Bump width (deg)', color = '',fill = '')

p <- plot_grid(p1, p2)
p


ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_rot_speed_ind_flies_Bar_Trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_rot_speed_ind_flies_Bar_Trial.png",device = 'png', width=12, height=8)




# Empty trials ------------------------------------------------------------


#bump pars in moving vs rest
mean_bump_pars_empty_trials <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/mean_bump_pars_empty_data.csv")

#convert bump width to deg
mean_bump_pars_empty_trials$bump_width <- rad2deg(mean_bump_pars_empty_trials$bump_width)

mean_bump_pars_empty_trials <-
  mean_bump_pars_empty_trials %>% 
  mutate(movement = factor(
    case_when(movement == 0 ~ "Standing",
              movement == 1 ~ "Moving"), 
    levels = c("Standing","Moving"))
  )

mean_and_sd_bump_pars_empty_trials <- mean_bump_pars_empty_trials %>%
  group_by(movement) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())
#2) plot
p1 <- ggplot() + 
  geom_line(mean_bump_pars_empty_trials, mapping = aes(movement, bump_mag, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_empty_trials,aes(movement,mean_bump_mag,group = 1),color = '#14BDFA',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_empty_trials, mapping=aes(x=movement, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="#14BDFA") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude (DF/F)") 

p2 <- ggplot() + 
  geom_line(mean_bump_pars_empty_trials, mapping = aes(movement, bump_width, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_empty_trials,aes(movement,mean_bump_width,group = 1),color = '#FAAF0F',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_empty_trials, mapping=aes(x=movement, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="#FAAF0F") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 

p <- plot_grid(p1, p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_standing_moving_empty_trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="bump_pars_standing_moving_empty_trial.png",device = 'png', width=12, height=8)



offset_precision_empty_trials <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/offset_precision_empty_data.csv')

offset_precision_empty_trials <-
  offset_precision_empty_trials %>% 
  mutate(movement = factor(
    case_when(movement == 0 ~ "Standing",
              movement == 1 ~ "Moving"), 
    levels = c("Standing","Moving"))
  )

mean_and_sd_offset_precision_empty_data <- offset_precision_empty_trials %>%
  group_by(movement) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(offset_precision_empty_trials, mapping = aes(movement, offset_precision, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_offset_precision_empty_data,aes(movement,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_precision_empty_data, mapping=aes(x=movement, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability") 

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="offset_precision_standing_moving_empty_trial.svg",device = 'svg', width=12, height=8)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="offset_precision_standing_moving_empty_trial.png",device = 'png', width=12, height=8)
