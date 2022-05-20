#compare the 3 different states of the cue combination data


#MANOVA 
#using this tutorial:
# https://www.datanovia.com/en/lessons/one-way-manova-in-r/

#with my data
# offset precision vs block type
offset_precision_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability//offset_precision_data_3_blocks.csv", header = FALSE)
colnames(offset_precision_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
offset_precision_data_3_blocks <- gather(offset_precision_data_3_blocks, key = "block_type", value = "offset_precision",-fly)
offset_precision_data_3_blocks$block_type = as.factor(offset_precision_data_3_blocks$block_type)
offset_precision_data_3_blocks$fly = as.factor(offset_precision_data_3_blocks$fly)

#Bump width per block
#load data
bump_width_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_width_data_3_blocks.csv", header = FALSE)
colnames(bump_width_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
bump_width_data_3_blocks <- gather(bump_width_data_3_blocks, key = "block_type", value = "bump_width",-fly)
bump_width_data_3_blocks$block_type = as.factor(bump_width_data_3_blocks$block_type)
bump_width_data_3_blocks$fly = as.factor(bump_width_data_3_blocks$fly)
bump_width_data_3_blocks$bump_width = rad2deg(bump_width_data_3_blocks$bump_width)


#Bump mag per block
#load data
bump_mag_data_3_blocks <- read.csv("Z:/Wilson Lab/Mel/Experiments/Uncertainty/Exp35/data/high_reliability/bump_mag_data_3_blocks.csv", header = FALSE)
colnames(bump_mag_data_3_blocks) <- c('initial_single_cue','cue_combination','final_single_cue','fly')
bump_mag_data_3_blocks <- gather(bump_mag_data_3_blocks, key = "block_type", value = "bump_mag",-fly)
bump_mag_data_3_blocks$block_type = as.factor(bump_mag_data_3_blocks$block_type)
bump_mag_data_3_blocks$fly = as.factor(bump_mag_data_3_blocks$fly)


#1) combine data
my_data <- cbind(offset_precision_data_3_blocks$fly,offset_precision_data_3_blocks$offset_precision,bump_width_data_3_blocks$bump_width,bump_mag_data_3_blocks$bump_mag,bump_mag_data_3_blocks$block_type)
my_data <- as.data.frame(my_data)
colnames(my_data) <- c('fly','bump_HDcertainty','bump_width','bump_mag','block')

my_data <-
  my_data %>% 
  mutate(block = factor(
    case_when(block == 2 ~ "Final single cue",
              block == 1 ~ "Two-cue",
              block == 3 ~ "Initial single cue"), 
    levels = c("Initial single cue","Two-cue","Final single cue"))
  )

#2) plot
library(ggpubr)
#change bump width for display
my_data$bump_width <- my_data$bump_width/100
ggboxplot(
  my_data, x = "block", y = c("bump_HDcertainty", "bump_width","bump_mag"), 
  merge = TRUE, palette = "jco"
)
#revert back bump width
my_data$bump_width <- my_data$bump_width*100


#3) Get summary stats
my_data %>%
  group_by(block) %>%
  get_summary_stats(bump_HDcertainty, bump_width,bump_mag, type = "mean_sd")




#with repeated measures
#https://cran.r-project.org/web/packages/MANOVA.RM/vignettes/Introduction_to_MANOVA.RM.html
library(MANOVA.RM)

reordered_data <- my_data %>%
  pivot_longer(
    cols = contains("bump"),
    names_to = 'variable',
    values_to = 'value'
  )


model1 <- RM(value ~ block*variable, data = reordered_data, 
             subject = "fly", no.subf = 2, iter = 1000, 
             resampling = "Perm", seed = 1234)
summary(model1)

plot(model1, leg = FALSE)

simCI(model1, contrast = "pairwise", type = "Tukey")




#with PCA

