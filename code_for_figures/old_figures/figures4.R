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



# offset precision distribution in this environment
#load data
offset_and_heading_data_closed_loop <- read.csv("Z:/wilsonlab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/offset_and_heading_data.csv")

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


# Relationship between offset precision and bump parameters

#as correlation (to get the coefficient)
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_mag,method = "pearson")
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_width,method = "pearson")





# code to plot the entire figure ------------------------------------------


# Relationship between offset precision and bump parameters
p1 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_width)) +
  geom_point(size = 3.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1)) +
  scale_y_continuous(name="Bump width (°)", expand = c(0, 0), limits = c(82,133)) 

p2 <- ggplot(initial_low_contrast, aes(offset_precision,mean_bump_mag)) +
  geom_point(size = 3.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_x_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1)) +
  scale_y_continuous(name="Bump amplitude (\u0394F/F)", expand = c(0, 0), limits = c(0.8, 3)) 

p <- p1 + p2
p + plot_annotation(tag_levels = list(c('C','D')))
#ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="bottom_fig_4.svg",device = 'svg', width=8, height=5)
