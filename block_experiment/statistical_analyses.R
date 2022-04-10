#### code to run statistical analyses for the block experiment

#load packages
library(tidyr)
library(circular)
library(pracma)

#set working directory
setwd('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability')

## Bump parameters per block

#1) Bump magnitude
#load data
bump_mag_data <- read.csv("bump_mag_data.csv", header = FALSE)
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


#2) Bump width
#load data
bump_width_data <- read.csv("bump_width_data.csv", header = FALSE)
colnames(bump_width_data) <- c('initial_first_cue','initial_second_cue','cue_combination','final_first_cue','final_second_cue','fly')
bump_width_data <- gather(bump_width_data, key = "block_type", value = "bump_width",-fly)
bump_width_data$block_type = as.factor(bump_width_data$block_type)
bump_width_data$fly = as.factor(bump_width_data$fly)

#run model
bump_width_model <- lme(bump_width ~ block_type , random=~1|fly, bump_width_data)
summary(bump_width_model)
anova(bump_width_model)
#posthoc comparisons
summary(glht(bump_width_model, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))




#Repeat using 3 block data
#load data
bump_mag_data_3_blocks <- read.csv("bump_mag_data_3_blocks.csv", header = FALSE)
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


bump_width_data_3_blocks <- read.csv("bump_width_data_3_blocks.csv", header = FALSE)
colnames(bump_width_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
bump_width_data_3_blocks <- gather(bump_width_data_3_blocks, key = "block_type", value = "bump_width",-fly)
bump_width_data_3_blocks$block_type = as.factor(bump_width_data_3_blocks$block_type)
bump_width_data_3_blocks$fly = as.factor(bump_width_data_3_blocks$fly)

#run model
bump_width_model_3_blocks <- lme(bump_width ~ block_type , random=~1|fly, bump_width_data_3_blocks)
summary(bump_width_model_3_blocks)
anova(bump_width_model_3_blocks)
#posthoc comparisons
summary(glht(bump_width_model_3_blocks, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))







### Cue order
#load data
cue_order_data <- read.csv("cue_order_data.csv", header = FALSE)
colnames(cue_order_data) <- c('first_cue','second_cue')

#run wilcoxon test
wilcox.test(cue_order_data$first_cue,cue_order_data$second_cue, paired = TRUE, alternative = "two.sided")



## Offset and heading precision

#1) Offset precision
#load data
offset_precision_data <- read.csv("offset_precision_data.csv", header = FALSE)
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


#1) Heading precision
#load data
heading_precision_data <- read.csv("heading_precision_data.csv", header = FALSE)
colnames(heading_precision_data) <- c('initial_first_cue','initial_second_cue','cue_combination','final_first_cue','final_second_cue','fly')
heading_precision_data <- gather(heading_precision_data, key = "block_type", value = "heading_precision",-fly)
heading_precision_data$block_type = as.factor(heading_precision_data$block_type)
heading_precision_data$fly = as.factor(heading_precision_data$fly)

#run model
heading_precision_model <- lme(heading_precision ~ block_type , random=~1|fly, heading_precision_data)
summary(heading_precision_model)
anova(heading_precision_model)
#posthoc comparisons
summary(glht(heading_precision_model, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))



#Repeat using 6 blocks instead of 5
offset_precision_data_6_blocks <- read.csv("offset_precision_data_6_blocks.csv", header = FALSE)
colnames(offset_precision_data_6_blocks) <- c('initial_first_cue','initial_second_cue','cue_combination_first_half','cue_combination_second_half','final_first_cue','final_second_cue','fly')
offset_precision_data_6_blocks <- gather(offset_precision_data_6_blocks, key = "block_type", value = "offset_precision",-fly)
offset_precision_data_6_blocks$block_type = as.factor(offset_precision_data_6_blocks$block_type)
offset_precision_data_6_blocks$fly = as.factor(offset_precision_data_6_blocks$fly)

#run model
offset_precision_model_6_blocks <- lme(offset_precision ~ block_type , random=~1|fly, offset_precision_data_6_blocks)
summary(offset_precision_model_6_blocks)
anova(offset_precision_model_6_blocks)
#posthoc comparisons
summary(glht(offset_precision_model_6_blocks, linfct = mcp(block_type = "Tukey")), test = adjusted("bonferroni"))



#Repeat using 3 blocks instead of 5
offset_precision_data_3_blocks <- read.csv("offset_precision_data_3_blocks.csv", header = FALSE)
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



## Plasticity analysis
#load data
plasticity_data <- read.csv("plasticity_data.csv")
plasticity_data_thresh <- read.csv("plasticity_data_thresh.csv")

#compute a correlation
cor.circular(deg2rad(plasticity_data$Plasticity), deg2rad(plasticity_data$Conflict), test=TRUE)
cor.circular(deg2rad(plasticity_data_thresh$Plasticity), deg2rad(plasticity_data_thresh$Conflict), test=TRUE)

#compute a regression
circ.lm <- lm.circular(deg2rad(plasticity_data_thresh$Plasticity), deg2rad(plasticity_data_thresh$Conflict), order=1)
# Obtain a crude plot of the data and fitted regression line.
plot.default(deg2rad(plasticity_data_thresh$Conflict), deg2rad(plasticity_data_thresh$Plasticity))
circ.lm$fitted[circ.lm$fitted>pi] <- circ.lm$fitted[circ.lm$fitted>pi] - 2*pi
points.default(deg2rad(plasticity_data_thresh$Conflict)[order(deg2rad(plasticity_data_thresh$Conflict))], circ.lm$fitted[order(deg2rad(plasticity_data_thresh$Conflict))], type='l')
