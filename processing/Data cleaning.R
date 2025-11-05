setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(pacman)
p_load(readxl, tidyverse, install = T)


# Read raw datasets 
pilot2 <- read_excel("../Data/pilot/Pilot-2_2022_collective_emotion_regulation_fall_yajun_November 3, 2022_19.13.xlsx",
                     range = cell_cols(19:463))
pilot1 <- read_excel("../Data/pilot/Pilot-1_2022_collective_emotion_regulation_fall_yajun_October 8, 2022_08.29.xlsx",
                     range = cell_cols(19:466))
data1 <- read_excel("../Data/Main/Main-1_2022_collective_emotion_regulation_fall_yajun_November 14, 2022_08.45.xlsx",
                    range = cell_cols(19:460))
data2 <- read_excel("../Data/Main/Main-2_2022_collective_emotion_regulation_fall_yajun_November 23, 2022_10.34.xlsx",
                    range = cell_cols(19:511))
data3 <- read_excel("../Data/Main/Main-3_2022_collective_emotion_regulation_fall_yajun_November 23, 2022_10.33.xlsx",
                    range = cell_cols(19:511))
data4 <- read_excel("../Data/Main/Main-4_2022_collective_emotion_regulation_fall_yajun_December 2, 2022_08.05.xlsx",
                    range = cell_cols(19:511))
data5 <- read_excel("../Data/Main/Main-5_2022_collective_emotion_regulation_fall_yajun_December 2, 2022_13.43.xlsx",
                    range = cell_cols(19:511))
data6 <- read_excel("../Data/Main/Main-6_2022_collective_emotion_regulation_fall_yajun_December 5, 2022_21.12.xlsx",
                    range = cell_cols(19:511))
data7 <- read_excel("../Data/Main/Main-7_2022_collective_emotion_regulation_fall_yajun_December 9, 2022_09.34.xlsx",
                    range = cell_cols(19:511))
data8 <- read_excel("../Data/Main/Main-8_2022_collective_emotion_regulation_fall_yajun_January 3, 2023_13.56.xlsx",
                    range = cell_cols(19:511))
#data9 <- read_excel("../Data/Main/Main-9_2022_collective_emotion_regulation_fall_yajun_January 4, 2023_15.07.xlsx",
#                    range = cell_cols(19:511))
# This session was opened to all MTurk workers and had poor quality
data10 <- read_excel("../Data/Main/Main-10_2022_collective_emotion_regulation_fall_yajun_January 19, 2023_16.07.xlsx",
                    range = cell_cols(19:513))
data11 <- read_excel("../Data/Main/Main-11_2022_collective_emotion_regulation_fall_yajun_January 17, 2023_11.53.xlsx",
                    range = cell_cols(19:513))
data12 <- read_excel("../Data/Main/Main-12_2022_collective_emotion_regulation_fall_yajun_January 18, 2023_11.51.xlsx",
                    range = cell_cols(19:513))
data13 <- read_excel("../Data/Main/Main-13_2022_collective_emotion_regulation_fall_yajun_January 19, 2023_12.11.xlsx",
                     range = cell_cols(19:513))
data14 <- read_excel("../Data/Main/Main-14_2022_collective_emotion_regulation_fall_yajun_January 20, 2023_12.05.xlsx",
                     range = cell_cols(19:513))
data15 <- read_excel("../Data/Main/Main-15_2022_collective_emotion_regulation_fall_yajun_January+31,+2023_10.06.xlsx",
                     range = cell_cols(19:513))
data16 <- read_excel("../Data/Main/Main-16_2022_collective_emotion_regulation_fall_yajun_January+31,+2023_11.56.xlsx",
                     range = cell_cols(19:513))
data19 <- read_excel("../Data/Main/Main-19_2022_collective_emotion_regulation_fall_yajun_January+31,+2023_14.52.xlsx",
                     range = cell_cols(19:513))
data20 <- read_excel("../Data/Main/Main-20_2022_collective_emotion_regulation_fall_yajun_January+31,+2023_15.11.xlsx",
                     range = cell_cols(19:513))
data21 <- read_excel("../Data/Main/Main-21_2022_collective_emotion_regulation_fall_yajun_February+3,+2023_13.29.xlsx",
                     range = cell_cols(19:513))
data22 <- read_excel("../Data/Main/Main-22_2022_collective_emotion_regulation_fall_yajun_February+3,+2023_13.34.xlsx",
                     range = cell_cols(19:513))
data23 <- read_excel("../Data/Main/Main-23_2022_collective_emotion_regulation_fall_yajun_February+3,+2023_11.14.xlsx",
                     range = cell_cols(19:513))
data24 <- read_excel("../Data/Main/Main-24_2022_collective_emotion_regulation_fall_yajun_February+9,+2023_07.27.xlsx",
                     range = cell_cols(19:513))
data25 <- read_excel("../Data/Main/Main-25_2022_collective_emotion_regulation_fall_yajun_February+9,+2023_09.47.xlsx",
                     range = cell_cols(19:513))
data26 <- read_excel("../Data/Main/Main-26_2022_collective_emotion_regulation_fall_yajun_February+17,+2023_06.54.xlsx",
                     range = cell_cols(19:513))
data27 <- read_excel("../Data/Main/Main-27_2022_collective_emotion_regulation_fall_yajun_February+19,+2023_19.09.xlsx",
                     range = cell_cols(19:513))
data28 <- read_excel("../Data/Main/Main-28_2022_collective_emotion_regulation_fall_yajun_March+1,+2023_17.09.xlsx",
                     range = cell_cols(19:513))
data29 <- read_excel("../Data/Main/Main-29_2022_collective_emotion_regulation_fall_yajun_March+1,+2023_07.12.xlsx",
                     range = cell_cols(19:513))
data30 <- read_excel("../Data/Main/Main-30_2022_collective_emotion_regulation_fall_yajun_March+1,+2023_15.04.xlsx",
                     range = cell_cols(19:513))
data31 <- read_excel("../Data/Main/Main-31_2022_collective_emotion_regulation_fall_yajun_March+3,+2023_07.17.xlsx",
                     range = cell_cols(19:513))
data32 <- read_excel("../Data/Main/Main-32_2022_collective_emotion_regulation_fall_yajun_March+7,+2023_08.24.xlsx",
                     range = cell_cols(19:513))
data33 <- read_excel("../Data/Main/Main-33_2022_collective_emotion_regulation_fall_yajun_March+9,+2023_07.16.xlsx",
                     range = cell_cols(19:513))
data34 <- read_excel("../Data/Main/Main-34_2022_collective_emotion_regulation_fall_yajun_March+14,+2023_11.01.xlsx",
                     range = cell_cols(19:513))
data35 <- read_excel("../Data/Main/Main-35_2022_collective_emotion_regulation_fall_yajun_March+25,+2023_17.43.xlsx",
                     range = cell_cols(19:513))
data36 <- read_excel("../Data/Main/Main-36_2022_collective_emotion_regulation_fall_yajun_March+25,+2023_17.44.xlsx",
                     range = cell_cols(19:513))
data38 <- read_excel("../Data/Main/Main-38_2022_collective_emotion_regulation_fall_yajun_April+5,+2023_09.28.xlsx",
                     range = cell_cols(19:513))
data39 <- read_excel("../Data/Main/Main-39_2022_collective_emotion_regulation_fall_yajun_April+5,+2023_09.27.xlsx",
                     range = cell_cols(19:513))
data40 <- read_excel("../Data/Main/Main-40_2022_collective_emotion_regulation_fall_yajun_April+10,+2023_08.04.xlsx",
                     range = cell_cols(19:513))


# Select and tidy variables
data_list <- list(pilot1, pilot2, data1, data2, data3, data4, data5, data6, data7, data8,
                  data10, data11, data12, data13, data14, data15, data16,
                  data19, data20, data21, data22, data23, data24, data25,
                  data26, data27, data28, data29, data30, data31, data32,
                  data33, data34, data35, data36, data38, data39, data40) 
use_list <- list()

for (i in 1:length(data_list)){
  datai <- data_list[[i]]
  datai <- datai[-1,]
  datai <- datai %>% 
    select(workerId, female, age, Education, PolAffil, 
           participantCondition, cond, trial_order, solo, endStatus, 
           ends_with("_txt_response"), ends_with("_txt_response2"), 
           ends_with("_rate_response"), ends_with("_rate_response2"), 
           starts_with("RegAtmpt"), starts_with("EmoReg"),
           starts_with("conf"), starts_with("EI_"),
           groupID, studyID, attention_check,
           ends_with("_txt_response_solo"), ends_with("_txt_response_solo2"), 
           ends_with("_rate_response_solo"), ends_with("_rate_response_solo2")) %>% 
    mutate(attention_check = as.character(attention_check))  %>% 
    mutate(exp_i = i-2)
  use_list[[i]] <- datai
  names(use_list)[i] <- paste0("data",i)
}

# Combine datasets
use_dat <- use_list[[1]]
for (i in 2:length(data_list)){
  use_dat <- bind_rows(use_dat, use_list[[i]])
}

# Rename variables
match("endStatus", names(use_dat))
names(use_dat)[1:10] <- c("sub_id", "sex", "age", "edu", "polAffil", 
                          "group_cond", "ind_cond", "img_order", "solo", "complete")

# Create text and rating response variable names
txt_vars = list()
rate_vars = list()
txtsolo_vars = list()
ratesolo_vars = list()
for (i in 1:20){
  txt_vars <- append(txt_vars, paste0("txt",i))
  rate_vars <- append(rate_vars, paste0("rate",i))
  txtsolo_vars <- append(txtsolo_vars, paste0("solotxt",i))
  ratesolo_vars <- append(ratesolo_vars, paste0("solorate",i))
}

names(use_dat)[11:30] <- txt_vars
names(use_dat)[31:50] <- rate_vars
names(use_dat)[89:108] <- txtsolo_vars
names(use_dat)[109:128] <- ratesolo_vars



# Wide to long
textdat <- use_dat %>% 
  select(!starts_with("solorate")) %>% 
  select(!starts_with("solotxt")) %>% 
  select(!starts_with("rate")) %>% 
  pivot_longer(cols = starts_with("txt"),
               names_to = "trial",
               names_prefix = "txt",
               values_to = "txt",
               values_drop_na = TRUE)

ratedat <- use_dat %>% 
  select(!starts_with("solorate")) %>% 
  select(!starts_with("solotxt")) %>% 
  select(!starts_with("txt")) %>% 
  pivot_longer(cols = starts_with("rate"),
               names_to = "trial",
               names_prefix = "rate",
               values_to = "rate",
               values_drop_na = TRUE)


# check the wide-to-long trans
textdat %>%
  count(sub_id) %>%
  arrange(desc(n))%>%
  print(n = 30)

ratedat %>%
  count(sub_id) %>%
  arrange(desc(n))
## ok...we have some duplicated paricipant IDs
## let's check what is happenning with them
ratedat %>%
  filter(sub_id %in% c("A2DAZ6GEZZCNPY","A3C3RFCM98G87E", 
                       "A1WY553JKY79ZF", "A26ZENZ5G8AEGM",
                       "AS4OUUE7SS7L9","AT4S5FAHC5R0D",
                       "A2DF8W7SDWLURD", "APO6E9YYX0JBX",
                      "A1154EZYFNAZUS", "A1XUXY84RLKDTW",
                       "ALNPW5WIO0I", "A2XC32LYCBO8FN",
                        "A3I57NKNGHORVY"

                       )) %>%
  select(sub_id, exp_i) %>%
  group_by(sub_id, exp_i) %>%
  tally() %>%
  arrange(sub_id)
## most duplication happened in experiment 10, when the server crashed
## let's remove the duplicated data from exp 10
ratedat <- ratedat %>%
  filter(!(sub_id %in% c("A2DAZ6GEZZCNPY","A3C3RFCM98G87E", 
                         "A1WY553JKY79ZF", "A26ZENZ5G8AEGM",
                         "AS4OUUE7SS7L9","AT4S5FAHC5R0D",
                         "A2DF8W7SDWLURD", "APO6E9YYX0JBX",
                         "A1154EZYFNAZUS", "A1XUXY84RLKDTW",
                         "A2XC32LYCBO8FN") & exp_i == 10))

textdat <- textdat %>%
  filter(!(sub_id %in% c("A2DAZ6GEZZCNPY","A3C3RFCM98G87E", 
                         "A1WY553JKY79ZF", "A26ZENZ5G8AEGM",
                         "AS4OUUE7SS7L9","AT4S5FAHC5R0D",
                         "A2DF8W7SDWLURD", "APO6E9YYX0JBX",
                         "A1154EZYFNAZUS", "A1XUXY84RLKDTW") & exp_i == 10))

use_dat_l <- full_join(textdat, ratedat, by = c("sub_id", "trial"), suffix = c("", "_dup"))
use_dat_l <- use_dat_l %>% select(!ends_with("_dup"))


# solo data ---------------------------------------------------------------
# Wide to long
solotextdat <- use_dat %>%
  select(!starts_with("rate")) %>% 
  select(!starts_with("txt")) %>% 
  select(!starts_with("solorate")) %>% 
  pivot_longer(cols = starts_with("solotxt"),
               names_to = "trial",
               names_prefix = "solotxt",
               values_to = "txt",
               values_drop_na = TRUE)

soloratedat <- use_dat %>% 
  select(!starts_with("rate")) %>% 
  select(!starts_with("txt")) %>% 
  select(!starts_with("solotxt")) %>% 
  pivot_longer(cols = starts_with("solorate"),
               names_to = "trial",
               names_prefix = "solorate",
               values_to = "rate",
               values_drop_na = TRUE)

# check duplication
soloratedat %>%
  count(sub_id) %>%
  arrange(desc(n))

soloratedat <- soloratedat %>%
  filter(!(sub_id %in% c("A4UNDRBUCSQJ0", "A8OGKR1FGWP95", "A2V0E2PM28W414")))
solotextdat <- solotextdat %>%
  filter(!(sub_id %in% c("A4UNDRBUCSQJ0", "A8OGKR1FGWP95", "A2V0E2PM28W414")))
  

solo_dat_l <- full_join(solotextdat, soloratedat, by = c("sub_id", "trial"), suffix = c("", "_dup"))
solo_dat_l <- solo_dat_l %>% select(!ends_with("_dup"))


table(solo_dat_l$ind_cond)
table(solo_dat_l$group_cond)
solo_dat_l$group_cond <- solo_dat_l$ind_cond



# Image order -------------------------------------------------------------

imgs <- list()

for (i in 1:20) {
  imgname <- paste0("img", i)
  imgs <- append(imgs, imgname)
} 

imgs <- unlist(imgs)

imgdata <- use_dat %>% 
  select(sub_id, img_order, exp_i) %>% 
  separate(col = img_order, into = imgs, sep = ",") %>% 
  pivot_longer(cols = starts_with("img"),
               names_to = "trial",
               names_prefix = "img",
               values_to = "img",
               values_drop_na = TRUE) %>% 
  filter(!(sub_id %in% c("A2DAZ6GEZZCNPY","A3C3RFCM98G87E", 
                         "A1WY553JKY79ZF", "A26ZENZ5G8AEGM",
                         "AS4OUUE7SS7L9","AT4S5FAHC5R0D",
                         "A2DF8W7SDWLURD", "APO6E9YYX0JBX",
                         "A1154EZYFNAZUS", "A1XUXY84RLKDTW") & exp_i == 10))
# Check duplication
imgdata_dupid <- imgdata %>%
  count(sub_id) %>%
  filter(n > 20) %>%
  select(sub_id)

as.vector(imgdata_dupid)$sub_id

imgdata %>%
  filter(sub_id %in% as.vector(imgdata_dupid)$sub_id) %>%
  select(sub_id, exp_i) %>%
  group_by(sub_id, exp_i) %>%
  tally() %>%
  arrange(desc(n)) %>%
  print(n = 25)


imgdata <- imgdata %>%
  filter(!(sub_id %in% c("A10G8U9316K46H", "A121YWZJNUUZRJ", ) & exp_i == 10)) %>%
  filter(!(sub_id %in% c("A8OGKR1FGWP95") & exp_i == 16))

use_dat_l <- left_join(use_dat_l, imgdata, by = c("sub_id", "trial", "exp_i"), suffix = c("", "_dup"))
solo_dat_l <- left_join(solo_dat_l, imgdata, by = c("sub_id", "trial"), suffix = c("", "_dup"))




# Further cleaning grouped dta --------------------------------------------

# Change variable types
str(use_dat_l)
table(use_dat_l$rate)
use_dat_l <- use_dat_l %>%
  mutate(rate = replace(rate, 
                        rate=="1\nNo negative emotion"|rate =="1\r\nNo negative emotion"|rate=="1No negative emotion", 1)) %>%
  mutate(rate = replace(rate, 
                        rate=="10\nVery strong negative emotion"|rate =="10\r\nVery strong negative emotion", 10)) %>%
  mutate(grp_method = "observing", grp_goal = "non_motivated", subgrp = "treatment") %>%
  mutate(grp_method = replace(grp_method, group_cond == "reapp_target"|group_cond == "reapp", "reappraisal"),
         grp_goal = replace(grp_goal, group_cond == "reapp_target"|group_cond == "target", "motivated"),
         subgrp = replace(subgrp, ind_cond == "control", "control")) %>%
  mutate_at(vars(sub_id, grp_method, grp_goal, subgrp, trial), factor) %>%
  mutate(rate = as.numeric(rate))

solo_dat_l <- solo_dat_l %>%
  mutate(rate = replace(rate, 
                        rate=="1\nNo negative emotion"|rate =="1\r\nNo negative emotion"|rate=="1No negative emotion", 1)) %>%
  mutate(rate = replace(rate, 
                        rate=="10\nVery strong negative emotion"|rate =="10\r\nVery strong negative emotion", 10)) %>%
  mutate_at(vars(sub_id, trial), factor) %>%
  mutate(rate = as.numeric(rate))


# Create unique group ID
use_dat_l$groupID <- paste0(use_dat_l$studyID, "-", use_dat_l$groupID)
  
# check variables
use_dat_l %>%
  count(sub_id) %>%
  arrange(desc(n))

table(use_dat_l$groupID)
table(use_dat_l$grp_method)
table(use_dat_l$grp_goal)
table(use_dat_l$subgrp)
table(use_dat_l$trial)
table(use_dat_l$img)
 
summary(use_dat_l$rate)

hist(use_dat_l$rate)


# Output dataset ----------------------------------------------------------
write.csv(use_dat_l, "../Data/emoReg_clean.csv", row.names = F)
write.csv(solo_dat_l, "../Data/emoReg_clean_solo.csv", row.names = F)

#write.csv(use_dat_l, "../Data/emoReg_unclean.csv", row.names = F)
