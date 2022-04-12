#code to analyze the cue jump experiment
library(tidyverse)
library(ggplot2)
library(svglite)
library(spatstat)


#set working directory
setwd("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version")



## Plot stickiness index

SI <- read.csv("SI.csv",header = FALSE)
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
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Stickiness index")

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="SI.svg",device = 'svg', width=10, height=8)




## Plot bump preference per fly
sorted_bump_PI <- read.csv("sorted_bump_PI.csv",header = FALSE)
names(sorted_bump_PI) <- paste0("fly", 1:ncol(sorted_bump_PI))

#1) as boxplots
# sorted_bump_PI %>% 
#   pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
#   mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
#   ggplot(aes(fly, PI, group=fly)) + 
#   geom_hline(yintercept = 0, lty=2) +
#   geom_boxplot(fill="#FF9F9B", width=0.7) +
#   geom_point(size=4, alpha=0.4)+
#   scale_x_continuous(breaks=1:14)+
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5))

# # denstiy going negative below -1
# sorted_bump_PI %>% 
#   pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
#   mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
#   ggplot(aes(x=PI, group=fly)) + 
#   #geom_boxplot(width=0.4) +
#   #geom_violin()+
#   ggridges::geom_density_ridges(aes(y=fly), scale = 0.5) + 
#   geom_point(aes(y=fly), size=3) +
#   coord_flip()

#2) as density plots

sorted_bump_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index")

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="sorted_bump_PI.svg",device = 'svg', width=10, height=8)

#3) just individual points + median
# sorted_bump_PI %>% 
#   pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
#   mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
#   ggplot(aes(x=fly, y=PI, group=fly)) + 
#   geom_hline(yintercept = 0, lty=2) + 
#   geom_point(size=3) +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5))+
#   scale_x_continuous(breaks=1:14) +
#   stat_summary(aes(group=fly), fun.y = median, color="red", geom="crossbar", width=0.7, lwd=1)


#Repeat for heading PI
sorted_heading_PI <- read.csv("sorted_heading_PI.csv",header = FALSE)
names(sorted_heading_PI) <- paste0("fly", 1:ncol(sorted_heading_PI))


sorted_heading_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Behavioral preference index")

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="sorted_heading_PI.svg",device = 'svg', width=10, height=8)




#### relationship between bump and heading PI

all_PI_data <- read.csv("all_PI_data.csv")

ggplot(all_PI_data, aes(heading.PI, bump.PI))+
  stat_density2d_filled(alpha=0.8, bins = 5) +
  geom_hline(yintercept = 0, color="white", lwd=2) +
  geom_vline(xintercept = 0, color="white", lwd=2) +
  geom_point(size=2)+ 
  scale_x_continuous(expand=expansion(add=0))+
  scale_y_continuous(expand=expansion(add=0)) +
  theme(legend.position="none")+
  NULL
# there's a new package that does this same plot but on the legend you have the 
# percentage associated with the breaks instead of the bin values



ggplot(all_PI_data, aes(bump.PI,heading.PI))+
  geom_hline(yintercept = 0, color="gray0", lwd=1.5) +
  geom_vline(xintercept = 0, color="gray0", lwd=1.5) +
  geom_point(size=2)+ 
  scale_x_continuous(expand=expansion(add=0))+
  scale_y_continuous(expand=expansion(add=0)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  annotate("rect", xmin=-1, xmax=0, ymin=0, ymax=-1, fill="yellow", alpha=0.2) +
  annotate("rect", xmin=-1, xmax=0, ymin=0, ymax=1, fill="red", alpha=0.2) +
  annotate("rect", xmin=0, xmax=1, ymin=0, ymax=-1, fill="green", alpha=0.2) +
  annotate("rect", xmin=0, xmax=1, ymin=0, ymax=1, fill="blue", alpha=0.2) +
  annotate(geom = 'segment', y = Inf, yend = Inf, color = 'gray0', x = -Inf, xend = Inf, size = 2.3) +
  annotate(geom = 'segment', y = -Inf, yend = Inf, color = 'gray0', x = Inf, xend = Inf, size = 2.3) +
  labs(x = 'Bump preference index') +
  labs(y = 'Heading preference index')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_vs_heading_PI.svg",device = 'svg', width=10, height=10)


#assess if points are randomly distributed or aggregated, using the clark evans method
point_data <- ppp(x = all_PI_data$bump.PI,y=all_PI_data$heading.PI,window=owin(c(-1,1),c(-1,1)))
clarkevans.test(point_data)



##### Relationship between initial offset precision ratio and mean bump preference index

offset_ratio_data <- read.csv("offset_ratio_data.csv")

#1) Quadrant plot
# offset_ratio_data %>% 
#   select(offset=initial_offset_ratio_1, starts_with("pref_")) %>% 
#   mutate(fly = 1:14) %>% 
#   pivot_longer(cols = starts_with("pref")) %>% 
#   ggplot(aes(offset, value)) +
#   geom_hline(yintercept = 0, color="black", lwd=1) +
#   geom_vline(xintercept = 1, color="black", lwd=1) +
#   annotate("rect", xmin=1, xmax=Inf, ymin=0, ymax=-Inf, fill="yellow", alpha=0.2)+
#   annotate("rect", xmin=-Inf, xmax=1, ymin=0, ymax=Inf, fill="yellow", alpha=0.2)+
#   theme_bw()+
#   labs(x="Offset precision ratio", y="Bump prefernce index") +
#   #geom_point() +
#   stat_summary(geom="point", aes(group=fly), color="black", size=4) -> p
# ggExtra::ggMarginal(p, color="black", fill="gray90", size=4)


#2) As a linear regression including all data points
offset_ratio_ordered_data <- offset_ratio_data %>%
  select(offset=initial_offset_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
offset_ratio_ordered_data <- subset(offset_ratio_ordered_data, select = -c(name))
colnames(offset_ratio_ordered_data) <- c('offset_ratio','fly','pref_ind')

offset_and_PI_mdl <- lme(pref_ind ~ offset_ratio,random=~1|fly, offset_ratio_ordered_data)
summary(offset_and_PI_mdl)

ggplot(offset_ratio_ordered_data,aes(offset_ratio, pref_ind)) + 
  geom_line(aes(offset_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Bar offset precision / Wind offset precision", y='Bump preference index') 
#+
 # scale_x_continuous(breaks=1:14) +
  #ylim(-1,1)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_offset_ratio.svg",device = 'svg', width=10, height=8)


# #3) As a linear regression with mean only
# 
# offset_ratio_mean_data <- read.csv("offset_ratio_mean_data.csv")
# 
# ggplot(offset_ratio_mean_data,aes(initial_offset_ratio, pref_index)) +
#   geom_point() +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(x = "Initial bar offset precision/heading offset precision", y='Bump preference index') +
#   geom_smooth(method='lm')
# 
# # run model
# lm_fit <- lm(pref_index ~ initial_offset_ratio, data=offset_ratio_mean_data)
# summary(lm_fit)
# 
# #without se
# ggplot(offset_ratio_mean_data,aes(initial_offset_ratio, pref_index)) +
#   geom_point() +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(x = "Initial bar offset precision/heading offset precision", y='Bump preference index') +
#   geom_smooth(method='lm', se = FALSE) +
#   ylim(-1,1)
# 
# #test deleting the point farther on the right to see if the trend changes
# test <- offset_ratio_mean_data[-c(3), ]
# 
# lm_fit <- lm(pref_index ~ initial_offset_ratio, data=test)
# summary(lm_fit)
# 
# ggplot(test,aes(initial_offset_ratio, pref_index)) +
#   geom_point() +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(x = "Initial bar offset precision/heading offset precision", y='Bump preference index') +
#   geom_smooth(method='lm') +
#   ylim(-1,1)


#repeat with behavior data
offset_ratio_behavior_data <- read.csv("offset_ratio_behavior_data.csv")

offset_ratio_behavior_ordered_data <- offset_ratio_behavior_data %>%
  select(offset=initial_offset_ratio_1, starts_with("heading_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("heading"))
offset_ratio_behavior_ordered_data <- subset(offset_ratio_behavior_ordered_data, select = -c(name))
colnames(offset_ratio_behavior_ordered_data) <- c('offset_ratio','fly','heading_pref_ind')

offset_and_heading_PI_mdl <- lme(heading_pref_ind ~ offset_ratio,random=~1|fly, offset_ratio_behavior_ordered_data)
summary(offset_and_heading_PI_mdl)

ggplot(offset_ratio_behavior_ordered_data,aes(offset_ratio, heading_pref_ind)) + 
  geom_line(aes(offset_ratio, heading_pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Bar offset precision / Wind offset precision", y='Behavioral preference index') +
  scale_x_continuous(breaks=1:14) +
  ylim(-1,1)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="heading_PI_vs_offset_ratio.svg",device = 'svg', width=10, height=8)


#### Repeat using the inverted ratio
offset_ratio_data2 <- read.csv("offset_ratio_data2.csv")

offset_ratio_ordered_data2 <- offset_ratio_data2 %>%
  select(offset=initial_offset_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
offset_ratio_ordered_data2 <- subset(offset_ratio_ordered_data2, select = -c(name))
colnames(offset_ratio_ordered_data2) <- c('offset_ratio','fly','pref_ind')

offset_and_PI_mdl <- lme(pref_ind ~ offset_ratio,random=~1|fly, offset_ratio_ordered_data2)
summary(offset_and_PI_mdl)

ggplot(offset_ratio_ordered_data2,aes(offset_ratio, pref_ind)) + 
  geom_line(aes(offset_ratio, pref_ind, group = fly),color = 'gray70') +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  labs(x = "Wind offset precision / Bar offset precision", y='Bump preference index') +
  scale_x_continuous(breaks=1:14) +
  ylim(-1,1)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_offset_ratio2.svg",device = 'svg', width=10, height=8)


##### bump pars ratio and pref index
# bump_pars_ratio_data <- read.csv("bump_pars_ratio_data.csv")
# 
# bump_mag_ratio_ordered_data <- bump_pars_ratio_data %>%
#   select(bm_ratio=initial_bm_ratio_1, starts_with("pref_")) %>%
#   mutate(fly = 1:14) %>%
#   pivot_longer(cols = starts_with("pref"))
# bump_mag_ratio_ordered_data <- subset(bump_mag_ratio_ordered_data, select = -c(name))
# colnames(bump_mag_ratio_ordered_data) <- c('bump_mag_ratio','fly','pref_ind')
# 
# bump_mag_ratio_and_PI_mdl <- lme(pref_ind ~ bump_mag_ratio,random=~1|fly, bump_mag_ratio_ordered_data)
# summary(bump_mag_ratio_and_PI_mdl)
# 
# ggplot(bump_mag_ratio_ordered_data,aes(bump_mag_ratio, pref_ind)) + 
#   geom_line(aes(bump_mag_ratio, pref_ind, group = fly),color = 'gray70') +
#   geom_point() +
#   geom_smooth(method='lm', se = FALSE, color = 'red')  +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(x = "Bar bump mag/ Wind bump mag", y='Bump preference index') +
#   scale_x_continuous(breaks=1:14) +
#   ylim(-1,1)
# 
# ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_bump_mag_ratio.svg",device = 'svg', width=10, height=8)
# 
# 
# bump_width_ratio_ordered_data <- bump_pars_ratio_data %>%
#   select(bw_ratio=initial_bw_ratio_1, starts_with("pref_")) %>%
#   mutate(fly = 1:14) %>%
#   pivot_longer(cols = starts_with("pref"))
# bump_width_ratio_ordered_data <- subset(bump_width_ratio_ordered_data, select = -c(name))
# colnames(bump_width_ratio_ordered_data) <- c('bump_width_ratio','fly','pref_ind')
# 
# bump_width_ratio_and_PI_mdl <- lme(pref_ind ~ bump_width_ratio,random=~1|fly, bump_width_ratio_ordered_data)
# summary(bump_width_ratio_and_PI_mdl)
# 
# ggplot(bump_width_ratio_ordered_data,aes(bump_width_ratio, pref_ind)) + 
#   geom_line(aes(bump_width_ratio, pref_ind, group = fly),color = 'gray70') +
#   geom_point() +
#   geom_smooth(method='lm', se = FALSE, color = 'red')  +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(x = "Bar bump width/ Wind bump width", y='Bump preference index') +
#   scale_x_continuous(breaks=1:14) +
#   ylim(-1,1)
# 
# ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_bump_width_ratio.svg",device = 'svg', width=10, height=8)



#Using the opposite ratio
bump_pars_ratio_data <- read.csv("bump_pars_ratio_data2.csv")

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
  labs(x = "Wind bump mag/Bar bump mag", y='Bump preference index') +
  scale_x_continuous(breaks=1:14) +
  ylim(-1,1)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_bump_mag_ratio.svg",device = 'svg', width=10, height=8)


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
  labs(x = "Wind bump width/ bar bump width", y='Bump preference index') +
  scale_x_continuous(breaks=1:14) +
  ylim(-1,1)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueJump-Experiment", file="bump_PI_vs_bump_width_ratio.svg",device = 'svg', width=10, height=8)





### Rotational speed around jumps
# rot_speed_abj <- read.csv("rot_speed_abj.csv",header = FALSE)
# 
# ggplot(rot_speed_abj) + 
#   geom_smooth(method='lm', se = FALSE, color = 'red')  +
#   theme(panel.background = element_rect(fill=NA),
#         text=element_text(size=22),
#         axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
#         axis.line.x = element_line(size=1.5),
#         axis.line.y = element_line(size=1.5)) +
#   labs(y = 'Rotational speed (deg/s)') +
#   scale_x_continuous(breaks=1:14) +
#   ylim(-1,1)

