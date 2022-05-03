#code for sup figure 7

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)


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
rot_speed_aj$time <- rot_speed_aj$time - 1102

p1 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                       breaks = seq(-50,51,1),
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
                        breaks = seq(-50,51, 1),
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
  dplyr::select(bm_ratio=initial_bm_ratio_1, starts_with("pref_")) %>%
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
  dplyr::select(bw_ratio=initial_bw_ratio_1, starts_with("pref_")) %>%
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


## Bump PI divided by cue type
sorted_bump_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_bump_PI.csv",header = FALSE)
names(sorted_bump_PI) <- paste0("fly", 1:ncol(sorted_bump_PI))

sorted_bar_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_bar_PI.csv",header = FALSE)
names(sorted_bar_PI) <- paste0("fly", 1:ncol(sorted_bar_PI))
sorted_wind_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_wind_PI.csv",header = FALSE)
names(sorted_wind_PI) <- paste0("fly", 1:ncol(sorted_wind_PI))


sorted_bump_PI <- sorted_bump_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

#add configuration
configuration <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/configuration.csv",header = FALSE)
names(configuration) <- c('configuration')
sorted_bump_PI$configuration <- rep(configuration[1:14,1],8)
sorted_bump_PI <-
  sorted_bump_PI %>% 
  mutate(configuration = factor(
    case_when(configuration == 1 ~ "Visual cue",
              configuration == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

sorted_bar_PI <- sorted_bar_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

sorted_wind_PI <- sorted_wind_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())


ggplot(sorted_bump_PI,aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_PI, aes(x=fly, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = sorted_wind_PI, aes(x=fly, y=PI), size=3, color= 'gray30', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index")


## Initial offset precision comparison between both cues

initial_offset_precision_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/initial_offset_precision_data.csv")


initial_offset_precision_data <-
  initial_offset_precision_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "Visual cue",
              block == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

ggplot() + 
  geom_line(initial_offset_precision_data, mapping = aes(block,initial_offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Initial HD encoding reliability")+
  ylim(c(0,1))



# code to plot the full figure for the paper ------------------------------

p1 <- ggplot(sorted_bump_PI,aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_PI, aes(x=fly, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = sorted_wind_PI, aes(x=fly, y=PI), size=3, color= 'gray30', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("HD cell preference index") +
  ylim(c(-1,1))

p2 <- SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index")

#PI vs cue order
p3 <- ggplot() + 
  geom_violin(sorted_bump_PI, mapping = aes(configuration,PI)) +
  stat_summary(sorted_bump_PI, mapping = aes(configuration,PI),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(sorted_bump_PI, mapping = aes(configuration,PI),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="Initial cue", y="HD cell preference index")+
  ylim(c(-1,1))


p4 <- ggplot() + 
  geom_line(initial_offset_precision_data, mapping = aes(block,initial_offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Initial HD encoding certainty")+
  ylim(c(0,1))

p5 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-50,51, 1),
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
  geom_vline(xintercept = 0,color='red', lwd=1.5,linetype="dashed") +
  labs(y = 'Rotational speed (deg/s)', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p6 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-50,51, 1),
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
  geom_vline(xintercept = 0,color='red', lwd=1.5,linetype="dashed") +
  labs(y = '', x='Time', color = '',fill = '')+ 
  coord_cartesian(ylim=c(0,50))

p7 <- ggplot(bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump width/ \n Bar bump width", y='HD cell preference index') +
  ylim(-1,1)

p8 <- ggplot(bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind bump amplitude/ \n Bar bump amplitude", y='HD cell preference index') +
  ylim(-1,1)

row_1 <- p1 + p2
row_2 <- p3 | p4 | p5 | p6
row_3 <- p7 + p8
full_plot <- row_1 / row_2 / row_3
full_plot + plot_annotation(tag_levels = 'A') + plot_layout(heights=c(2,1,2))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="full_fig.svg",device = 'svg', width=12, height=16)
