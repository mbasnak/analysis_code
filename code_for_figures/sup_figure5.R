#code for sup figure 5

#load useful libraries
library(ggplot2)
library(tidyverse)
library(rCAT)
library(patchwork)

#offset precision distribution before and after the inverted gain
offset_precision_ng <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/offset_precision_ng.csv")
offset_precision_ng <- offset_precision_ng %>%
  mutate(block = factor(
    case_when(block == 1 ~ "Initial block",
              block == 2 ~ "Final block"), 
    levels = c("Initial block","Final block"))
  )

p1 <- ggplot() + 
  geom_line(offset_precision_ng, mapping = aes(block,offset_precision, group = fly),color = 'gray70',size=0.5) +
  stat_summary(offset_precision_ng, mapping = aes(block,offset_precision),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=16),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(offset_precision_ng, mapping = aes(block,offset_precision),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="HD encoding certainty")+
  ylim(c(0,1))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig5", file="full_fig.svg",device = 'svg', width=5, height=5)



#color-coded version of B-D using BW as color code
hb_offset_diff_evo <- read_csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/hb_offset_diff_evo.csv')
learning_data_diff <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/learning_data_diff.csv')
learning_data_diff$bump_width <- rad2deg(learning_data_diff$bump_width)
hb_offset_diff_evo$bump_width <- rep(learning_data_diff$bump_width,2)

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


#remapping index evolution
 ggplot() + 
  geom_line(hb_offset_diff_evo, mapping = aes(block, offset_diff, group = fly, color = bump_width),size=1) +
  #stat_summary(hb_offset_diff_evo, mapping = aes(block, offset_diff),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text = element_text(size=16),axis.text = element_text(size = 12),
        axis.text.x = element_text(vjust=.8, hjust=0.8),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  geom_point(hb_offset_diff_evo, mapping = aes(block, offset_diff,color=bump_width)) +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Remapping index")+
  ylim(c(-0.8,0.8))