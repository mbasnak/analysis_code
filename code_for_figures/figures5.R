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


#stats
hb_offset_diff_evo  %>%
  wilcox_test(offset_diff ~ block, paired = TRUE) 


# code to plot full figure for paper --------------------------------------

#remapping index evolution
mean_remapping <- learning_data_diff %>%
  summarise(mean_remapping = mean(offset_diff))

learners <- hb_offset_diff_evo %>%
  filter(offset_diff > mean_remapping$mean_remapping) %>%
  filter(block == 'Final part')
learners <- learners$fly

non_learners <- hb_offset_diff_evo %>%
  filter(offset_diff <= mean_remapping$mean_remapping) %>%
  filter(block == 'Final part')
non_learners <- non_learners$fly

hb_offset_diff_evo$learner <- rep(0,dim(hb_offset_diff_evo)[1])
hb_offset_diff_evo$learner[hb_offset_diff_evo$fly %in% learners] = 1

p3 <- ggplot() + 
  geom_line(hb_offset_diff_evo, mapping = aes(block, offset_diff, group = fly, color = factor(learner)),size=0.5) +
  stat_summary(hb_offset_diff_evo, mapping = aes(block, offset_diff),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text = element_text(size=17),axis.text = element_text(size = 16),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  geom_point(hb_offset_diff_evo, mapping = aes(block, offset_diff, color = factor(learner))) +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Inversion index")+
  scale_color_manual(values=c('gray70','gray0')) +
  scale_y_continuous(expand = c(0, 0), limits=c(-1, 1))


#empty trial comparison HD encoding reliability
empty_trial_comparison_offset_data$Fly = empty_trial_comparison_offset_data$Fly + 1
empty_trial_comparison_offset_data$learner <- rep(0,dim(empty_trial_comparison_offset_data)[1])
empty_trial_comparison_offset_data$learner[empty_trial_comparison_offset_data$Fly %in% learners] = 1

p1 <- ggplot() + 
  geom_line(empty_trial_comparison_offset_data, mapping = aes(trial, offset_precision, group = Fly,color=factor(learner)),size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=0.5),
        legend.position = 'none') +
  geom_line(data = mean_and_sd_offset,aes(trial,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD certainty")+
  scale_color_manual(values=c('gray70','gray0')) +
  scale_y_continuous(expand = c(0, 0), limits=c(0, 1))

#empty trial comparison of consistency of behavioral orientation
empty_trial_comparison_heading_data$Fly = empty_trial_comparison_heading_data$Fly + 1
empty_trial_comparison_heading_data$learner <- rep(0,dim(empty_trial_comparison_heading_data)[1])
empty_trial_comparison_heading_data$learner[empty_trial_comparison_heading_data$Fly %in% learners] = 1

p2 <- ggplot() + 
  geom_line(empty_trial_comparison_heading_data, mapping = aes(trial, heading_precision,group = Fly, color=factor(learner)),size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  geom_line(data = mean_and_sd_heading,aes(trial,mean_heading_precision,group = 1),color = 'gray0',size=2) +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Consistency of \n behavioral orientation")+
  scale_color_manual(values=c('gray70','gray0')) +
  scale_y_continuous(expand = c(0, 0), limits=c(0, 1))


#learning predictors
learning_data_diff$fly <- 1:nrow(learning_data_diff)
learning_data_diff$learner <- rep(0,dim(learning_data_diff)[1])
learning_data_diff$learner[learning_data_diff$fly %in% learners] = 1

p5 <- ggplot(learning_data_diff,aes(bump_width,offset_diff,color = factor(learner))) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  scale_color_manual(values=c('gray70','gray0')) +
  scale_y_continuous(name="Inversion index", expand = c(0, 0), limits=c(-1,1)) +
  scale_x_continuous(name="Bump width (°)" , expand = c(0, 0), limits=c(82,133)) 


p4 <- ggplot(learning_data_diff,aes(bump_mag,offset_diff,color = factor(learner))) +
  geom_point(size = 2.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  scale_color_manual(values=c('gray70','gray0')) +
  scale_y_continuous(name="Inversion index", expand = c(0, 0), limits=c(-1,1)) +
  scale_x_continuous(name="Bump amplitude (\u0394F/F)", expand = c(0, 0), limits=c(0.8,3)) 



row_1 <- plot_spacer() + plot_spacer() +  plot_spacer() + p3 + plot_layout(nrow=1)
row_2 <- p1 + p2 + p5 + p4 + plot_layout(nrow=1)
full_plot <- row_1/row_2 
full_plot + plot_layout(heights = c(1,2))+ plot_annotation(tag_levels = list(c('D','E','F','G','H')))
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="bottom_fig_5.svg",device = 'svg', width=15, height=10)




############ extra analyses

#Are bump width and bump amplitude in normal gain significantly correlated with HD encoding accuracy in normal gain?

p1 <- ggplot(learning_data_diff,aes(offset_precision, bump_width)) +
  geom_point(size = 2.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  scale_x_continuous(name="HD encoding accuracy", expand = c(0, 0), limits=c(0,1)) +
  scale_y_continuous(name="Bump width (°)" , expand = c(0, 0), limits=c(82,133)) 

p2 <- ggplot(learning_data_diff,aes(offset_precision, bump_mag)) +
  geom_point(size = 2.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5),
        legend.position = 'none') +
  scale_x_continuous(name="HD encoding accuracy", expand = c(0, 0), limits=c(0,1)) +
  scale_y_continuous(name="Bump amplitude (\u0394F/F)", expand = c(0, 0), limits=c(0.8,3)) 

full_plot_2 <- p1 + p2
full_plot_2
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="bump_pars_vs_HD_encoding_NG.svg",device = 'svg', width=15, height=12)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig5", file="bump_pars_vs_HD_encoding_NG.pdf",device = 'pdf', width=15, height=12)



summary(lm(bump_width ~ offset_precision, learning_data_diff))
summary(lm(bump_mag ~ offset_precision, learning_data_diff))
