
#set working directory
setwd("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts")

#load useful libraries
library(tidyverse)
library(lme4)
library(performance)
library(ggplot2)
library(cowplot)

#load data
model_data <- read.csv("all_movement_model_data.csv")

#filter by gof
model_data <- model_data %>% filter(gof > 0.4)


#change brightness value to factor
model_data$brightness <- as.factor(model_data$brightness)

#run different model versions
#Test different models
mdl_BM1 <- lmer(bump_mag ~ brightness * total_movement + (1|fly), model_data)
mdl_BM2 <- lmer(bump_mag ~ brightness * yaw_speed + (1|fly), model_data)
mdl_BM3 <- lmer(bump_mag ~ brightness * moving + (1|fly), model_data)
mdl_BM4 <- lmer(bump_mag ~ brightness * moving + total_movement +(1|fly), model_data)
mdl_BM5 <- lmer(bump_mag ~ brightness + moving + total_movement +(1|fly), model_data)
mdl_BM6 <- lmer(bump_mag ~ brightness + moving + total_movement + yaw_speed +(1|fly), model_data)
mdl_BM7 <- lmer(bump_mag ~ brightness + moving + total_movement + yaw_speed + for_vel +(1|fly), model_data)
mdl_BM8 <- lmer(bump_mag ~ brightness * moving + yaw_speed +(1|fly), model_data)
mdl_BM9 <- lmer(bump_mag ~ brightness * moving + yaw_speed + for_vel + (1|fly), model_data)
mdl_BM10 <- lmer(bump_mag ~ brightness + moving + yaw_speed + (1|fly), model_data)

#Compare performance
compare_performance(mdl_BM1,mdl_BM2,mdl_BM3,mdl_BM4,mdl_BM5,mdl_BM6,mdl_BM7,mdl_BM8,mdl_BM9,mdl_BM10,rank = TRUE)


#plot bump pars as a function of total movement
fig1_theme <-  
  list(
    theme(legend.position=c(0.70, 0.15),
          legend.background = element_rect(color=NA, fill=NA),
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=22),axis.text = element_text(size = 20)),
    scale_color_manual(values=c('gray0','blue','dodgerblue1')),
    scale_fill_manual(values=c('gray0','blue','dodgerblue1')),
    xlim(0,200)
  )

p1 <- ggplot(model_data, aes(total_movement, zbump_mag , group = brightness, colour = brightness))+ 
  fig1_theme+
  geom_smooth(aes(fill=brightness), alpha=0.1)+ 
  labs(x = 'Total fly movement (deg/s)', y='Mean bump magnitude', color = '',fill = '')

p2 <- ggplot(model_data, aes(total_movement, zbump_width , colour = brightness )) + 
  fig1_theme +
  geom_smooth(aes(fill=brightness), alpha=0.1) +
  labs(x = 'Total fly movement (deg/s)', y='Mean bump width', color = '',fill = '')

p <- plot_grid(p1, p2)
p






######### With current data smoothing method

all_model_data_closed_loop <- read.csv("allModelData.csv")
all_model_data_closed_loop <-
  all_model_data_closed_loop %>% 
  mutate(ContrastLevel = factor(
    case_when(ContrastLevel == 1L ~ "Darkness",
              ContrastLevel == 2L ~ "Low brightness",
              ContrastLevel == 3L ~ "High brightness"), 
    levels = c("Darkness", "Low brightness", "High brightness"))
  )

#filter by goodness of fit
all_model_data_closed_loop <- all_model_data_closed_loop %>% filter(AdjRSquare > 0.4)


#run different model versions
#Test different models
mdl_BM1 <- lmer(BumpMagnitude ~ ContrastLevel * TotalMovement + (1|Fly), all_model_data_closed_loop)
mdl_BM2 <- lmer(BumpMagnitude ~ ContrastLevel * YawSpeed + (1|Fly), all_model_data_closed_loop)
mdl_BM3 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + (1|Fly), all_model_data_closed_loop)
mdl_BM4 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + TotalMovement +(1|Fly), all_model_data_closed_loop)
mdl_BM5 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement +(1|Fly), all_model_data_closed_loop)
mdl_BM6 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement + YawSpeed +(1|Fly), all_model_data_closed_loop)
mdl_BM7 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement + YawSpeed + ForVelocity +(1|Fly), all_model_data_closed_loop)
mdl_BM8 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + YawSpeed +(1|Fly), all_model_data_closed_loop)
mdl_BM9 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + YawSpeed + ForVelocity + (1|Fly), all_model_data_closed_loop)
mdl_BM10 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + YawSpeed + (1|Fly), all_model_data_closed_loop)

#Compare performance
compare_performance(mdl_BM1,mdl_BM2,mdl_BM3,mdl_BM4,mdl_BM5,mdl_BM6,mdl_BM7,mdl_BM8,mdl_BM9,mdl_BM10,rank = TRUE)


## Plot residuals
plot(mdl_BM4)
#it actually doesn't look terrible...
