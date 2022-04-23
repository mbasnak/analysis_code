#code for figure 5

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(rCAT)
library(patchwork)

# 2-3 example flies for the inverted gain period (with both types of strategy)


# offset precision comparison IG and darkness
#1) Load data
empty_trial_comparison_offset_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/empty_trial_comparison_all_data.csv")
empty_trial_comparison_offset_data$Fly <- seq.int(nrow(empty_trial_comparison_offset_data)) 
#2) Reformat data frame
empty_trial_comparison_offset_data <- empty_trial_comparison_offset_data %>%
  pivot_longer(
    cols = contains("offset"),
    names_to = "trial",
    values_to = "offset_precision"
  )
#3) Rename factor levels
empty_trial_comparison_offset_data <-
  empty_trial_comparison_offset_data %>% 
  mutate(trial = factor(
    case_when(trial == "empty_trial_offset_precision" ~ "Darkness",
              trial == "initial_gain_change_offset_precision" ~ "Inverted gain (initial part)",
              trial == "final_gain_change_offset_precision" ~ "Inverted gain (final part)"), 
    levels = c("Darkness", "Inverted gain (initial part)", "Inverted gain (final part)"))
  )


#4) get mean and sd
mean_and_sd_offset <- empty_trial_comparison_offset_data %>%
  group_by(trial) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())
#5) plot
ggplot() + 
  geom_line(empty_trial_comparison_offset_data, mapping = aes(trial, offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset,aes(trial,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset, mapping=aes(x=trial, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="heading_offset_precision_comparison.svg",device = 'svg', width=6, height=6)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="heading_offset_precision_comparison.png",device = 'png', width=6, height=6)


# Run model
mdl_offset_precision_comparison <- lme(offset_precision ~ trial ,random=~1|Fly, empty_trial_comparison_offset_data)
summary(mdl_offset_precision_comparison)
anova(mdl_offset_precision_comparison)
summary(glht(mdl_offset_precision_comparison, linfct = mcp(trial = "Tukey")), test = adjusted("bonferroni"))





#### Repeat previous steps for heading precision

#1) Load data
empty_trial_comparison_heading_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/empty_trial_heading_comparison_all_data.csv")
empty_trial_comparison_heading_data$Fly <- seq.int(nrow(empty_trial_comparison_heading_data)) 
#2) Reformat data frame
empty_trial_comparison_heading_data <- empty_trial_comparison_heading_data %>%
  pivot_longer(
    cols = contains("heading"),
    names_to = "trial",
    values_to = "heading_precision"
  )
#3) Rename factor levels
empty_trial_comparison_heading_data <-
  empty_trial_comparison_heading_data %>% 
  mutate(trial = factor(
    case_when(trial == "empty_trial_heading_precision" ~ "Darkness",
              trial == "initial_gain_change_heading_precision" ~ "Inverted gain (initial part)",
              trial == "final_gain_change_heading_precision" ~ "Inverted gain (final part)"), 
    levels = c("Darkness", "Inverted gain (initial part)", "Inverted gain (final part)"))
  )


#4) get mean and sd
mean_and_sd_heading <- empty_trial_comparison_heading_data %>%
  group_by(trial) %>% 
  summarise(sd_heading_precision = sd(heading_precision),
            mean_heading_precision = mean(heading_precision),
            n = n())
#5) plot
ggplot() + 
  geom_line(empty_trial_comparison_heading_data, mapping = aes(trial, heading_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_heading,aes(trial,mean_heading_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_heading, mapping=aes(x=trial, ymin=mean_heading_precision + sd_heading_precision/sqrt(n), ymax=mean_heading_precision - sd_heading_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Heading precision")+
  ylim(c(0,1))


#) Run model
mdl_heading_precision_comparison <- lme(heading_precision ~ trial ,random=~1|Fly, empty_trial_comparison_heading_data)
summary(mdl_heading_precision_comparison)
anova(mdl_heading_precision_comparison)
summary(glht(mdl_heading_precision_comparison, linfct = mcp(trial = "Tukey")), test = adjusted("bonferroni"))




# relationship between learning and bump pars/offset precision in the NG bout
learning_data_diff <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/learning_data_diff.csv')

learning_data_diff$bump_width <- rad2deg(learning_data_diff$bump_width)


#run linear regression
summary(lm(offset_diff ~ bump_mag, learning_data_diff))
summary(lm(offset_diff ~ bump_width, learning_data_diff))
summary(lm(offset_diff ~ offset_precision, learning_data_diff))

#Plot
p1 <- ggplot(learning_data_diff,aes(offset_diff,bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red', linetype="dashed") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="Bump amplitude (DF/F)", limits=c(0.5,2.5)) 

p2 <- ggplot(learning_data_diff,aes(offset_diff,bump_width)) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="Bump width (deg)" , limits=c(70,140)) 

p3 <- ggplot(learning_data_diff,aes(offset_diff,offset_precision)) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="HD encoding realiability", limits=c(0, 1))

p <- plot_grid(p1, p2, p3,ncol = 3)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="learning_prediction_diff.svg",device = 'svg', width=11, height=6)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="learning_prediction_diff.png",device = 'png', width=11, height=6)





# plot comparison the metric (whether ratio or diff) at the beginning and end of the IG period

hb_offset_diff_evo <- read_csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/hb_offset_diff_evo.csv')

#3) Rename factor levels
hb_offset_diff_evo <-
  hb_offset_diff_evo %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "Initial part",
              block == 2 ~ "Final part"), 
    levels = c("Initial part","Final part"))
  )

# get mean and sd
mean_and_sd_offset_diff <- hb_offset_diff_evo %>%
  group_by(block) %>% 
  summarise(sd_offset_diff = sd(offset_diff),
            mean_offset_diff = mean(offset_diff),
            n = n())
# plot
ggplot() + 
  geom_line(hb_offset_diff_evo, mapping = aes(block, offset_diff, group = fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset_diff,aes(block,mean_offset_diff,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset_diff, mapping=aes(x=block, ymin=mean_offset_diff + sd_offset_diff/sqrt(n), ymax=mean_offset_diff - sd_offset_diff/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Remapping index")+
  ylim(c(-0.8,0.8))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="offset_diff_evo.svg",device = 'svg', width=4, height=6)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="offset_diff_evo.png",device = 'png', width=4, height=6)


#stats
hb_offset_diff_evo  %>%
  wilcox_test(offset_diff ~ block, paired = TRUE) 


# code to plot full figure for paper --------------------------------------

#empty trial comparison HD encoding reliability
p1 <- ggplot() + 
  geom_line(empty_trial_comparison_offset_data, mapping = aes(trial, offset_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_line(data = mean_and_sd_offset,aes(trial,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset, mapping=aes(x=trial, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding reliability")+
  ylim(c(0,1))

#empty trial comparison of consistency of behavioral orientation
p2 <- ggplot() + 
  geom_line(empty_trial_comparison_heading_data, mapping = aes(trial, heading_precision, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_heading,aes(trial,mean_heading_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_heading, mapping=aes(x=trial, ymin=mean_heading_precision + sd_heading_precision/sqrt(n), ymax=mean_heading_precision - sd_heading_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Consistency of \n behavioral orientation")+
  ylim(c(0,1))

#remapping index evolution
p3 <- ggplot() + 
  #geom_violin(hb_offset_diff_evo, mapping = aes(block, offset_diff)) +
  geom_line(hb_offset_diff_evo, mapping = aes(block, offset_diff, group = fly),color = 'gray50',size=0.5) +
  stat_summary(hb_offset_diff_evo, mapping = aes(block, offset_diff),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text = element_text(size=16),axis.text = element_text(size = 12),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(hb_offset_diff_evo, mapping = aes(block, offset_diff),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Remapping index")+
  ylim(c(-0.8,0.8))

#learning predictors
p4 <- ggplot(learning_data_diff,aes(offset_diff,bump_mag)) +
  geom_point(size = 2.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="Bump amplitude (DF/F)", limits=c(0.5,2.5)) 

p5 <- ggplot(learning_data_diff,aes(offset_diff,bump_width)) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="Bump width (deg)" , limits=c(70,140)) 

p6 <- ggplot(learning_data_diff,aes(offset_diff,offset_precision)) +
  geom_point(size = 2.5)+
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Remapping index") +
  scale_y_continuous(name="HD encoding realiability", limits=c(0, 1))

row_1 <- p1 + p2 + p3
row_2 <- p5 + p4 + p6
full_plot <- row_1/row_2 + plot_layout(heights = c(1,2))
full_plot + plot_annotation(tag_levels = list(c('B','C','D','E','F','G')))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="bottom_fig_5.svg",device = 'svg', width=16, height=12)

