#code for sup figure 4

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
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
p1 <- ggplot(halved_dataset, aes(offset_precision,mean_bump_width)) +
  geom_point(aes(color = contrast),size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position="none") +
  scale_color_manual(values=c('gray0','gray70','deepskyblue1')) +
  scale_x_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1)) +
  scale_y_continuous(name="Bump width (°)", expand = c(0, 0), limits = c(82,136)) 

p2 <- ggplot(halved_dataset, aes(offset_precision,mean_bump_mag)) +
  geom_point(aes(color = contrast),size = 2.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position="none") +
  scale_color_manual(values=c('gray0','gray70','deepskyblue1')) +
  scale_x_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1)) +
  scale_y_continuous(name="Bump amplitude (\u0394F/F)", expand = c(0, 0), limits = c(0.8, 3)) 


p <- p1 + p2
p + plot_annotation(tag_levels = 'A')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig4", file="offset_precision_distribution_all_conditions.svg",device = 'svg', width=8, height=6)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig4", file="offset_precision_distribution_all_conditions.png",device = 'png', width=8, height=6)


#as correlation (to get the coefficient)
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_mag,method = "pearson")
cor.test(halved_dataset$offset_precision,halved_dataset$mean_bump_width,method = "pearson")

