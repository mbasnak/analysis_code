## Code to plot all figures and do all statistical analyses for the Figure 1 of the paper

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)

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
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset_precision,aes(contrast,mean_offset_precision,group = 1),color = 'gray0',size=1.5) +
  geom_errorbar(data=mean_and_sd_offset_precision, mapping=aes(x=contrast, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=1.5, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="offset_precision_cl.svg",device = 'svg', width=6, height=4)

#different representation
ggplot() + 
  geom_violin(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision)) +
  stat_summary(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.2, color="black") +
  geom_line(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision, group = Fly),color = 'gray30',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision),color='gray30') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))


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
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_mag,group = 1),color = '#14BDFA',size=1.5) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=1.5, color="#14BDFA") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump magnitude (DF/F)") 

p2 <- ggplot() + 
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_width,group = 1),color = '#FAAF0F',size=1.5) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=1.5, color="#FAAF0F") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 


p <- plot_grid(p1, p2)
p
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="bump_pars_brightness_no_mvt.svg",device = 'svg', width=8, height=4)


## different representation
p1 <- ggplot() + 
  geom_violin(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag)) +
  stat_summary(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag),fun.y=mean, geom="crossbar", size=1, , width=0.2, color="black") +
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag, group = Fly),color = 'gray30',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag),color='gray30') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump amplitude (DF/F)") 


p2 <- ggplot() + 
  geom_violin(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width)) +
  stat_summary(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width),fun.y=mean, geom="crossbar", size=1, , width=0.2, color="black") +
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width, group = Fly),color = 'gray30',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width),color='gray30') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 

p <- p1 + p2
p




#model comparison (without including movement)
mdl_BM <- lmer(BumpMagnitude ~ ContrastLevel + (1|Fly), bump_pars_data)
summary(mdl_BM)
summary(glht(mdl_BM, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))

mdl_BW <- lmer(BumpWidth ~ ContrastLevel + (1|Fly), bump_pars_data)
summary(mdl_BW)
summary(glht(mdl_BW, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))


#using the mean data
mdl_BM <- lmer( mean_bump_mag ~ ContrastLevel + (1|Fly), grouped_bump_pars_data)
summary(mdl_BM)
summary(glht(mdl_BM, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))

mdl_BW <- lmer( mean_bump_width ~ ContrastLevel + (1|Fly), grouped_bump_pars_data)
summary(mdl_BW)
summary(glht(mdl_BW, linfct = mcp(ContrastLevel = "Tukey"), test = adjusted("bonferroni")))



#example fly
example_fly <- read.mat('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/example_fly_fig1.mat')

dff_data <- as.data.frame(t(example_fly$dff_matrix))
names(dff_data) <- paste0("V", stringr::str_pad(1:41, width=2, pad=0))
dff_data <- dff_data %>% mutate(time = 1:n()) %>% 
  pivot_longer(cols = -time)

p1 <- ggplot(dff_data,aes(time, name, fill=value)) +
  geom_raster() +
  scale_fill_gradient(low = "white", high = "black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        #axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.text.y=element_blank(), #remove y axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks,
        axis.ticks.y=element_blank(), #remove x axis ticks,
        axis.line.y = element_line(size=1)) +
  labs(x="", y="EPG activity (DF/F)") 

visual_stim <- as.data.frame(cbind(example_fly$visual_stim_to_plot,example_fly$x_out_heading))
colnames(visual_stim) <- c('visual_stim','time')

phase <- as.data.frame(cbind(example_fly$phase_to_plot,example_fly$x_out_phase))
colnames(phase) <- c('phase','time')

offset <- as.data.frame(cbind(example_fly$offset_to_plot,example_fly$x_out_offset))
colnames(offset) <- c('offset','time')

p2 <- ggplot() +
  geom_path(data=visual_stim,aes(time,visual_stim),color="chartreuse3") +
  geom_path(data=phase,aes(time, phase), color="mediumpurple") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.line.y = element_line(size=1)) +
  labs(x="", y="Angular pos (deg)") 

offset_low_contrast <- offset %>% slice(1:1690)
offset_high_contrast <- offset %>% slice(3311:4949)
offset_no_contrast <- offset %>% slice(1691:3310)

p3 <- ggplot() +
  geom_path(data = offset_no_contrast,aes(time,offset),color = 'gray0') +
  geom_path(data = offset_low_contrast,aes(time,offset),color = 'blue') +
  geom_path(data = offset_high_contrast,aes(time,offset),color = 'dodgerblue') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks,
        axis.line.y = element_line(size=1)) +
  labs(x="", y="Offset (deg)")

p <- p1/p2/p3
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="example_fly.svg",device = 'svg', width=10, height=4)




# combined plots for figure -----------------------------------------------

#example fly
p1 <- ggplot(dff_data,aes(time, name, fill=value)) +
  geom_raster() +
  scale_fill_gradient(low = "white", high = "black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=12),
        #axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.text.y=element_blank(), #remove y axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks,
        axis.ticks.y=element_blank(), #remove x axis ticks,
        axis.line.y = element_line(size=1),
        axis.title.y=element_text(angle=0)) +
  labs(x="", y="EPG activity (\u0394F/F)") 

p2 <- ggplot() +
  geom_path(data=visual_stim,aes(time,visual_stim),color="chartreuse3") +
  geom_path(data=phase,aes(time, phase), color="mediumpurple") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=12),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.line.y = element_line(size=1),
        axis.title.y=element_text(angle=0)) +
  labs(x="", y="Angular pos (deg)") 

p3 <- ggplot() +
  geom_path(data = offset_no_contrast,aes(time,offset),color = 'gray0') +
  geom_path(data = offset_low_contrast,aes(time,offset),color = 'blue') +
  geom_path(data = offset_high_contrast,aes(time,offset),color = 'dodgerblue') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=12),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks,
        axis.line.y = element_line(size=1),
        axis.title.y=element_text(angle=0)) +
  labs(x="", y="Offset (deg)")



#HD encoding reliability
p4 <- ggplot() + 
  geom_line(grouped_offset_precision_data, mapping = aes(contrast, mean_offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset_precision,aes(contrast,mean_offset_precision,group = 1),color = 'gray0',size=1.5) +
  geom_errorbar(data=mean_and_sd_offset_precision, mapping=aes(x=contrast, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=1.5, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

#Bump parameters
p5 <- ggplot() + 
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_mag, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_mag,group = 1),color = '#14BDFA',size=1.5) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=1.5, color="#14BDFA") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump amplitude (\u0394F/F)") 

p6 <- ggplot() + 
  geom_line(grouped_bump_pars_data, mapping = aes(ContrastLevel, mean_bump_width, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_pars_data,aes(ContrastLevel,mean_bump_width,group = 1),color = '#FAAF0F',size=1.5) +
  geom_errorbar(data=mean_and_sd_bump_pars_data, mapping=aes(x=ContrastLevel, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=1.5, color="#FAAF0F") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)") 

row_1 <- (p1/ plot_spacer() / p2 / plot_spacer() / p3)
row_2 <- (p4 + p6 + p5) 
full_plot <- row_1 / row_2 + plot_layout(heights = c(4,-2.5,4,-2.5,4,12))
row_2 + plot_annotation(tag_levels = list(c('E','F','G')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig1", file="bottom_part.svg",device = 'svg', width=12, height=4)
