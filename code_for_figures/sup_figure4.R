#code for sup figure 4

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)



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
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump magntiude (DF/F)", limits=c(0, 3)) 

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
  scale_x_continuous(name="HD encoding reliability", limits=c(0, 1)) +
  scale_y_continuous(name="Bump width (deg)", limits=c(70,150)) 


p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig4", file="offset_precision_distribution_all_conditions.svg",device = 'svg', width=8, height=10)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig4", file="offset_precision_distribution_all_conditions.png",device = 'png', width=8, height=10)


#as correlation (to get the coefficient)
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_mag,method = "pearson")
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_width,method = "pearson")

