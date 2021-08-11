
rm(list = ls(all = TRUE)) # clear all variables in the environment

r_environ <- "[INSERT LOCATION OF CODE FOLDER]/code/"
source(file = paste0(r_environ,"header.r"))
data_lan <- "[INSERT LOCATION OF DATA FOLDER]/data/"


# Read in Previous Data
batch_combine <- read_rds(paste0(data_lan,"datasets/raw_batch_data.rds"))
meta_data_raw <- read_rds(paste0(data_lan,"datasets/raw_meta_data.rds"))



# Combine Meta Data with batch data


foo <- batch_combine %>% 
  select(sample,contains("x")) %>% 
  mutate(
    merge_s_name = gsub("area_","",sample)
  ) %>% 
  left_join(meta_data_raw %>% mutate(merge_s_name = tolower(labid)) %>% select(merge_s_name,herd,class_meta = class),
            by = "merge_s_name") %>% 
  select(sample,class_meta,herd,contains("x")) %>% 
  mutate(
    class_meta = tolower(class_meta),
    group_class = ifelse(class_meta=='chronic','chronic','not_chronic')
  ) %>% 
  replace(is.na(.), 0)




write_rds(foo,path = paste0(data_lan,"datasets/batch_meta_combine.rds"))
write_csv(foo,path = paste0(data_lan,"datasets/batch_meta_combine.csv"))




