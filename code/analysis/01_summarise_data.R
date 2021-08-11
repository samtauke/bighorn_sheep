
rm(list = ls(all = TRUE)) # clear all variables in the environment



r_environ <- "[INSERT LOCATION OF CODE FOLDER]/code/"
source(file = paste0(r_environ,"header.r"))
data_lan <- "[INSERT LOCATION OF DATA FOLDER]/data/"


# Read in Previous Data
foo <- read_rds(paste0(data_lan,"datasets/batch_meta_combine.rds"))


# Counts by class

counts <- foo %>% 
  group_by(class_meta) %>% 
  summarise(
    class_counts = n()
  ) %>% 
  ungroup()



# Compare "chronic" to "negative" and "intermittent" ----------------------

means <- foo %>% 
  select(-sample) %>% 
  filter(class_meta %in% c('chronic','negative','intermittent')) %>% 
  mutate(
    group_class = ifelse(class_meta=='chronic','chronic','not_chronic')
  ) %>% 
  select(-class_meta) %>% 
  group_by(group_class) %>%
  summarise_all("mean")

means_diffs <- means %>% 
  t() %>% 
  as.data.frame() %>% 
  row_to_names(row_number = 1) %>% 
  rownames_to_column("metabolite") %>% 
  mutate_at(c("chronic","not_chronic"),as.numeric) %>% 
  mutate(
    means_diff = chronic-not_chronic,
    abs_means_diff = abs(means_diff),
    pct_diff = means_diff/chronic
    ) %>% 
  arrange(desc(pct_diff))

# Plot Mean Diffs
plot_data <- means_diffs %>% 
  arrange(desc(means_diff)) 

ggplot(data=plot_data,aes(x = metabolite, y = means_diff)) + 
  geom_point()+
  geom_text_repel(
    aes(
      label=ifelse(means_diff>400000,metabolite,"")
    ),
    position=position_jitter(width=1,height=1)) +
  ylab("Diff. in Avg. Charge") +
  ylim(-4000000,4000000) +
  scale_y_continuous(
    labels = unit_format(unit = "M", scale = 1e-6)
    ) + 
  ggtitle("Difference in Average Charge Between Chronic and Non-Chronic Sheep")+
  theme(
    axis.title.y = element_blank(),
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    plot.title = element_text(hjust = 0.5),
    panel.border = element_blank()) 
  
# Plot Percentage Diffs
plot_data <- means_diffs %>% 
  arrange(desc(pct_diff)) 

ggplot(data=plot_data,aes(x = metabolite, y = pct_diff)) + 
  geom_point()+
  #geom_text_repel(
    #aes(
    #  label=ifelse(abs(pct_diff)>2,metabolite,"")
    #),
    #position=position_jitter(width=1,height=1)) +
  ylab("% Diff. in Avg. Charge") +
  scale_y_continuous(labels = scales::percent)+
  coord_cartesian(ylim = c(-10,2))+
  ggtitle("Percentage Difference in Average Charge Between Chronic and Non-Chronic Sheep")+
  theme(
    axis.title.y = element_blank(),
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    plot.title = element_text(hjust = 0.5),
    panel.border = element_blank()) 



# Find variance of each variable

var_variances <- sapply(foo %>% select(contains("x")), var) 
var_names <- foo %>% select(contains("x")) %>% 
  colnames()

all_variances <- data.frame(
  vars = var_names,
  variances = var_variances
)

