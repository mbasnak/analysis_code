
#load packages
library(ggplot2)
library(cowplot)
library(tidyverse)



#### In inverted gain experiment
setwd('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data')


learning_data <- read.csv('learning_data.csv')


p1 <- ggplot(learning_data,aes(offset_precision,bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump magntiude", limits=c(0, 3)) 

p2 <- ggplot(learning_data,aes(offset_precision,bump_width)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width", limits=c(1, 3)) 

p <- plot_grid(p1, p2)
p


#as correlation (to get the coefficient)
cor.test(learning_data$offset_precision,learning_data$bump_mag,method = "pearson")
cor.test(learning_data$offset_precision,learning_data$bump_width,method = "pearson")



### In the cue brightness experiment, closed-loop bouts

setwd("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts")

offset_and_heading_data_closed_loop <- read.csv("offset_and_heading_data.csv")
offset_and_heading_data_closed_loop <-
  offset_and_heading_data_closed_loop %>% 
  mutate(contrast = factor(
    case_when(contrast == "Darkness" ~ "Darkness",
              contrast == "Low contrast" ~ "Low brightness",
              contrast == "High contrast" ~ "High brightness"), 
    levels = c("Darkness", "Low brightness", "High brightness"))
  )


#I) Low brightness
low_brightness <- offset_and_heading_data_closed_loop %>% filter(contrast == 'Low brightness')

#Plot
p1 <- ggplot(low_brightness, aes(offset_precision,mean_bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump magntiude", limits=c(0, 3)) 

p2 <- ggplot(low_brightness, aes(offset_precision,mean_bump_width)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width", limits=c(1, 3)) 


p <- plot_grid(p1, p2)
# now add the title
title <- ggdraw() + 
  draw_label(
    "Low brightness",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    # add margin on the left of the drawing canvas,
    # so title is aligned with left edge of first plot
    plot.margin = margin(0, 0, 0, 7)
  )
plot_grid(
  title, p,
  ncol = 1,
  # rel_heights values control vertical title margins
  rel_heights = c(0.1, 1)
)

#as correlation (to get the coefficient)
cor.test(low_brightness$offset_precision,low_brightness$mean_bump_mag,method = "pearson")
cor.test(low_brightness$offset_precision,low_brightness$mean_bump_width,method = "pearson")


#save only the first point per fly
row_odd <- seq_len(nrow(low_brightness)) %% 2              # Create row indicator
row_odd 
initial_low_brightness <- low_brightness[row_odd == 1, ]             # Subset odd rows


#Plot
p1 <- ggplot(initial_low_brightness, aes(offset_precision,mean_bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red', linetype = "dashed") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump magntiude", limits=c(0, 3)) 

p2 <- ggplot(initial_low_brightness, aes(offset_precision,mean_bump_width)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width", limits=c(1, 3)) 


p <- plot_grid(p1, p2)
# now add the title
title <- ggdraw() + 
  draw_label(
    "Low brightness",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    # add margin on the left of the drawing canvas,
    # so title is aligned with left edge of first plot
    plot.margin = margin(0, 0, 0, 7)
  )
plot_grid(
  title, p,
  ncol = 1,
  # rel_heights values control vertical title margins
  rel_heights = c(0.1, 1)
)

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="Bump_pars_offset_precision.svg",device = 'svg', width=11, height=10)


#as correlation (to get the coefficient)
cor.test(initial_low_brightness$offset_precision,initial_low_brightness$mean_bump_mag,method = "pearson")
cor.test(initial_low_brightness$offset_precision,initial_low_brightness$mean_bump_width,method = "pearson")


#Plot distribution of offset precision
ggplot(initial_low_brightness, aes(x=1,y=offset_precision)) + 
  geom_violin(aes(fill = "#FF9F9B")) +
  geom_point(size=3) +
  #geom_jitter(shape=16, position=position_jitter(0.1)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1),
        legend.position="none") +
  scale_y_continuous(name="Offset precision", limits=c(0,1)) +
  scale_x_discrete(limits = c(-1,3)) +
  xlab(' ')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="offset_precision_distribution.svg",device = 'svg', width=4, height=6)



## Plot for supplement combining across conditions
#remove second presentations of the cue
rows_to_remove = c(4,5,6,10,11,15,16,17,21,22,23,27,28,29,33,34,35,39,40,41,45,46,47,51,52,53,57,58,59,63,64,65,69,70,71,75,76,77,81,82,83,87,88,89)
halved_dataset <- offset_and_heading_data_closed_loop[-rows_to_remove,]

#Plot
p1 <- ggplot(halved_dataset, aes(offset_precision,mean_bump_mag)) +
  geom_point(aes(color = contrast),size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1),
        legend.position="none") +
  scale_color_manual(values=c('gray30','gray60','gray90')) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump magntiude", limits=c(0, 3)) 

p2 <- ggplot(halved_dataset, aes(offset_precision,mean_bump_width)) +
  geom_point(aes(color = contrast),size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1),
        legend.position="none") +
  scale_color_manual(values=c('gray20','gray50','gray90')) +
  scale_x_continuous(name="Offset_precision", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width", limits=c(1, 3)) 


p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="offset_precision_distribution_all_conditions.svg",device = 'svg', width=8, height=10)

#as correlation (to get the coefficient)
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_mag,method = "pearson")
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_width,method = "pearson")





### In the cue brightness experiment, open-loop bouts
