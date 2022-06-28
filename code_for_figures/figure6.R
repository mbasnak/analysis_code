#code for figure 6

#load useful libraries
library(nlme)
library(multcomp)
library(ggplot2)
library(tidyverse)
library(patchwork)
library(cowplot)
library(rCAT)
library(rstatix)


# comparison of offset precision between visual and wind environments
initial_offset_precision_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/initial_offset_precision_data.csv")

initial_offset_precision_data <-
  initial_offset_precision_data %>% 
  mutate(block_type = factor(
    case_when(block_type == 1 ~ "Bar",
              block_type == 2 ~ "Wind"), 
    levels = c("Bar","Wind"))
  )

# get mean and sd
mean_and_sd_initial_offset <- initial_offset_precision_data %>%
  group_by(block_type) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig6", file="initial_offset_precision.svg",device = 'svg', width=4, height=4)
ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig6", file="initial_offset_precision.png",device = 'png', width=4, height=4)


#stats
initial_offset_precision_data  %>%
  wilcox_test(offset_precision ~ block_type, paired = TRUE) 



#repeat for bump parameters
initial_bump_pars_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/initial_bump_pars_data.csv")

initial_bump_pars_data <-
  initial_bump_pars_data %>% 
  mutate(block_type = factor(
    case_when(block_type == 1 ~ "Bar",
              block_type == 2 ~ "Wind"), 
    levels = c("Bar","Wind"))
  )

# get mean and sd
mean_and_sd_initial_bump_pars <- initial_bump_pars_data %>%
  group_by(block_type) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())


#stats
initial_bump_pars_data  %>%
  wilcox_test(bump_mag ~ block_type, paired = TRUE)
initial_bump_pars_data  %>%
  wilcox_test(bump_width ~ block_type, paired = TRUE)




# offset precision vs block type
offset_precision_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability//offset_precision_data_3_blocks.csv", header = FALSE)
colnames(offset_precision_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
offset_precision_data_3_blocks <- gather(offset_precision_data_3_blocks, key = "block_type", value = "offset_precision",-fly)
offset_precision_data_3_blocks$block_type = as.factor(offset_precision_data_3_blocks$block_type)
offset_precision_data_3_blocks$fly = as.factor(offset_precision_data_3_blocks$fly)

#run model
offset_precision_model_3_blocks <- lme(offset_precision ~ block_type , random=~1|fly, offset_precision_data_3_blocks)
summary(offset_precision_model_3_blocks)
anova(offset_precision_model_3_blocks)
#posthoc comparisons
summary(glht(offset_precision_model_3_blocks, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))
summary(glht(offset_precision_model_3_blocks, llinfct = c("initial_single_cue - cue_combination = 0", "final_single_cue - cue_combination = 0")), test = adjusted("bonferroni"))

offset_precision_data_3_blocks <-
  offset_precision_data_3_blocks %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_single_cue" ~ "Initial single cue",
              block_type == "final_single_cue" ~ "Final single cue",
              block_type == "cue_combination" ~ "Two-cue"), 
    levels = c("Initial single cue", "Two-cue", "Final single cue"))
  )

#get mean and sd
mean_and_sd_offset_precision <- offset_precision_data_3_blocks %>%
  group_by(block_type) %>% 
  summarise(sd_offset_precision = sd(offset_precision),
            mean_offset_precision = mean(offset_precision),
            n = n())

# bump pars vs block type
#load data
bump_mag_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_mag_data_3_blocks.csv", header = FALSE)
colnames(bump_mag_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
bump_mag_data_3_blocks <- gather(bump_mag_data_3_blocks, key = "block_type", value = "bump_mag",-fly)
bump_mag_data_3_blocks$block_type = as.factor(bump_mag_data_3_blocks$block_type)
bump_mag_data_3_blocks$fly = as.factor(bump_mag_data_3_blocks$fly)

#run model
bump_mag_model_3_blocks <- lme(bump_mag ~ block_type , random=~1|fly, bump_mag_data_3_blocks)
summary(bump_mag_model_3_blocks)
anova(bump_mag_model_3_blocks)
#posthoc comparisons
summary(glht(bump_mag_model_3_blocks, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))


bump_width_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_width_data_3_blocks.csv", header = FALSE)
colnames(bump_width_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
bump_width_data_3_blocks <- gather(bump_width_data_3_blocks, key = "block_type", value = "bump_width",-fly)
bump_width_data_3_blocks$block_type = as.factor(bump_width_data_3_blocks$block_type)
bump_width_data_3_blocks$fly = as.factor(bump_width_data_3_blocks$fly)
bump_width_data_3_blocks$bump_width = rad2deg(bump_width_data_3_blocks$bump_width)

#run model
bump_width_model_3_blocks <- lme(bump_width ~ block_type , random=~1|fly, bump_width_data_3_blocks)
summary(bump_width_model_3_blocks)
anova(bump_width_model_3_blocks)
#posthoc comparisons
summary(glht(bump_width_model_3_blocks, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))


#plot
bump_mag_data_3_blocks <-
  bump_mag_data_3_blocks %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_single_cue" ~ "Initial single cue",
              block_type == "final_single_cue" ~ "Final single cue",
              block_type == "cue_combination" ~ "Two-cue"), 
    levels = c("Initial single cue", "Two-cue", "Final single cue"))
  )

bump_width_data_3_blocks <-
  bump_width_data_3_blocks %>% 
  mutate(block_type = factor(
    case_when(block_type == "initial_single_cue" ~ "Initial single cue",
              block_type == "final_single_cue" ~ "Final single cue",
              block_type == "cue_combination" ~ "Two-cue"), 
    levels = c("Initial single cue", "Two-cue", "Final single cue"))
  )

#get mean and sd
mean_and_sd_bump_mag <- bump_mag_data_3_blocks %>%
  group_by(block_type) %>% 
  summarise(sd_bump_mag = sd(bump_mag),
            mean_bump_mag = mean(bump_mag),
            n = n())

mean_and_sd_bump_width <- bump_width_data_3_blocks %>%
  group_by(block_type) %>% 
  summarise(sd_bump_width = sd(bump_width),
            mean_bump_width = mean(bump_width),
            n = n())


# first vs second cue similarity with cc
#load data
cue_order_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/cue_order_data.csv", header = FALSE)
colnames(cue_order_data) <- c('first_cue','second_cue')

#run wilcoxon test
wilcox.test(cue_order_data$first_cue,cue_order_data$second_cue, paired = TRUE, alternative = "two.sided")

#add fly as factor
cue_order_data$fly <- seq(1,dim(cue_order_data)[1])

#reshape to plot
cue_order_data <- cue_order_data %>% 
  pivot_longer(cols = c(first_cue,second_cue), names_to = "order", values_to = "similarity")

cue_order_data <-
  cue_order_data %>% 
  mutate(order = factor(
    case_when(order == "first_cue" ~ "First cue",
              order == "second_cue" ~ "Second cue"), 
    levels = c("First cue","Second cue"))
  )

#get mean and sd
mean_and_sd_similarity <- cue_order_data %>%
  group_by(order) %>% 
  summarise(sd_similarity = sd(similarity),
            mean_similarity = mean(similarity),
            n = n())




### initial offset
#load data
initial_offset_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/initial_offset_data.csv", header = FALSE)
colnames(initial_offset_data) <- c('visual_cue','wind')

#convert to degrees
initial_offset_data$visual_cue <- rad2deg(initial_offset_data$visual_cue)
initial_offset_data$wind <- rad2deg(initial_offset_data$wind)


# plasticity analysis

#load data
plasticity_data <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/plasticity_data.csv")
plasticity_data_thresh <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/plasticity_data_thresh.csv")
plasticity_data$order <-  rep(1:2,each=18)




# code to plot full figure for paper --------------------------------------

#offset precision vs block type
p1 <- ggplot() + 
  geom_line(offset_precision_data_3_blocks, mapping = aes(block_type, offset_precision, group = fly),color = 'gray70',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_line(data = mean_and_sd_offset_precision,aes(block_type,mean_offset_precision,group = 1),color = 'gray0',size=2) +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="HD certainty") +
  scale_y_continuous(expand = c(0, 0), limits=c(0, 1))

#Bump width per block
p2 <- ggplot() + 
  geom_line(bump_width_data_3_blocks, mapping = aes(block_type, bump_width, group = fly),color = 'gray70',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_line(data = mean_and_sd_bump_width,aes(block_type,mean_bump_width,group = 1),color = 'gray0',size=2) +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump width (°)") +
  scale_y_continuous(expand = c(0, 0), limits=c(70,135))

#Bump mag per block
p3 <- ggplot() + 
  geom_line(bump_mag_data_3_blocks, mapping = aes(block_type, bump_mag, group = fly),color = 'gray70',size=0.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_line(data = mean_and_sd_bump_mag,aes(block_type,mean_bump_mag,group = 1),color = 'gray0',size=2) +
  scale_x_discrete(expand=expansion(add = c(0.3, 0.3)), 
                   labels=scales::wrap_format(10)) +
  labs(x="", y="Bump amplitude (\u0394F/F)") +
  scale_y_continuous(expand = c(0, 0), limits=c(0,2.7))

#Initial cue offsets

p4 <- ggplot(initial_offset_data,aes(visual_cue,wind)) +
  geom_point(size = 2) + 
  theme(panel.background = element_rect(fill=NA),
        legend.position = 'none',
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  labs(x="Initial visual cue offset (°)", y="Initial wind offset (°)")+
  scale_y_continuous(expand = c(0, 0), limits=c(-180,220), breaks = c(-180,0,180)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-180,180), breaks = c(-180,0,180))

cor.test(initial_offset_data$visual_cue,initial_offset_data$wind)


#cue similarity
p5 <- ggplot() + 
  geom_line(cue_order_data, mapping = aes(order, similarity, group = fly),color = 'gray70',size=0.5) +
  stat_summary(cue_order_data, mapping = aes(order, similarity),fun.y=mean, geom="crossbar", size=1, , width=0.4, color="black") +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_point(cue_order_data, mapping = aes(order, similarity),color='gray50') +
  scale_x_discrete(labels=scales::wrap_format(10)) +
  labs(x="", y="Similarity between two-cue \n and single cue offset (°)") +
  scale_y_continuous(expand = c(0, 0), limits=c(0,180))

#plasticity analysis
p6 <- ggplot(plasticity_data,aes(Conflict,Plasticity)) +
  theme(panel.background = element_rect(fill=NA),
        legend.position = 'none',
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  geom_point(aes(color = factor(order)),size = 2)  +
  geom_point(aes(Conflict,Plasticity+360,color = factor(order)),size=2) +
  geom_abline(intercept = 0, slope = 1,color = 'red') +
  scale_color_manual(values=c('gray0','gray70')) +
  labs(x="Two-cue offset - initial single cue offset (°)", y="Final single cue offset - initial single cue offset (°)")+
  scale_y_continuous(expand = c(0, 0), limits=c(-180,220), breaks = c(-180,0,180)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-180,180), breaks = c(-180,0,180))


row_1 <- p1 + p2 + p3
row_2 <- p4 + p2 + p5
row_3 <- p1 + p2 + p6 + plot_layout(nrow = 1)
full_plot <- row_1/row_2/row_3 #+ plot_layout(heights = c(1,1.3))
full_plot + plot_annotation(tag_levels = list(c('C','D','E','F','','H','','','J')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/Fig6", file="most_fig_6.svg",device = 'svg', width=14, height=15)
