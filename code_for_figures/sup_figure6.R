#code for sup figure 6

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)

#more granular plot for offset precision vs block type
offset_precision_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability//offset_precision_data.csv", header = FALSE)
colnames(offset_precision_data) <- c('initial_first_cue','initial_second_cue','cue_combination','final_first_cue','final_second_cue','fly')
offset_precision_data <- gather(offset_precision_data, key = "block_type", value = "offset_precision",-fly)
offset_precision_data$block_type = as.factor(offset_precision_data$block_type)
offset_precision_data$fly = as.factor(offset_precision_data$fly)

#run model
offset_precision_model <- lme(offset_precision ~ block_type , random=~1|fly, offset_precision_data)
summary(offset_precision_model)
anova(offset_precision_model)
#posthoc comparisons
summary(glht(offset_precision_model, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))

offset_precision_data <-
  offset_precision_data %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_first_cue" ~ "Initial first cue",
              block_type == "final_first_cue" ~ "Final first cue",
              block_type == "initial_second_cue" ~ "Initial second cue",
              block_type == "final_second_cue" ~ "Final second cue",
              block_type == "cue_combination" ~ "Cue combination"), 
    levels = c("Initial first cue","Initial second cue", "Cue combination", "Final first cue","Final second cue"))
  )

#get mean and sd
mean_and_sd_offset_precision <- offset_precision_data %>%
  group_by(block_type) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())
#plot
ggplot() + 
  geom_line(offset_precision_data, mapping = aes(block_type, offset_precision, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset_precision,aes(block_type,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_precision, mapping=aes(x=block_type, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig6", file="offset_precision_per_block.svg",device = 'svg', width=8, height=6)



#more granular plot for bump pars vs block type
#load data
bump_mag_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_mag_data.csv", header = FALSE)
colnames(bump_mag_data) <- c('initial_first_cue','initial_second_cue','cue_combination','final_first_cue','final_second_cue','fly')
bump_mag_data <- gather(bump_mag_data, key = "block_type", value = "bump_mag",-fly)
bump_mag_data$block_type = as.factor(bump_mag_data$block_type)
bump_mag_data$fly = as.factor(bump_mag_data$fly)

#run model
bump_mag_model <- lme(bump_mag ~ block_type , random=~1|fly, bump_mag_data)
summary(bump_mag_model)
anova(bump_mag_model)
#posthoc comparisons
summary(glht(bump_mag_model, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))


bump_width_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_width_data.csv", header = FALSE)
colnames(bump_width_data) <- c('initial_first_cue','initial_second_cue','cue_combination','final_first_cue','final_second_cue','fly')
bump_width_data <- gather(bump_width_data, key = "block_type", value = "bump_width",-fly)
bump_width_data$block_type = as.factor(bump_width_data$block_type)
bump_width_data$fly = as.factor(bump_width_data$fly)
bump_width_data$bump_width = rad2deg(bump_width_data$bump_width)

#run model
bump_width_model <- lme(bump_width ~ block_type , random=~1|fly, bump_width_data)
summary(bump_width_model)
anova(bump_width_model)
#posthoc comparisons
summary(glht(bump_width_model, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))


#plot
bump_mag_data <-
  bump_mag_data %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_first_cue" ~ "Initial first cue",
              block_type == "final_first_cue" ~ "Final first cue",
              block_type == "initial_second_cue" ~ "Initial second cue",
              block_type == "final_second_cue" ~ "Final second cue",
              block_type == "cue_combination" ~ "Cue combination"), 
    levels = c("Initial first cue","Initial second cue", "Cue combination", "Final first cue","Final second cue"))
  )

bump_width_data <-
  bump_width_data %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_first_cue" ~ "Initial first cue",
              block_type == "final_first_cue" ~ "Final first cue",
              block_type == "initial_second_cue" ~ "Initial second cue",
              block_type == "final_second_cue" ~ "Final second cue",
              block_type == "cue_combination" ~ "Cue combination"), 
    levels = c("Initial first cue","Initial second cue", "Cue combination", "Final first cue","Final second cue"))
  )

#get mean and sd
mean_and_sd_bump_mag <- bump_mag_data %>%
  group_by(block_type) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            n = n())

mean_and_sd_bump_width <- bump_width_data %>%
  group_by(block_type) %>% 
  summarise(sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())

#plot
p1 <- ggplot() + 
  geom_line(bump_mag_data, mapping = aes(block_type, bump_mag, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_mag,aes(block_type,mean_bump_mag,group = 1),color = '#14BDFA',size=2) +
  geom_errorbar(data=mean_and_sd_bump_mag, mapping=aes(x=block_type, ymin=mean_bump_mag + sd_bump_mag/sqrt(n), ymax=mean_bump_mag - sd_bump_mag/sqrt(n)), width=0, size=2, color='#14BDFA') +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump mag (DF/F)")

p2 <- ggplot() + 
  geom_line(bump_width_data, mapping = aes(block_type, bump_width, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_bump_width,aes(block_type,mean_bump_width,group = 1),color = '#FAAF0F',size=2) +
  geom_errorbar(data=mean_and_sd_bump_width, mapping=aes(x=block_type, ymin=mean_bump_width + sd_bump_width/sqrt(n), ymax=mean_bump_width - sd_bump_width/sqrt(n)), width=0, size=2, color='#FAAF0F') +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (deg)")


p <- plot_grid(p1,p2)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig6", file="bump_pars_per_block.svg",device = 'svg', width=8, height=6)

