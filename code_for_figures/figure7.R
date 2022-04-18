#code for figure 7

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)



# 2 examples around cue jumps


# bump preference index
## Plot bump preference per fly
sorted_bump_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_bump_PI.csv",header = FALSE)
names(sorted_bump_PI) <- paste0("fly", 1:ncol(sorted_bump_PI))

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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig7", file="sorted_bump_PI.svg",device = 'svg', width=10, height=8)


# behavior preference index
sorted_heading_PI <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_heading_PI.csv",header = FALSE)
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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig7", file="sorted_heading_PI.svg",device = 'svg', width=10, height=8)



# bump PI vs initial offset ratio
offset_ratio_data2 <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/offset_ratio_data2.csv")

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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig7", file="bump_PI_vs_offset_ratio.svg",device = 'svg', width=10, height=8)



# behavior around jumps


# relationship between bump and behavior PI
all_PI_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/all_PI_data.csv")


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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig7", file="heading_vs_bump_PI.svg",device = 'svg', width=10, height=8)

