#code for sup figure 7

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)


#stickiness index
SI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/SI.csv",header = FALSE)
names(SI) <- paste0("fly", 1:ncol(SI))

SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index")

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="SI.svg",device = 'svg', width=10, height=8)


#behavior around jumps
### Rotational speed around jumps
rot_speed_aj <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/rot_speed_aj.csv")

p1 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                       breaks = seq(1052,1153, 1),
                       right = TRUE)) %>%
  group_by(time_bin, jump_num) %>% 
  summarise(mean_fly_bin = mean(rot_speed_bj)) %>%
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
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  #geom_point(size=5, color="red")+ 
  labs(y = 'Rotational speed (deg/s)', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p2 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(1052,1153, 1),
                        right = TRUE)) %>%
  group_by(time_bin, jump_num) %>% 
  summarise(mean_fly_bin = mean(rot_speed_wj)) %>%
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
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  #geom_point(size=5, color="red")+ 
  labs(y = '', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p <- plot_grid(p1,p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="behavior_aj.svg",device = 'svg', width=10, height=6)

#initial bump par ratios vs PI?
#Using the opposite ratio
bump_pars_ratio_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/bump_pars_ratio_data2.csv")

bump_mag_ratio_ordered_data <- bump_pars_ratio_data %>%
  select(bm_ratio=initial_bm_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
bump_mag_ratio_ordered_data <- subset(bump_mag_ratio_ordered_data, select = -c(name))
colnames(bump_mag_ratio_ordered_data) <- c('bump_mag_ratio','fly','pref_ind')

bump_mag_ratio_and_PI_mdl <- lme(pref_ind ~ bump_mag_ratio,random=~1|fly, bump_mag_ratio_ordered_data)
summary(bump_mag_ratio_and_PI_mdl)

ggplot(bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump amplitude/ \n Bar bump amplitude", y='HD cell preference index') +
  ylim(-1,1)



bump_width_ratio_ordered_data <- bump_pars_ratio_data %>%
  select(bw_ratio=initial_bw_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
bump_width_ratio_ordered_data <- subset(bump_width_ratio_ordered_data, select = -c(name))
colnames(bump_width_ratio_ordered_data) <- c('bump_width_ratio','fly','pref_ind')

bump_width_ratio_and_PI_mdl <- lme(pref_ind ~ bump_width_ratio,random=~1|fly, bump_width_ratio_ordered_data)
summary(bump_width_ratio_and_PI_mdl)

ggplot(bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump width/ \n Bar bump width", y='HD cell preference index') +
  ylim(-1,1)


# code to plot the full figure for the paper ------------------------------

p1 <- SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index")


p2 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(1052,1153, 1),
                        right = TRUE)) %>%
  group_by(time_bin, jump_num) %>% 
  summarise(mean_fly_bin = mean(rot_speed_bj)) %>%
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
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  geom_vline(xintercept = 1102,color='red', lwd=2) +
  #geom_point(size=5, color="red")+ 
  labs(y = 'Rotational speed (deg/s)', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p3 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(1052,1153, 1),
                        right = TRUE)) %>%
  group_by(time_bin, jump_num) %>% 
  summarise(mean_fly_bin = mean(rot_speed_wj)) %>%
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
        text = element_text(size=16),axis.text = element_text(size = 12))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey70") + 
  geom_line(aes(group=1), lwd=2)+
  geom_vline(xintercept = 1102,color='red', lwd=2) +
  #geom_point(size=5, color="red")+ 
  labs(y = '', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p4 <- ggplot(bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump width/ \n Bar bump width", y='HD cell preference index') +
  ylim(-1,1)

p5 <- ggplot(bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump amplitude/ \n Bar bump amplitude", y='HD cell preference index') +
  ylim(-1,1)

row_2 <- p2 + p3
row_3 <- p4 + p5
full_plot <- p1 / row_2 / row_3
full_plot + plot_annotation(tag_levels = 'A')
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="full_fig.svg",device = 'svg', width=12, height=16)
