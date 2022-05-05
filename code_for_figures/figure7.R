#code for figure 7

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)
library(spatstat)

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
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
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
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
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



# relationship between bump and behavior PI
all_PI_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/all_PI_data.csv")


#assess if points are randomly distributed or aggregated, using the clark evans method
point_data <- ppp(x = all_PI_data$bump.PI,y=all_PI_data$heading.PI,window=owin(c(-1,1),c(-1,1)))
clarkevans.test(point_data)



##### for the offset

sorted_offset_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_offset_change.csv",header = FALSE)
names(sorted_offset_change) <- paste0("fly", 1:ncol(sorted_offset_change))

sorted_bar_offset_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_bar_offset_change.csv",header = FALSE)
names(sorted_bar_offset_change) <- paste0("fly", 1:ncol(sorted_bar_offset_change))
sorted_wind_offset_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_wind_offset_change.csv",header = FALSE)
names(sorted_wind_offset_change) <- paste0("fly", 1:ncol(sorted_wind_offset_change))


sorted_offset_change <- sorted_offset_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "offset_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

#add configuration
configuration <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/configuration.csv",header = FALSE)
names(configuration) <- c('configuration')
sorted_offset_change$configuration <- rep(configuration[1:14,1],8)
sorted_offset_change <-
  sorted_offset_change %>% 
  mutate(configuration = factor(
    case_when(configuration == 1 ~ "Visual cue",
              configuration == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

sorted_bar_offset_change <- sorted_bar_offset_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "offset_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

sorted_wind_offset_change <- sorted_wind_offset_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "offset_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())


##### for the behavior

sorted_heading_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_heading_change.csv",header = FALSE)
names(sorted_heading_change) <- paste0("fly", 1:ncol(sorted_heading_change))

sorted_bar_heading_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_bar_heading_change.csv",header = FALSE)
names(sorted_bar_heading_change) <- paste0("fly", 1:ncol(sorted_bar_heading_change))
sorted_wind_heading_change <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/sorted_wind_heading_change.csv",header = FALSE)
names(sorted_wind_heading_change) <- paste0("fly", 1:ncol(sorted_wind_heading_change))


sorted_heading_change <- sorted_heading_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "heading_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

#add configuration
configuration <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp38/data/third_version/configuration.csv",header = FALSE)
names(configuration) <- c('configuration')
sorted_heading_change$configuration <- rep(configuration[1:14,1],8)
sorted_heading_change <-
  sorted_heading_change %>% 
  mutate(configuration = factor(
    case_when(configuration == 1 ~ "Visual cue",
              configuration == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

sorted_bar_heading_change <- sorted_bar_heading_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "heading_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

sorted_wind_heading_change <- sorted_wind_heading_change %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "heading_change") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())



p1 <- ggplot(sorted_offset_change,aes(x=fly, y=rad2deg(offset_change), group=fly)) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_offset_change, aes(x=fly, y=rad2deg(offset_change)), size=3, color= 'purple') +
  geom_point(data = sorted_wind_offset_change, aes(x=fly, y=rad2deg(offset_change)), size=3, color= 'gold', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Offset change (°) ") +
  scale_y_continuous(expand = c(0, 0), limits=c(0,180)) 

p2 <- ggplot(sorted_heading_change,aes(x=fly, y=rad2deg(heading_change), group=fly)) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="white") +
  geom_point(data = sorted_bar_heading_change, aes(x=fly, y=rad2deg(heading_change)), size=3, color= 'purple') +
  geom_point(data = sorted_wind_heading_change, aes(x=fly, y=rad2deg(heading_change)), size=3, color= 'gold', shape=17) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Behavior change (°) ") +
  scale_y_continuous(expand = c(0, 0), limits=c(0,180)) 

p1 + p2


# code to make full figure for paper --------------------------------------

#bump PI
p1 <- sorted_bump_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B", alpha=0.7) +
  geom_point(size=1.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Bump preference index")

#heading PI
p2 <- sorted_heading_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric()) %>% 
  ggplot(aes(x=fly, y=PI, group=fly)) + 
  geom_hline(yintercept = 0, lty=2) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B", alpha=0.7) +
  geom_point(size=1.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(breaks=1:14) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) +
  stat_summary(aes(group=fly), fun.y = mean, color="black", geom="crossbar", width=0.5, lwd=0.5) +
  xlab("Fly #") + ylab("Behavioral preference index")

#bump PI vs initial offset ratio
p3 <- ggplot(offset_ratio_ordered_data2,aes(offset_ratio, pref_ind)) + 
  geom_line(aes(offset_ratio, pref_ind, group = fly),color = 'gray70',size=1) +
  geom_point() +
  geom_smooth(method='lm', se = FALSE, color = 'red')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) +
  labs(x = "Initial wind certainty / \n Initial visual cue certainty", y='Bump preference index')

# relationship between bump and behavior PI
p4 <- ggplot(all_PI_data, aes(bump.PI,heading.PI))+
  geom_hline(yintercept = 0, color="gray0", lwd=1) +
  geom_vline(xintercept = 0, color="gray0", lwd=1) +
  geom_point(size=2)+ 
  scale_x_continuous(expand=expansion(add=0))+
  scale_y_continuous(expand=expansion(add=0)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  annotate("rect", xmin=-1, xmax=0, ymin=0, ymax=-1, fill="yellow", alpha=0.1) +
  annotate("rect", xmin=-1, xmax=0, ymin=0, ymax=1, fill="red", alpha=0.1) +
  annotate("rect", xmin=0, xmax=1, ymin=0, ymax=-1, fill="green", alpha=0.1) +
  annotate("rect", xmin=0, xmax=1, ymin=0, ymax=1, fill="blue", alpha=0.1) +
  annotate(geom = 'segment', y = Inf, yend = Inf, color = 'gray0', x = -Inf, xend = Inf, size = 1) +
  annotate(geom = 'segment', y = -Inf, yend = Inf, color = 'gray0', x = Inf, xend = Inf, size = 1) +
  labs(x = 'Bump preference index') +
  labs(y = 'Behavioral preference index')

row_1 <- p1 + p3 + plot_layout(widths = c(1.5,1))
row_2 <- p2 + p4 + plot_layout(widths = c(1.5,1))
full_plot <- row_1/row_2
full_plot + plot_annotation(tag_levels = list(c('C','D','E','F')))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig7", file="bottom_fig_7.svg",device = 'svg', width=13, height=9)
