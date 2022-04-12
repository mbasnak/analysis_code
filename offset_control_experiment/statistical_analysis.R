
setwd('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Offset_control/data')


## analyze offset precision
offset_precision_data <- read.csv('offset_precision_data.csv')
offset_precision_data <-
  offset_precision_data %>% 
  mutate(block = factor(
    case_when(block == 1 ~ "bar",
              block == 2 ~ "wind",
              block == 3 ~ "empty"), 
    levels = c("empty","bar","wind"))
  )

#run model
mdl_offset_precision <- lme(offset_precision ~ block,random=~1|fly, offset_precision_data)
summary(mdl_offset_precision)
summary(glht(mdl_offset_precision, linfct = mcp(block = "Tukey")), test = adjusted("bonferroni"))



## analyze bump parameters
