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


################# Panel B:Initial HD encoding accuracy for each cue

initial_offset_precision_data <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp38/data/third_version/initial_offset_precision_data.csv")

initial_offset_precision_data <-
  initial_offset_precision_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "Visual cue",
              block == 2 ~ "Wind"), 
    levels = c("Visual cue","Wind"))
  )

initial_offset_precision_data  %>%
  wilcox_test(initial_offset_precision ~ block, paired = TRUE) 

p1 <- ggplot() + 
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


####################### Panel C: Plot relationship between bump parameters and HD encoding for initial single cue bouts

initial_data <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp38/data/third_version/initial_data.csv")

#excluding outlier fly
filtered_initial_data <- initial_data[-5,]

#compute as difference between the cues
filtered_initial_data$bump_width_diff <- filtered_initial_data$initial_wind_bw - filtered_initial_data$initial_bar_bw
filtered_initial_data$bump_mag_diff <- filtered_initial_data$initial_wind_bm - filtered_initial_data$initial_bar_bm
filtered_initial_data$HD_encoding_diff <- filtered_initial_data$initial_wind_offset_precision - filtered_initial_data$initial_bar_offset_precision


initial_bwdiff_vs_HDencoding_diff <- ggplot(filtered_initial_data)+
  geom_point(aes(rad2deg(bump_width_diff),HD_encoding_diff))+
  geom_smooth(aes(rad2deg(bump_width_diff),HD_encoding_diff),method='lm', se = FALSE, color = 'red')  +
  # scale_x_continuous(expand = c(0, 0), limits=c(0,1))+
  # scale_y_continuous(expand = c(0, 0), limits=c(0,180)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x = 'Initial HD encoding accuracy difference (wind-vis)') +
  labs(y = 'Initial bump width difference (wind-vis)')

initial_bmdiff_vs_HDencoding_diff <- ggplot(filtered_initial_data)+
  geom_point(aes(rad2deg(bump_mag_diff),HD_encoding_diff))+
  geom_smooth(aes(rad2deg(bump_mag_diff),HD_encoding_diff),method='lm', se = FALSE, color = 'red')  +
  # scale_x_continuous(expand = c(0, 0), limits=c(0,1))+
  # scale_y_continuous(expand = c(0, 0), limits=c(0,180)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x = 'Initial HD encoding accuracy difference (wind-vis)') +
  labs(y = 'Initial bump amplitude difference (wind-vis)')

p2 <- initial_bwdiff_vs_HDencoding_diff + initial_bmdiff_vs_HDencoding_diff


cor.test(filtered_initial_data$bump_width_diff,filtered_initial_data$HD_encoding_diff,method = "pearson")
cor.test(filtered_initial_data$bump_mag_diff,filtered_initial_data$HD_encoding_diff,method = "pearson")




######## Panel E: bump PI vs initial offset ratio
offset_ratio_data2 <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp38/data/third_version/offset_ratio_data2.csv")

offset_ratio_ordered_data2 <- offset_ratio_data2 %>%
  select(offset=initial_offset_ratio_1, starts_with("pref_")) %>%
  mutate(fly = 1:14) %>%
  pivot_longer(cols = starts_with("pref"))
offset_ratio_ordered_data2 <- subset(offset_ratio_ordered_data2, select = -c(name))
colnames(offset_ratio_ordered_data2) <- c('offset_ratio','fly','pref_ind')

filtered_offset_ratio_data <- offset_ratio_ordered_data2 %>% filter(fly != 5)


#get initial offset data
initial_offset <- as.data.frame(offset_ratio_data2$initial_offset_ratio_1)
initial_offset <- initial_offset[-5,]


bar_PI <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp38/data/third_version/bar_PI.csv",header = FALSE)
names(bar_PI) <- paste0("fly", 1:ncol(bar_PI))
wind_PI <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp38/data/third_version/wind_PI.csv",header = FALSE)
names(wind_PI) <- paste0("fly", 1:ncol(wind_PI))

#remove outlier
filtered_bar_PI <- subset(bar_PI, select = -c(fly5))
filtered_wind_PI <- subset(wind_PI, select = -c(fly5))

#restructure
filtered_bar_PI <- filtered_bar_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())
filtered_wind_PI <- filtered_wind_PI %>% 
  pivot_longer(everything(), names_to = "fly", values_to = "PI") %>%
  mutate(fly = str_remove(fly, "fly") %>% as.numeric())

#add initial offset
filtered_bar_PI$initial_offset <- rep(initial_offset,4)
filtered_wind_PI$initial_offset <- rep(initial_offset,4)


#bump PI vs initial offset ratio
p3 <- ggplot(filtered_offset_ratio_data,aes(offset_ratio, pref_ind)) + 
  geom_line(aes(offset_ratio, pref_ind, group = fly),color = 'gray70',size=1) +
  geom_point() +
  geom_point(data = filtered_bar_PI, aes(x=initial_offset, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = filtered_wind_PI, aes(x=initial_offset, y=PI), size=3, color= 'blue', shape=17) +
  geom_smooth(method='lm', se = FALSE, color = 'black')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) +
  labs(x = "HD encoding accuracy (wind / visual)", y='Bump preference index')

offset_and_PI_mdl2 <- lme(pref_ind ~ offset_ratio,random=~1|fly, filtered_offset_ratio_data)
summary(offset_and_PI_mdl2)


row_1 <- p1 + p2
row_2 <- plot_spacer() + p3
full_plot <- row_1/row_2
full_plot

p3
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Revisions", file="figure4e.svg",device = 'svg', width=8, height=6)



#### indicating relevant example flies in panel e
example1 <- filtered_bar_PI[15,]
example2 <- filtered_bar_PI[30,]

ggplot(filtered_offset_ratio_data,aes(offset_ratio, pref_ind)) + 
  geom_line(aes(offset_ratio, pref_ind, group = fly),color = 'gray70',size=1) +
  geom_point() +
  geom_point(data = filtered_bar_PI, aes(x=initial_offset, y=PI), size=3, color= 'chocolate2') +
  geom_point(data = filtered_wind_PI, aes(x=initial_offset, y=PI), size=3, color= 'blue', shape=17) +
  geom_point(data = example1, aes(x=initial_offset, y=PI), size=4, color= 'black') +
  geom_point(data = example2, aes(x=initial_offset, y=PI), size=4, color= 'brown') +
  geom_smooth(method='lm', se = FALSE, color = 'black')  +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1,1)) +
  labs(x = "HD encoding accuracy (wind / visual)", y='Bump preference index')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Revisions", file="figure4e_with_examples.svg",device = 'svg', width=8, height=6)

