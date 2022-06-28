library(ggplot2)
library(tidyverse)
library(patchwork)
library(circular)


#1) Bump amplitude
#load data
bump_mag_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_mag_data_3_blocks.csv", header = FALSE)
colnames(bump_mag_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
#compute change
change_bump_mag <- as.data.frame(bump_mag_data_3_blocks$cue_combination - bump_mag_data_3_blocks$initial_single_cue)

#2) Bump width
#load data
bump_width_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_width_data_3_blocks.csv", header = FALSE)
colnames(bump_width_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
#compute change
change_bump_width <- as.data.frame(rad2deg(bump_width_data_3_blocks$cue_combination - bump_width_data_3_blocks$initial_single_cue))

#3) Offset
#load data
initial_offset_difference <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/initial_cue_diff.csv", header = FALSE)
initial_offset_difference <- abs(initial_offset_difference)

#Combine data
all_data <- cbind(change_bump_width,change_bump_mag,initial_offset_difference)
colnames(all_data) <- c('change_bump_width','change_bump_mag','initial_offset_difference')

#plot the relationships
#1) Bump width change versus angular separation
p1 <- ggplot() + 
  geom_point(all_data, mapping = aes(initial_offset_difference, change_bump_width),color = 'gray0',size=2) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5))  +
  scale_x_continuous(limits = c(0, 180)) + 
  labs(x="Initial offset difference", y="Change in bump width") 

#2) Bump amplitude change versus angular separation
p2 <- ggplot() + 
  geom_point(all_data, mapping = aes(initial_offset_difference, change_bump_mag),color = 'gray0',size=2) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5))  +
  scale_x_continuous(limits = c(0, 180)) + 
  labs(x="Initial offset difference", y="Change in bump amplitude (\u0394F/F)") 

p1 + p2
