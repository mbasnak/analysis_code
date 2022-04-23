#code for sup figure 3


library(ggplot2)



bump_pars_evo_data_bar_trial <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp25/data/Experimental/two_ND_filters_3_contrasts/bump_pars_evo_data_bar_trial.csv")

#Individual flies
ggplot(bump_pars_evo_data_bar_trial, aes(time, bump_mag, group = fly, color = factor(fly)))+ 
  theme(legend.position='none',
        panel.background=element_rect(fill="white"),
        axis.line = element_line(color="black", size=1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        text = element_text(size=18),axis.text = element_text(size = 16))+
  geom_smooth(alpha=0.2)+
  labs(y='Bump amplitude (DF/F)', color = '',fill = '')

ggsave(path = "C:/Users/Melanie/Dropbox (HMS)/Manuscript-Basnak/Figures/SupFig3", file="bump_mag_evo_ind_flies.svg",device = 'svg', width=8, height=6)

for (Fly in min(bump_pars_evo_data_bar_trial$fly):max(bump_pars_evo_data_bar_trial$fly))
{
  test <- bump_pars_evo_data_bar_trial %>% filter(bump_pars_evo_data_bar_trial$fly == Fly)
  p <- ggplot(test,aes(time, bump_mag))+ 
    theme(legend.position='none',
          panel.background=element_rect(fill="white"),
          axis.line = element_line(color="black", size=1),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          text = element_text(size=18),axis.text = element_text(size = 16))+
    geom_smooth(alpha=0.2)+
    labs(y='Bump amplitude (DF/F)', color = '',fill = '')
  print(p)
}
