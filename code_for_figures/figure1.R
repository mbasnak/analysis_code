## Code to plot all figures and do all statistical analyses for the Figure 1 of the paper

#load useful libraries
library(nlme)
library(lme4)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)

#1) offset precision in cue brightness experiment
#load data
offset_precision_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/offset_and_heading_data.csv")
offset_precision_data <-
  offset_precision_data %>% 
  mutate(contrast = factor(
    case_when(contrast == "Darkness" ~ "No contrast",
              contrast == "Low contrast" ~ "Low contrast",
              contrast == "High contrast" ~ "High contrast"), 
    levels = c("No contrast", "Low contrast", "High contrast"))
  )


#group data for plots and analyses
grouped_offset_precision_data <- offset_precision_data %>%
  group_by(Fly,contrast) %>% 
  summarise(mean_offset_precision = mean(offset_precision))


#Offset precision model
mdl_offset_precision <- lme(mean_offset_precision ~ contrast ,random=~1|Fly, grouped_offset_precision_data)
summary(mdl_offset_precision)
summary(glht(mdl_offset_precision, linfct = mcp(contrast = "Tukey")), test = adjusted("bonferroni"))


#plot
#1) get mean and sd
mean_and_sd_offset_precision <- grouped_offset_precision_data %>%
  group_by(contrast) %>% 
  summarise(sd_offset_precision = sd(mean_offset_precision),
            mean_offset_precision = mean(mean_offset_precision),
            n = n())
#2) plot
ggplot() + 
  geom_line(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_offset_precision,aes(contrast,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_precision, mapping=aes(x=contrast, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="offset_precision_cl.svg",device = 'svg', width=6, height=4)



#bump pars in cue brightness experiment

# Read data
bump_pars_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/allModelData.csv")
bump_pars_data <-
  bump_pars_data %>% 
  mutate(ContrastLevel = factor(
    case_when(ContrastLevel == 1L ~ "No contrast",
              ContrastLevel == 2L ~ "Low contrast",
              ContrastLevel == 3L ~ "High contrast"), 
    levels = c("No contrast", "Low contrast", "High contrast"))
  )


## filter by goodness of fit
bump_pars_data <- bump_pars_data %>% filter(AdjRSquare > 0.5, Moving == 1)

## convert bump width data to degrees
bump_pars_data$BumpWidth <- rad2deg(bump_pars_data$BumpWidth)

grouped_bump_pars_data <- bump_pars_data %>%
  group_by(Fly,ContrastLevel) %>% 
  summarise(mean_bump_mag = mean(BumpMagnitude),mean_bump_width = mean(BumpWidth))


mean_and_sd_bump_pars_data <- grouped_bump_pars_data %>%
  group_by(ContrastLevel) %>% 
  summarise(sd_bump_mag = sd(mean_bump_mag),
            mean_bump_mag = mean(mean_bump_mag),
            sd_bump_width = sd(mean_bump_width),
            mean_bump_width = mean(mean_bump_width),
            n = n())
#2) plot
p1 <- ggplot() + 
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_mag,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude (DF/F)") 

p2 <- ggplot() + 
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_width,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 


p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="bump_pars_brightness_no_mvt.svg",device = 'svg', width=12, height=8)


#model comparison (without including movement, like in plot)
mdl_BM <- lmer(BumpMagnitude ~ ContrastLevel + (1|Fly), bump_pars_data)
summary(mdl_BM)
summary(glht(mdl_BM, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))

mdl_BW <- lmer(BumpWidth ~ ContrastLevel + (1|Fly), bump_pars_data)
summary(mdl_BW)
summary(glht(mdl_BW, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))

