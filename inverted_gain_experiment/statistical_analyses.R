#### code to run statistical analyses for the inverted gain experiment

#load packages
library(ggplot2)
library(nlme)
library(lme4)
library(multcomp)
library(cowplot)
library(tidyverse)


#set working directory
setwd('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data')


###### I) Comparison between empty trial and gain change
#load data
empty_trial_comparison_data <- read.csv("empty_trial_comparison_data.csv")

#run paired wilcoxon test
wilcox.test(empty_trial_comparison_data$empty_trial_offset_precision,empty_trial_comparison_data$gain_change_offset_precision, paired = TRUE, alternative = "two.sided")


###Plot offset precision comparison
#1) Load data
empty_trial_comparison_offset_data <- read.csv("empty_trial_comparison_all_data.csv")
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
    case_when(trial == "empty_trial_offset_precision" ~ "Empty trial",
              trial == "initial_gain_change_offset_precision" ~ "Inverted gain (initial part)",
              trial == "final_gain_change_offset_precision" ~ "Inverted gain (final part)"), 
    levels = c("Empty trial", "Inverted gain (initial part)", "Inverted gain (final part)"))
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
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_offset,aes(trial,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_offset, mapping=aes(x=trial, ymin=mean_offset_precision + sd_offset_precision/sqrt(n), ymax=mean_offset_precision - sd_offset_precision/sqrt(n)), width=0, size=2, color="gray0") +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Heading offset precision")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/InvertedGain-Experiment", file="heading_offset_precision_comparison.svg",device = 'svg', width=6, height=6)


#6) Run model
mdl_offset_precision_comparison <- lme(offset_precision ~ trial ,random=~1|Fly, empty_trial_comparison_offset_data)
summary(mdl_offset_precision_comparison)
anova(mdl_offset_precision_comparison)
summary(glht(mdl_offset_precision_comparison, linfct = mcp(trial = "Tukey")), test = adjusted("bonferroni"))


#### Repeat previous steps for heading precision

#1) Load data
empty_trial_comparison_heading_data <- read.csv("empty_trial_heading_comparison_all_data.csv")
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
    case_when(trial == "empty_trial_heading_precision" ~ "Empty trial",
              trial == "initial_gain_change_heading_precision" ~ "Inverted gain (initial part)",
              trial == "final_gain_change_heading_precision" ~ "Inverted gain (final part)"), 
    levels = c("Empty trial", "Inverted gain (initial part)", "Inverted gain (final part)"))
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

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/InvertedGain-Experiment", file="heading_precision_comparison.svg",device = 'svg', width=6, height=6)

#6) Run model
mdl_heading_precision_comparison <- lme(heading_precision ~ trial ,random=~1|Fly, empty_trial_comparison_heading_data)
summary(mdl_heading_precision_comparison)
anova(mdl_heading_precision_comparison)
summary(glht(mdl_heading_precision_comparison, linfct = mcp(trial = "Tukey")), test = adjusted("bonferroni"))







###################### heading and bar offset precision

#Load data
hb_offset_ratio_evo <- read.csv("hb_offset_ratio_evo.csv")
hb_offset_ratio_evo$Fly <- seq.int(nrow(hb_offset_ratio_evo)) 

#Reorder data for plotting
hb_offset_ratio_evo <- hb_offset_ratio_evo %>%
  pivot_longer(
    cols = contains("ratio"),
    names_to = "part_of_trial",
    values_to = "ratio"
  )

#Rename and reorder factor levels
hb_offset_ratio_evo <-
  hb_offset_ratio_evo %>% 
  mutate(part_of_trial = factor(
    case_when(part_of_trial == "Initial_hb_ratio" ~ "Initial",
              part_of_trial == "Final_hb_ratio" ~ "Final"),
    levels = c("Initial", "Final"))
  )

#Get mean and sd
mean_and_sd_hb_ratio <- hb_offset_ratio_evo %>%
  group_by(part_of_trial) %>% 
  summarise(sd_hb_ratio = sd(ratio),
            mean_hb_ratio = mean(ratio),
            n = n())

#Plot
ggplot() + 
  geom_line(hb_offset_ratio_evo, mapping = aes(part_of_trial, ratio, group = Fly),color = 'gray50',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.text.x = element_text(angle = 30, vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  geom_line(data = mean_and_sd_hb_ratio,aes(part_of_trial,mean_hb_ratio,group = 1),color = 'gray0',size=2) +
  geom_errorbar(data=mean_and_sd_hb_ratio, mapping=aes(x=part_of_trial, ymin=mean_hb_ratio + sd_hb_ratio/sqrt(n), ymax=mean_hb_ratio - sd_hb_ratio/sqrt(n)), width=0, size=2, color="gray0") +
  labs(x="", y="Heading/bar offset precision")

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/InvertedGain-Experiment", file="hb_ratio_evo.svg",device = 'svg', width=6, height=6)

#Run model
hb_offset_ratio_evo <- read.csv("hb_offset_ratio_evo.csv")
wilcox.test(hb_offset_ratio_evo$Initial_hb_ratio, hb_offset_ratio_evo$Final_hb_ratio, paired = TRUE, alternative = "two.sided")




## initial vs final offset precision in inverted gain

offset_precision_ng <- read.csv('offset_precision_ng.csv')

ggplot(offset_precision_ng,aes(x=block, y=offset_precision, group=block)) + 
  gghalves::geom_half_violin(scale = "width", trim=TRUE, adjust=1.0, fill="#FF9F9B") +
  geom_point(size=3) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=22),
        axis.text = element_text(size=20), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1.5),
        axis.line.y = element_line(size=1.5)) +
  scale_x_continuous(breaks=1:2,labels = c("Initial period",'Final period')) +
  xlab(" ") + ylab("Offset precision") +
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/InvertedGain-Experiment", file="offset_precision_normal_gain.svg",device = 'svg', width=6, height=6)




##### Learning strategy
learning_data <- read.csv('learning_data.csv')

#run linear regression
summary(lm(offset_ratio ~ bump_mag, learning_data))
summary(lm(offset_ratio ~ bump_width, learning_data))
summary(lm(offset_ratio ~ offset_precision, learning_data))

#Plot
p1 <- ggplot(learning_data,aes(offset_ratio,bump_mag)) +
  geom_point(size = 2.5) +
  geom_smooth(method='lm', se = FALSE, color = 'red', linetype="dashed") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Heading / bar offset ratio") +
  scale_y_continuous(name="Bump magntiude", limits=c(0, 3)) 

p2 <- ggplot(learning_data,aes(offset_ratio,bump_width)) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Heading / bar offset ratio") +
  scale_y_continuous(name="Bump width" , limits=c(1.5,3)) 

p3 <- ggplot(learning_data,aes(offset_ratio,offset_precision)) +
  geom_point(size = 2.5)+
  geom_smooth(method='lm', se = FALSE, color = 'red') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=18),
        axis.text = element_text(size=15), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  scale_x_continuous(name="Heading / bar offset ratio") +
  scale_y_continuous(name="Offset precision", limits=c(0, 1))

p <- plot_grid(p1, p2, p3,ncol = 3)
p

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/InvertedGain-Experiment", file="learning_prediction.svg",device = 'svg', width=11, height=6)



#as correlation (to get the coefficient)
cor.test(learning_data$offset_ratio,learning_data$bump_mag,method = "pearson")
cor.test(learning_data$offset_ratio,learning_data$bump_width,method = "pearson")
cor.test(learning_data$offset_ratio,learning_data$offset_precision,method = "pearson")






# ###### 2) bump pars vs offset precision and total movement
# 
# #window 1 = 10 frames
# #load data
# plotting_data_inv_gain <- read.csv("plotting_data.csv")
# #filter by goodness of fit and remove points when fly is standing still
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# 
# ## Plot bump magnitude and bump width
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 10 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# #window 2 = 30 frames
# plotting_data_inv_gain <- read.csv("plotting_data_window2.csv")
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 30 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# #window 3 = 50 frames
# plotting_data_inv_gain <- read.csv("plotting_data_window3.csv")
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 50 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# #window 4 = 100 frames
# plotting_data_inv_gain <- read.csv("plotting_data_window4.csv")
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 100 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# #window 5 = 200 frames
# plotting_data_inv_gain <- read.csv("plotting_data_window5.csv")
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 200 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# #window 6 = 500 frames
# plotting_data_inv_gain <- read.csv("plotting_data_window6.csv")
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain %>% filter(adj_rs > 0.5, total_mvt > 25)
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p3 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_mag)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p4 <- ggplot(plotting_data_inv_gain_thresh, aes(heading_offset_precision, bump_width)) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position="none",panel.grid.major = element_blank(), panel.grid.minor = element_blank())
# 
# p <- plot_grid(p1, p2, p3,p4)
# # now add the title
# title <- ggdraw() + 
#   draw_label(
#     "Window = 500 frames",
#     fontface = 'bold',
#     x = 0,
#     hjust = 0
#   ) +
#   theme(
#     # add margin on the left of the drawing canvas,
#     # so title is aligned with left edge of first plot
#     plot.margin = margin(0, 0, 0, 7)
#   )
# plot_grid(
#   title, p,
#   ncol = 1,
#   # rel_heights values control vertical title margins
#   rel_heights = c(0.1, 1)
# )
# 
# 
# 
# 
# 
# 
# #Plot as heatmap
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain_thresh %>% mutate(binned_mvt = ntile(total_mvt, n=3))
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain_thresh %>% mutate(binned_bar_offset_precision = ntile(bar_offset_precision, n=10))
# plotting_data_inv_gain_thresh <- plotting_data_inv_gain_thresh %>% mutate(binned_heading_offset_precision = ntile(heading_offset_precision, n=10))
# 
# 
# p1 <-  ggplot(plotting_data_inv_gain_thresh,aes(binned_bar_offset_precision, binned_mvt, fill = bump_mag)) +
#   geom_tile() + scale_fill_viridis_c()
# p2 <-  ggplot(plotting_data_inv_gain_thresh,aes(binned_bar_offset_precision, binned_mvt, fill = bump_width)) +
#   geom_tile() + scale_fill_viridis_c()
# 
# p <- plot_grid(p1, p2)
# p
# 
# #Plot as lines, divided into 'low', intermediate, and 'high' movement
# plotting_data_inv_gain_thresh$movement_level = as.factor(plotting_data_inv_gain_thresh$binned_mvt)
# plotting_data_inv_gain_thresh<-replace(plotting_data_inv_gain_thresh$binned_mvt, plotting_data_inv_gain_thresh$binned_mvt == 1, 'low')
# plotting_data_inv_gain_thresh<-replace(plotting_data_inv_gain_thresh$binned_mvt, plotting_data_inv_gain_thresh$binned_mvt == 2, 'intermediate')
# plotting_data_inv_gain_thresh$movement_level[plotting_data_inv_gain_thresh$binned_mvt == 3] = 'high'
# 
# p1 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_mag, group = factor(binned_mvt), color = factor(binned_mvt))) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position=c(0.70, 0.15),
#         legend.background = element_rect(color=NA, fill=NA),
#         panel.background=element_rect(fill="white"),
#         axis.line = element_line(color="black", size=1),
#         panel.grid.major = element_blank(), 
#         panel.grid.minor = element_blank(), 
#         text = element_text(size=22),axis.text = element_text(size = 20))
# 
# p2 <- ggplot(plotting_data_inv_gain_thresh, aes(bar_offset_precision, bump_width, group = factor(binned_mvt), color = factor(binned_mvt))) + 
#   geom_smooth() + coord_cartesian(ylim = c(-1,1)) +
#   theme(legend.position=c(0.70, 0.15),
#         legend.background = element_rect(color=NA, fill=NA),
#         panel.background=element_rect(fill="white"),
#         axis.line = element_line(color="black", size=1),
#         panel.grid.major = element_blank(), 
#         panel.grid.minor = element_blank(), 
#         text = element_text(size=22),axis.text = element_text(size = 20))
# 
# p <- plot_grid(p1, p2)
# p
# 
# 
# #bump magnitude bar offset precision model
# mdl_BM_bar <- lme(bump_mag ~ bar_offset_precision + total_mvt ,random=~1|fly, plotting_data_inv_gain_thresh)
# summary(mdl_BM_bar)
# anova(mdl_BM_bar)
# #This gives me opposite effects with and without the interaction term, which is weird
# 
# 
# #bump width bar offset precision model
# mdl_BW_bar <- lme(bump_width ~ bar_offset_precision * total_mvt ,random=~1|fly, plotting_data_inv_gain_thresh)
# summary(mdl_BW_bar)
# 
# 
# #Plot bump pars and heading offset var as heatmap
# p1 <-  ggplot(plotting_data_inv_gain_thresh,aes(binned_heading_offset_precision, binned_mvt, fill = bump_mag)) +
#   geom_tile() + scale_fill_viridis_c()
# p2 <-  ggplot(plotting_data_inv_gain_thresh,aes(binned_heading_offset_precision, binned_mvt, fill = bump_width)) +
#   geom_tile() + scale_fill_viridis_c()
# 
# grid.arrange(p1, p2, nrow = 1)
# 
# #bump magnitude heading offset precision model
# mdl_BM_heading <- lme(bump_mag ~ heading_offset_precision + total_mvt ,random=~1|fly, plotting_data_inv_gain_thresh)
# summary(mdl_BM_heading)
# anova(mdl_BM_heading)
# 
# #bump width heading offset precision model
# mdl_BW_heading <- lme(bump_width ~ heading_offset_precision * total_mvt ,random=~1|fly, plotting_data_inv_gain_thresh)
# summary(mdl_BW_heading)
# 
# 






