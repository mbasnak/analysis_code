#code for sup figure 1

#load useful libraries
library(ggplot2)
library(patchwork)


#fit, a couple example points
example_fit_1 <-read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/example_data_fit_1.csv')
example_fit_1$distance <- rad2deg(example_fit_1$distance)

p1 <- ggplot(example_fit_1,aes(distance,data)) +
  geom_line(size = 1.5) +
  geom_line(data = example_fit_1,aes(distance,fit),size = 1.5, color = 'darkviolet') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.line.y = element_line(size=1)) +
  labs(x="", y="\u0394F/F") +
  ylim(c(-0.5,3))
  
example_fit_2 <-read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/example_data_fit_2.csv')
example_fit_2$distance <- rad2deg(example_fit_2$distance)

p2 <- ggplot(example_fit_2,aes(distance,data)) +
  geom_line(size = 1.5) +
  geom_line(data = example_fit_2,aes(distance,fit),size = 1.5, color = 'darkviolet') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.line.y = element_line(size=1)) +
  labs(x="", y="\u0394F/F") +
  ylim(c(-0.5,3))

example_fit_3 <-read.csv('Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/example_data_fit_3.csv')
example_fit_3$distance <- rad2deg(example_fit_3$distance)

p3 <- ggplot(example_fit_3,aes(distance,data)) +
  geom_line(size = 1.5) +
  geom_line(data = example_fit_3,aes(distance,fit),size = 1.5, color = 'darkviolet') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x="Angular distance (deg)", y="\u0394F/F") +
  ylim(c(-0.5,3))

p4 <- ggplot(example_fit_1,aes(distance,data)) +
  geom_line(size = 1.5) +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.5, "cm"),
        axis.line.x = element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.line.y = element_line(size=1)) +
  labs(x="", y="DF/F") +
  ylim(c(-0.5,3))

p5 <- ggplot(data = example_fit_1,aes(distance,fit)) +
  geom_line(size = 1.5, color = 'darkviolet') +
  theme(panel.background = element_rect(fill=NA),
        text=element_text(size=14),
        axis.text = element_text(size=12), axis.ticks.length.x = unit(0.1, "cm"),
        axis.line.x = element_line(size=1),
        axis.line.y = element_line(size=1)) +
  labs(x="Angular distance (deg)", y="\u0394F/F") +
  ylim(c(-0.5,3))


col_1 <- p1/p3
col_2 <- p5
full_plot <- col_1 | col_2
full_plot + plot_annotation(tag_levels = list(c('B',"",'C')))

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig1", file="example_fit.svg",device = 'svg', width=14, height=10)




#heading precision in cue brightness experiment