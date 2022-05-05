#code for sup figure 3


library(ggplot2)
library(patchwork)
library(nlme)

#bump amplitude in time, individual flies
bump_pars_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/bump_pars_evo_data_bar_trial.csv")

p1 <- ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag, group = fly, color = factor(fly)))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 15))+
  geom_line(lwd=1)+
  scale_x_continuous(breaks=c(300,600,900,1200),labels=c("5","10","15","20")) +
  labs(x = 'Time (min)', y='Bump amplitude (\u0394F/F)', color = '',fill = '')

p2 <- bump_pars_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,60),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(rot_speed)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = 'gray0', alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color= 'gray0')+
  labs(x = 'Time (min)', y='Rotational speed (°/s)', color = '',fill = '')+ 
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200),breaks=c(0,300,600,900,1200),labels=c("0","5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 70))

summary(lme(rot_speed ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))


p3 <- bump_pars_evo_data_bar_trial %>% 
  mutate(time_bin = cut(time,
                        breaks = seq(0,1200,60),
                        right = TRUE)) %>%
  group_by(time_bin, fly) %>% 
  summarise(mean_fly_bin = mean(for_vel)) %>%
  group_by(time_bin) %>%
  summarise(bin_mean = mean(mean_fly_bin), 
            n = n(),
            bin_sem = sd(mean_fly_bin)/sqrt(n)
  ) %>% 
  separate(time_bin, into=c("a", "b"), sep=",", remove=FALSE) %>% 
  mutate(right_end = readr::parse_number(b)) %>% 
  ggplot(aes(right_end, bin_mean)) +
  theme(legend.position=c(0.70, 0.15),
        legend.background = element_rect(color=NA, fill=NA),
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=.5),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=17),axis.text = element_text(size = 16))+
  geom_ribbon(aes(ymin=bin_mean - bin_sem, ymax=bin_mean + bin_sem), fill = 'gray0', alpha = .2) + 
  geom_line(aes(group=1), lwd=1, color= 'gray0')+
  labs(x = 'Time (min)', y='Forward velocity (mm/s)', color = '',fill = '')+ 
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1200),breaks=c(0,300,600,900,1200),labels=c("0","5","10","15","20")) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 12))

summary(lme(for_vel ~ time, random=~1|fly,bump_pars_evo_data_bar_trial))


full_plot <-  p2+p3
full_plot + plot_annotation(tag_levels = 'A')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig2", file="sup_fig2.svg",device = 'svg', width=8, height=6)


