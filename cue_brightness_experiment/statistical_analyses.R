### statistical analysis for cue brightness experiment ###

#load useful libraries
library(nlme)
library(lme4)
library(multcomp)
library(ggplot2)
library(gridExtra)
library(tidyverse)
library(cowplot)
library(performance)

#set working directory
setwd("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts")


######### I - Closed-loop bout ##########

#### 1) offset and heading

offset_and_heading_data_closed_loop <- read.csv("offset_and_heading_data.csv")
offset_and_heading_data_closed_loop <-
  offset_and_heading_data_closed_loop %>% 
  mutate(contrast = factor(
    case_when(contrast == "Darkness" ~ "Darkness",
              contrast == "Low contrast" ~ "Low brightness",
              contrast == "High contrast" ~ "High brightness"), 
    levels = c("Darkness", "Low brightness", "High brightness"))
  )


#group data for plots and analyses
grouped_offset_and_heading_cl <- offset_and_heading_data_closed_loop %>%
  group_by(Fly,contrast) %>% 
  summarise(mean_offset_precision = mean(offset_precision),mean_heading_precision = mean(heading_precision))


#Offset precision model
mdl_offset_precision <- lme(mean_offset_precision ~ contrast ,random=~1|Fly, grouped_offset_and_heading_cl)
summary(mdl_offset_precision)
summary(glht(mdl_offset_precision, linfct = mcp(contrast = "Tukey")), test = adjusted("bonferroni"))

#Heading precision model
mdl_heading_precision <- lme(mean_heading_precision ~ contrast ,random=~1|Fly, grouped_offset_and_heading_cl)
summary(mdl_heading_precision)
summary(glht(mdl_heading_precision, linfct = mcp(contrast = "Tukey")), test = adjusted("bonferroni"))


#Plot offset precision

#1) get mean and sd
mean_and_sd_offset_cl <- grouped_offset_and_heading_cl %>%
  group_by(contrast) %>% 
  summarise(sd_offset_precision = sd(mean_offset_precision),
            mean_offset_precision = mean(mean_offset_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(grouped_offset_and_heading_cl, mapping = aes(contrast, mean_offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_offset_cl,aes(contrast,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_cl, mapping=aes(x=contrast, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Offset Precision")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="offset_precision_cl.svg",device = 'svg', width=6, height=4)


#Plot heading precision
#1) get mean and sd
mean_and_sd_heading_cl <- grouped_offset_and_heading_cl %>%
  group_by(contrast) %>% 
  summarise(sd_heading_precision = sd(mean_heading_precision),
            mean_heading_precision = mean(mean_heading_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(grouped_offset_and_heading_cl, mapping = aes(contrast, mean_heading_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_heading_cl,aes(contrast,mean_heading_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_heading_cl, mapping=aes(x=contrast, ymin=mean_heading_precision + sd_heading_precision/sqrt(n), ymax=mean_heading_precision - sd_heading_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Heading Precision")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="heading_precision_cl.svg",device = 'svg', width=6, height=4)


#### 2) Bump parameters

# Read data
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
all_model_data_closed_loop <- all_model_data_closed_loop %>% filter(AdjRSquare > 0.45)

# 1) Bump magnitude model

#Test different models
mdl_BM1 <- lmer(BumpMagnitude ~ ContrastLevel * TotalMovement + (1|Fly), all_model_data_closed_loop)
mdl_BM2 <- lmer(BumpMagnitude ~ ContrastLevel * YawSpeed + (1|Fly), all_model_data_closed_loop)
mdl_BM3 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + (1|Fly), all_model_data_closed_loop)
mdl_BM4 <- lmer(BumpMagnitude ~ ContrastLevel * Moving + TotalMovement +(1|Fly), all_model_data_closed_loop)
mdl_BM5 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement +(1|Fly), all_model_data_closed_loop)
mdl_BM6 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement + YawSpeed +(1|Fly), all_model_data_closed_loop)
mdl_BM7 <- lmer(BumpMagnitude ~ ContrastLevel + Moving + TotalMovement + YawSpeed + ForVelocity +(1|Fly), all_model_data_closed_loop)
mdl_BM8 <- lmer(BumpMagnitude ~ ContrastLevel * TotalMovement + Moving +(1|Fly), all_model_data_closed_loop)

#Compare performance
compare_performance(mdl_BM1,mdl_BM2,mdl_BM3,mdl_BM4,mdl_BM5,mdl_BM6,mdl_BM7,mdl_BM8,rank = TRUE)

summary(glht(mdl_BM8, linfct = mcp(ContrastLevel = "Tukey", interaction_average = TRUE, covariate_average = TRUE)), test = adjusted("bonferroni"))


#mdl_BM_int <- lme(BumpMagnitude ~ ContrastLevel * TotalMovement,random=~1|Fly, all_model_data_closed_loop)
mdl_BM_int <- lmer(BumpMagnitude ~ ContrastLevel * TotalMovement + (1|Fly), all_model_data_closed_loop)
summary(mdl_BM_int)
summary(glht(mdl_BM_int, linfct = mcp(ContrastLevel = "Tukey", interaction_average = TRUE, covariate_average = TRUE)), test = adjusted("bonferroni"))


# 2) Bump width model
mdl_BW_int <- lme(BumpWidth ~ ContrastLevel * TotalMovement,random=~1|Fly, all_model_data_closed_loop)
summary(mdl_BW_int)
summary(glht(mdl_BW_int, linfct = mcp(ContrastLevel = "Tukey", interaction_average = TRUE, covariate_average = TRUE)), test = adjusted("bonferroni"))


## Plot bump magnitude and bump width
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
  xlim(0,200),
  coord_cartesian(ylim = c(-0.8,0.8))
  )
  
p1 <- ggplot(all_model_data_closed_loop, aes(TotalMovement, zscoredBM , 
                                             colour = ContrastLevel))+ 
  fig1_theme+
  geom_smooth(aes(fill=ContrastLevel), alpha=0.1)+ 
  labs(x = 'Total fly movement (deg/s)', y='Mean zscored bump magnitude', color = '',fill = '')

p2 <- ggplot(all_model_data_closed_loop, aes(TotalMovement, zscoredBW , colour = ContrastLevel)) + 
  fig1_theme +
  geom_smooth(aes(fill=ContrastLevel), alpha=0.1) +
  labs(x = 'Total fly movement (deg/s)', y='Mean zscored bump width', color = '',fill = '')

p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="bump_pars_mvt_brightness.svg",device = 'svg', width=12, height=8)




## Ommitting movement from the plot
all_model_data_cl <- all_model_data_closed_loop %>% filter(AdjRSquare > 0.45, Moving == 1)

grouped_bump_pars_cl <- all_model_data_cl %>%
  group_by(Fly,ContrastLevel) %>% 
  summarise(mean_bump_mag = mean(BumpMagnitude),mean_bump_width = mean(BumpWidth))


mean_and_sd_bump_pars_cl <- grouped_bump_pars_cl %>%
  group_by(ContrastLevel) %>% 
  summarise(sd_bump_mag = sd(mean_bump_mag),
            mean_bump_mag = mean(mean_bump_mag),
            sd_bump_width = sd(mean_bump_width),
            mean_bump_width = mean(mean_bump_width),
            n = n())
#2) plot
p1 <- ggplot() + 
  geom_line(grouped_bump_pars_cl, mapping = aes(ContrastLevel, mean_bump_mag, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_cl,aes(ContrastLevel,mean_bump_mag,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_cl, mapping=aes(x=ContrastLevel, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude") 

p2 <- ggplot() + 
  geom_line(grouped_bump_pars_cl, mapping = aes(ContrastLevel, mean_bump_width, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_cl,aes(ContrastLevel,mean_bump_width,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_cl, mapping=aes(x=ContrastLevel, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width") 


p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="bump_pars_brightness_no_mvt.svg",device = 'svg', width=12, height=8)

#model comparison (without including movement, like here)
mdl_BM <- lmer(BumpMagnitude ~ ContrastLevel + (1|Fly), all_model_data_cl)
summary(mdl_BM)
summary(glht(mdl_BM, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))

mdl_BW <- lmer(BumpWidth ~ ContrastLevel + (1|Fly), all_model_data_cl)
summary(mdl_BW)
summary(glht(mdl_BW, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))




######### II - Open-loop bout ##########


#### 1) offset precision

offset_data_open_loop <- read.csv("offset_data_ol.csv")
#Replace '56' and '57' by brightness levels
offset_data_open_loop$contrast_level[offset_data_open_loop$contrast_level == 56] <- 'Low brightness'
offset_data_open_loop$contrast_level[offset_data_open_loop$contrast_level == 57] <- 'High brightness'
#reorder them
offset_data_open_loop$contrast_level <- factor(offset_data_open_loop$contrast_level,
                                                       levels = c("Low brightness", "High brightness"))


#group data for plots and analyses
grouped_offset_ol <- offset_data_open_loop %>%
  group_by(Fly,contrast_level) %>% 
  summarise(mean_offset_precision = mean(stim_offset_precision))

#Offset precision model
mdl_offset_precision_ol <- lme(stim_offset_precision ~ contrast_level ,random=~1|Fly, offset_data_open_loop)
summary(mdl_offset_precision_ol)
summary(glht(mdl_offset_precision_ol, linfct = mcp(contrast_level = "Tukey")), test = adjusted("bonferroni"))
#use Wilcoxon test instead


#Plot offset precision
#1) get mean and sd
mean_and_sd_offset_ol <- grouped_offset_ol %>%
  group_by(contrast_level) %>% 
  summarise(sd_offset_precision = sd(mean_offset_precision),
            mean_offset_precision = mean(mean_offset_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(grouped_offset_ol, mapping = aes(contrast_level, mean_offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=13), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset_ol,aes(contrast_level,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_ol, mapping=aes(x=contrast_level, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  labs(x="", y="Offset Precision")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="offset_precision_ol.svg",device = 'svg', width=6, height=6)



#### 2) Bump parameters

# Read data
all_model_data_open_loop <- read.csv("all_bump_par_data_open_loop.csv")
all_model_data_open_loop$brightness[all_model_data_open_loop$brightness == 56] <- 'Low brightness'
all_model_data_open_loop$brightness[all_model_data_open_loop$brightness == 57] <- 'High brightness'

#filter by goodness of fit
all_model_data_open_loop <- all_model_data_open_loop %>% filter(adj_rs > 0.5)

#Plot bump pars vs mvt, parsed by brightness
fig1_ol_theme <-  
  list(
    theme(legend.position=c(0.70, 0.15),
          legend.background = element_rect(color=NA, fill=NA),
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=22),axis.text = element_text(size = 20)),
    scale_color_manual(values=c('dodgerblue1','blue')),
    scale_fill_manual(values=c('dodgerblue1','blue')),
    xlim(0,200),
    coord_cartesian(ylim = c(-0.8,0.8))
  )

p1 <- ggplot(all_model_data_open_loop, aes(total_mvt, zscored_bump_mag , 
                                             colour = brightness))+ 
  fig1_ol_theme+
  geom_smooth(aes(fill=brightness), alpha=0.1)+ 
  labs(x = 'Total fly movement (deg/s)', y='Mean bump magnitude', color = '',fill = '')

p2 <- ggplot(all_model_data_open_loop, aes(total_mvt, zscored_bump_width , colour = brightness)) + 
  fig1_ol_theme +
  geom_smooth(aes(fill=brightness), alpha=0.1) +
  labs(x = 'Total fly movement (deg/s)', y='Mean bump width', color = '',fill = '')

p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="bump_pars_mvt_brightness_ol.svg",device = 'svg', width=12, height=8)


#Plot without movement
#group data for plots and analyses

all_model_data_open_loop_thresh <- all_model_data_open_loop %>% filter(total_mvt >25)

grouped_bump_pars_ol <- all_model_data_open_loop_thresh %>%
  group_by(Fly,brightness) %>% 
  summarise(mean_bump_mag = mean(bump_mag),mean_bump_width = mean(bump_width))

#1) get mean and sd
mean_and_sd_bump_pars_ol <- grouped_bump_pars_ol %>%
  group_by(brightness) %>% 
  summarise(sd_bump_mag = sd(mean_bump_mag),
            sd_bump_width = sd(mean_bump_width),
            mean_bump_mag = mean(mean_bump_mag),
            mean_bump_width = mean(mean_bump_width),
            n = n())
#2) plot
p1 <- ggplot() + 
  geom_line(grouped_bump_pars_ol, mapping = aes(brightness, mean_bump_mag, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=13), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_ol,aes(brightness,mean_bump_mag,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_ol, mapping=aes(x=brightness, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="gray0") +
  labs(x="", y="Bump magnitude")+
  ylim(c(0,2.5))

p2 <- ggplot() + 
  geom_line(grouped_bump_pars_ol, mapping = aes(brightness, mean_bump_width, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=13), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_ol,aes(brightness,mean_bump_width,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_ol, mapping=aes(x=brightness, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="gray0") +
  labs(x="", y="Bump width")+
  ylim(c(0,2.5))

p <- plot_grid(p1, p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/CueBrightness-Experiment", file="mean_bump_pars_ol.svg",device = 'svg', width=12, height=8)


# Bump magnitude model
mdl_BM_int_ol <- lmer(bump_mag ~ brightness * total_mvt + (1|Fly), all_model_data_open_loop, na.action=na.omit)
summary(mdl_BM_int_ol)
summary(glht(mdl_BM_int_ol, linfct = mcp(brightness = "Tukey", interaction_average = TRUE, covariate_average = TRUE)), test = adjusted("bonferroni"))

# Bump width model
mdl_BW_int_ol <- lmer(bump_width ~ brightness * total_mvt + (1|Fly), all_model_data_open_loop, na.action=na.omit)
summary(mdl_BW_int_ol)
summary(glht(mdl_BW_int_ol, linfct = mcp(brightness = "Tukey", interaction_average = TRUE, covariate_average = TRUE)), test = adjusted("bonferroni"))
