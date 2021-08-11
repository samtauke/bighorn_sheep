rm(list = ls(all = TRUE)) # clear all variables in the environment

r_environ <- "[INSERT LOCATION OF CODE FOLDER]/code/"
source(file = paste0(r_environ,"header.r"))
data_lan <- "[INSERT LOCATION OF DATA FOLDER]/data/"
`%!in%` <- Negate(`%in%`)







# Batch Data --------------------------------------------------------------

batch_1_raw <- read_csv(paste0(data_lan,"raw/batch 1 final.csv")) %>% 
  clean_names()


batch_1 <- as.data.frame(t(batch_1_raw)) %>% 
  row_to_names(row_number = 1) %>% 
  clean_names() %>% 
  rownames_to_column(var = "sample")
  

batch_2_raw <- read_csv(paste0(data_lan,"raw/batch 2 final.csv")) %>% 
  clean_names()


batch_2 <- as.data.frame(t(batch_2_raw)) %>% 
  row_to_names(row_number = 1) %>% 
  clean_names() %>% 
  rownames_to_column(var = "sample")



batch_combine <- batch_1 %>% 
  bind_rows(batch_2) %>% 
  mutate(
    sample_num = as.numeric(substr(sample,12,15))
  )

batch_combine[is.na(batch_combine)] <- 0

gen_cols <- batch_combine %>% 
  select(contains("x")) %>% 
  colnames()


batch_combine <- batch_combine %>% 
  mutate_at(gen_cols, as.numeric) 


# Deal with Duplicate Metabolites


foo <- batch_1_raw %>% 
  left_join(batch_2_raw,suffix = c("_1","_2")) 

sample_cols <- foo %>% 
  select(contains("sample")) %>% 
  colnames()

toofast_toofoo <- foo %>%
  mutate_at(sample_cols, as.numeric) %>% 
  group_by(id) %>% 
  summarise_all("max") %>% 
  filter(id %!in% c("year",'name','month','herd','class')
         )


few <- as.data.frame(t(toofast_toofoo)) %>% 
  row_to_names(row_number = 1) %>% 
  clean_names() %>% 
  rownames_to_column(var = "sample")

gen_cols <- few %>% 
  select(contains("x")) %>% 
  colnames()


few <- few %>% 
  mutate_at(gen_cols, as.numeric) 



write_rds(few,path = paste0(data_lan,"datasets/raw_batch_data.rds"))
write_csv(few,path = paste0(data_lan,"datasets/raw_batch_data.csv"))



# Meta Data ---------------------------------------------------------------

meta_data_raw <- read_csv(paste0(data_lan,"raw/sheep_sample_meatadata_v2.csv")) %>% 
  clean_names()


write_rds(meta_data_raw,path = paste0(data_lan,"datasets/raw_meta_data.rds"))
write_csv(meta_data_raw,path = paste0(data_lan,"datasets/raw_meta_data.csv"))

