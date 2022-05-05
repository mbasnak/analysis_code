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
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_blank(),
        axis.ticks.x=element_blank(),
        axis.line.y = element_line(size=.5)) +
  geom_point(offset_precision_ng, mapping = aes(block,offset_precision),color='gray50') +
  labs(x="", y="HD certainty")+
  scale_y_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1))

#stats
offset_precision_ng  %>%
  wilcox_test(offset_precision ~ block, paired = TRUE) 


learning_data_diff <- read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp28/data/learning_data_diff.csv')
learning_data_diff$bump_width <- rad2deg(learning_data_diff$bump_width)

p2 <-ggplot(learning_data_diff,aes(offset_precision,offset_diff)) +
  geom_point(size = 2.5)+
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=17),
        axis.text = element_text(size=16), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=.5),
        axis.line.y = element_line(size=.5)) +
  scale_y_continuous(name="Inversion index", expand = c(0, 0), limits=c(-1,1)) +
  scale_x_continuous(name="HD certainty", expand = c(0, 0), limits=c(0, 1))

p <- p1 + p2
p + plot_annotation(tag_levels = list(c('B','C')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig5", file="full_fig.svg",device = 'svg', width=8, height=5)



