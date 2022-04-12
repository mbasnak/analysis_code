library(ggplot2)
library(nlme)
library(multcomp)
library(tidyverse)
library(cowplot)

setwd('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Offset_control/data')


## analyze offset precision
offset_precision_data <- read.csv('offset_precision_data.csv')
offset_precision_data <-
  offset_precision_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "bar",
              block == 2 ~ "wind",
              block == 3 ~ "empty"), 
    levels = c("empty","bar","wind"))
  )

#run model
mdl_offset_precision <- lme(offset_precision ~ block,random=~1|fly, offset_precision_data)
summary(mdl_offset_precision)
summary(glht(mdl_offset_precision, linfct = mcp(block = "Tukey")), test = adjusted("bonferroni"))



## analyze bump parameters
bump_pars_data <- read.csv('bump_pars_data.csv')
bump_pars_data <-
  bump_pars_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "bar",
              block == 2 ~ "wind",
              block == 3 ~ "empty"), 
    levels = c("empty","bar","wind"))
  )

#run models
mdl_bump_mag <- lme(bump_mag ~ block,random=~1|fly, bump_pars_data)
summary(mdl_bump_mag)
summary(glht(mdl_bump_mag, linfct = mcp(block = "Tukey")), test = adjusted("bonferroni"))

mdl_bump_width <- lme(bump_width ~ block,random=~1|fly, bump_pars_data)
summary(mdl_bump_width)
summary(glht(mdl_bump_width, linfct = mcp(block = "Tukey")), test = adjusted("bonferroni"))



## Include rotational speed in the analysis
all_data <- read.csv('all_data.csv')
all_data <-
  all_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "empty",
              block == 2 ~ "wind",
              block == 3 ~ "bar"), 
    levels = c("empty","bar","wind"))
  )

p1 <- ggplot(all_data,aes(yaw_speed,bump_mag,group_by = block,color=block)) +
  geom_smooth() +
  scale_color_manual(values = c("black", "red", "blue"))

p2 <- ggplot(all_data,aes(yaw_speed,bump_width,group_by = block,color=block)) +
  geom_smooth() +
  scale_color_manual(values = c("black", "red", "blue"))

p <- plot_grid(p1, p2)
p



## repeat analysis for individual flies
for (fly in 1:10) {
  
  fly_data <- all_data %>% filter(Fly == fly)
  
  p1 <- ggplot(fly_data,aes(yaw_speed,bump_mag,group_by = block,color=block)) +
    geom_smooth() +
    scale_color_manual(values = c("black", "red", "blue"))
  
  p2 <- ggplot(fly_data,aes(yaw_speed,bump_width,group_by = block,color=block)) +
    geom_smooth() +
    scale_color_manual(values = c("black", "red", "blue"))
  
  p <- plot_grid(p1, p2)
  print(p)

}


## run models
mdl_bump_mag_yaw_speed <- lme(bump_mag ~ yaw_speed*block,random=~1|Fly, all_data)
summary(mdl_bump_mag_yaw_speed)
summary(glht(mdl_bump_mag_yaw_speed, linfct = mcp(block = "Tukey",interaction_average = TRUE,covariate_average = TRUE)), test = adjusted("bonferroni"))

mdl_bump_width_yaw_speed <- lme(bump_width ~ yaw_speed*block,random=~1|Fly, all_data)
summary(mdl_bump_width_yaw_speed)
summary(glht(mdl_bump_width_yaw_speed, linfct = mcp(block = "Tukey",interaction_average = TRUE,covariate_average = TRUE)), test = adjusted("bonferroni"))
