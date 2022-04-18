#code for figure 4

#load useful libraries
library(nlme)
library(lmer)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(rmatio)
library(reshape2)


# Two different example flies in the low contrast period with different offset precision
example_fly_1 <- read.mat('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/example_data_1.mat')

dff_data <- as.data.frame(t(example_fly_1$dff_matrix))
names(dff_data) <- paste0("V", stringr::str_pad(1:42, width=2, pad=0))
dff_data <- dff_data %>% mutate(time = 1:n()) %>% 
  pivot_longer(cols = -time)

p1 <- ggplot(dff_data,aes(time, name, fill=value)) +
  geom_tile()

visual_stim = as.data.frame(example_fly_1$visual_stim)
names(visual_stim) <- NULL

p2 <- ggplot(visual_stim,aes(seq(1,dim(visual_stim)[1]),visual_stim)) +
  geom_line()


p <- plot_grid(p1,p2,ncol = 1)


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
  scale_y_continuous(name="Bump magntiude (DF/F)", limits=c(0, 3)) 

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
# now add the title
title <- ggdraw() + 
  draw_label(
    "Low contrast",
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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="Bump_pars_offset_precision.svg",device = 'svg', width=11, height=10)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig4", file="Bump_pars_offset_precision.png",device = 'png', width=11, height=10)


#as correlation (to get the coefficient)
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_mag,method = "pearson")
cor.test(initial_low_contrast$offset_precision,initial_low_contrast$mean_bump_width,method = "pearson")


