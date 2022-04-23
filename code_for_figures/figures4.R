#code for figure 4

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(rmatio)
library(reshape2)
library(patchwork)

# Two different example flies in the low contrast period with different offset precision
example_fly_1 <- read.mat('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/example_data_1.mat')





# offset precision distribution in this environment
#load data
offset_and_heading_data_closed_loop <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/offset_and_heading_data.csv")

offset_and_heading_data_closed_loop$mean_bump_width <- rad2deg(offset_and_heading_data_closed_loop$mean_bump_width)

offset_and_heading_data_closed_loop <-
  offset_and_heading_data_closed_loop %>% 
  mutate(contrast = factor(
    case_when(contrast == "Darkness" ~ "No contrast",
              contrast == "Low contrast" ~ "Low contrast",
              contrast == "High contrast" ~ "High contrast"), 
    levels = c("No contrast", "Low contrast", "High contrast"))
  )


low_contrast <- offset_and_heading_data_closed_loop %>% filter(contrast == 'Low contrast')

#save only the first point per fly
row_odd <- seq_len(nrow(low_contrast)) %% 2              # Create row indicator
initial_low_contrast <- low_contrast[row_odd == 1, ]             # Subset odd rows

#plot
ggplot(initial_low_contrast, aes(x=1,y=offset_precision)) + 
  geom_violin(aes(fill = "#FF9F9B")) +
  geom_point(size=3) +
  #geom_jitter(shape=16, position=position_jitter(0.1)) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1),
        legend.position="none") +
  scale_y_continuous(name="HD encoding reliability", limits=c(0,1)) +
  scale_x_discrete(limits = c(-1,3)) +
  xlab(' ')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="offset_precision_distribution.svg",device = 'svg', width=4, height=6)



# Relationship between offset precision and bump parameters
#plot
p1 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red', linetype = "dashed") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump amplitude (DF/F)", limits=c(0, 3)) 

p2 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_width)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width (deg)", limits=c(70,150)) 


p <- plot_grid(p1, p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="Bump_pars_offset_precision.svg",device = 'svg', width=12, height=6)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="Bump_pars_offset_precision.png",device = 'png', width=12, height=6)


#as correlation (to get the coefficient)
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_mag,method = "pearson")
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_width,method = "pearson")





# code to plot the entire figure ------------------------------------------


# Relationship between offset precision and bump parameters
p1 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_width)) +
  geom_point(size = 3.5) +
  # geom_point(aes(offset_precision[2],mean_bump_width[2]),color='blue') +
  # geom_point(aes(offset_precision[11],mean_bump_width[11]),color='red') +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width (deg)", limits=c(70,150)) 

p2 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_mag)) +
  geom_point(size = 3.5) +
  # geom_point(aes(offset_precision[2],mean_bump_mag[2]),color='blue') +
  # geom_point(aes(offset_precision[11],mean_bump_mag[11]),color='red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump amplitude (DF/F)", limits=c(0, 3)) 

p <- p1 + p2
p + plot_annotation(tag_levels = list(c('B','C')))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="bottom_fig_4.svg",device = 'svg', width=14, height=8)
