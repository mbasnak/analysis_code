#code for sup figure 7

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)
library(rstatix)

#stickiness index
SI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_SI.csv",header = FALSE)
names(SI) <- paste0("fly", 1:ncol(SI))


#behavior around jumps
### Rotational speed around jumps
rot_speed_aj <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/rot_speed_aj.csv")
rot_speed_aj$time <- rot_speed_aj$time - 1102


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


bump_width_ratio_ordered_data <- bump_pars_ratio_data %>%
  dplyr::select(bw_ratio=initial_bw_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
bump_width_ratio_ordered_data <- subset(bump_width_ratio_ordered_data, select = -c(name))
colnames(bump_width_ratio_ordered_data) <- c('bump_width_ratio','fly','pref_ind')

bump_width_ratio_and_PI_mdl <- lme(pref_ind ~ bump_width_ratio,random=~1|fly, bump_width_ratio_ordered_data)
summary(bump_width_ratio_and_PI_mdl)



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




## Initial offset precision comparison between both cues

initial_offset_precision_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/initial_offset_precision_data.csv")

initial_offset_precision_data <-
  initial_offset_precision_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "Visual cue",
              block == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

initial_offset_precision_data  %>%
  wilcox_test(initial_offset_precision ~ block, paired = TRUE) 

# code to plot the full figure for the paper ------------------------------

p1 <- ggplot(sorted_bump_PI,aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_PI, aes(x=fly, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = sorted_wind_PI, aes(x=fly, y=PI), size=3, color= 'gray30', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 

p2 <- SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B", alpha=0.7) +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 


p4 <- ggplot() + 
  geom_line(initial_offset_precision_data, mapping = aes(block,initial_offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_point(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Initial HD certainty")+
  scale_y_continuous(expand = c(0, 0), limits=c(0,1)) 

rot_speed_aj$time <- rot_speed_aj$time/9.18

p5 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-5,5, 0.1),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  geom_vline(xintercept = 0,color='red', lwd=1,linetype="dashed") +
  labs(y = 'Rotational speed (°/s)', x='Time (sec)', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits=c(0,50)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-5,5)) 

p6 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-5,5, 0.1),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  geom_vline(xintercept = 0,color='red', lwd=1,linetype="dashed") +
  labs(y = 'Rotational speed (°/s)', x='Time (sec)', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits=c(0,50)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-5,5)) 

p7 <- ggplot(bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump width / \n Initial visual cue bump width", y='Bump preference index') +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1))
  
p8 <- ggplot(bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump amplitude / \n Initial visual cue bump amplitude", y='Bump preference index') +
  ylim(-1,1)

row_1 <- p1 + p2
row_2 <- p4 | p5 | p6
row_3 <- p7 + p8
full_plot <- row_1 / row_2 / row_3
full_plot + plot_annotation(tag_levels = list(c('A','B','C','D','','E','F','G'))) + plot_layout(heights=c(1.5,1,1.5))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="full_fig.svg",device = 'svg', width=14, height=16)





########### repeat removing fly 5 from all panels

## Bump PI divided by cue type
filtered_bump_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/filtered_bump_PI.csv",header = FALSE)
names(filtered_bump_PI) <- paste0("fly", 1:ncol(filtered_bump_PI))

filtered_bar_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/filtered_bar_PI.csv",header = FALSE)
names(filtered_bar_PI) <- paste0("fly", 1:ncol(filtered_bar_PI))
filtered_wind_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/filtered_wind_PI.csv",header = FALSE)
names(filtered_wind_PI) <- paste0("fly", 1:ncol(filtered_wind_PI))


filtered_bump_PI <- filtered_bump_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

#add configuration
configuration <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/configuration.csv",header = FALSE)
names(configuration) <- c('configuration')
configuration <- as.data.frame(configuration[-c(5),])
filtered_bump_PI$configuration <- rep(configuration[1:13,1],8)
filtered_bump_PI <-
  filtered_bump_PI %>% 
  mutate(configuration = factor(
    case_when(configuration == 1 ~ "Visual cue",
              configuration == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

filtered_bar_PI <- filtered_bar_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

filtered_wind_PI <- filtered_wind_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())


p1 <- ggplot(filtered_bump_PI,aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = filtered_bar_PI, aes(x=fly, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = filtered_wind_PI, aes(x=fly, y=PI), size=3, color= 'gray30', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:13) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 


#stickiness index
filtered_SI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/filtered_SI.csv",header = FALSE)
names(filtered_SI) <- paste0("fly", 1:ncol(filtered_SI))


p2 <- filtered_SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B", alpha=0.7) +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:13) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 


#initial offset precision data
filtered_initial_offset_precision_data <- initial_offset_precision_data[-c(5,19),]
filtered_initial_offset_precision_data  %>%
  wilcox_test(initial_offset_precision ~ block, paired = TRUE) 


p4 <- ggplot() + 
  geom_line(filtered_initial_offset_precision_data, mapping = aes(block,initial_offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_point(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Initial HD certainty")+
  scale_y_continuous(expand = c(0, 0), limits=c(0,1)) 


### Rotational speed around jumps
filtered_rot_speed_aj <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/filtered_rot_speed_aj.csv")
filtered_rot_speed_aj$time <- filtered_rot_speed_aj$time - 1102

filtered_rot_speed_aj$time <- filtered_rot_speed_aj$time/9.18

p6 <- filtered_rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-5,5, 0.1),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  geom_vline(xintercept = 0,color='red', lwd=1,linetype="dashed") +
  labs(y = 'Rotational speed (°/s)', x='Time (sec)', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits=c(0,50)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-5,5)) 


filtered_bump_width_ratio_ordered_data <- bump_width_ratio_ordered_data %>% filter(fly != 5)
filtered_bump_mag_ratio_ordered_data <- bump_mag_ratio_ordered_data %>% filter(fly != 5)

p7 <- ggplot(filtered_bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump width / \n Initial visual cue bump width", y='Bump preference index') +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1))

p8 <- ggplot(filtered_bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump amplitude / \n Initial visual cue bump amplitude", y='Bump preference index') +
  ylim(-1,1)


row_1 <- p1 + p2
row_2 <- p4 | p5 | p6
row_3 <- p7 + p8
full_plot <- row_1 / row_2 / row_3
full_plot + plot_annotation(tag_levels = list(c('A','B','C','D','','E','F','G'))) + plot_layout(heights=c(1.5,1,1.5))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="full_fig_no_outlier.svg",device = 'svg', width=14, height=16)










### removing fly 5 only from the panels that quantify things including initial periods

p1 <- ggplot(sorted_bump_PI,aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_PI, aes(x=fly, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = sorted_wind_PI, aes(x=fly, y=PI), size=3, color= 'gray30', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 

p2 <- SI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B", alpha=0.7) +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index") +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) 



p4 <- ggplot() + 
  geom_line(filtered_initial_offset_precision_data, mapping = aes(block,initial_offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_point(initial_offset_precision_data, mapping = aes(block,initial_offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Initial HD certainty")+
  scale_y_continuous(expand = c(0, 0), limits=c(0,1)) 


p6 <- rot_speed_aj %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(-5,5, 0.1),
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
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes( ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = "grey0",alpha=0.2) + 
  geom_line(aes(group=1), lwd=1)+
  geom_vline(xintercept = 0,color='red', lwd=1,linetype="dashed") +
  labs(y = 'Rotational speed (°/s)', x='Time (sec)', color = '',fill = '')+ 
  scale_y_continuous(expand = c(0, 0), limits=c(0,50)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-5,5)) 



p7 <- ggplot(filtered_bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
  geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump width / \n Initial visual cue bump width", y='Bump preference index') +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1))

p8 <- ggplot(filtered_bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
  geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x = "Initial wind bump amplitude / \n Initial visual cue bump amplitude", y='Bump preference index') +
  ylim(-1,1)


row_1 <- p1 + p2
row_2 <- p4 | p5 | p6
row_3 <- p7 + p8
full_plot <- row_1 / row_2 / row_3
full_plot + plot_annotation(tag_levels = list(c('A','B','C','D','','E','F','G'))) + plot_layout(heights=c(1.5,1,1.5))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig7", file="full_fig_no_outlier_some_panels.svg",device = 'svg', width=14, height=16)

