
# Preprocessing -----------------------------------------------------------

all_data <- read_csv("YOUR_PATH")

text_data <- all_data %>% 
  select(sub_id, groupID, studyID, subgrp, group_cond, 
         grp_goal, grp_method, trial, img, txt) # replace with your variables names

forEmbed <- text_data %>%
  mutate(txt = str_replace_all(txt, "&quot;","\"")) %>%  #fix encoding of duoblequotes char.
  arrange(txt) %>%
  drop_NA() %>%
  drop_empty_row() %>%
  mutate(clean_text = txt %>%
           strip() %>%
           replace_html() %>%
           replace_symbol() %>%
           replace_white() %>%
           add_comma_space() %>%
           #mgsub(pattern = "\\sו",replacement = " ", fixed = F) %>%  
           #mgsub(pattern = "\\sו\\s",replacement = "", fixed = F) %>%
           mgsub(pattern = "'",replacement = "", fixed = T) %>%
           mgsub(pattern = '"',replacement = "", fixed = T) %>%
           {.}
  ) %>%
  drop_empty_row() %>%
  filter(clean_text != "") %>%
  {.}

head(forEmbed$clean_text)

write.csv(forEmbed, "YOUR_PATH")


# Go to Python to process embeddings based on the cleaned data

# Embedding data analysis -------------------------------------------------

bert_data <- read_csv("YOUR_PATH")
head(bert_data)

# Calculate reappraisal semantics
base_line <- bert_data %>%
  filter((group_cond == "reapp" & subgrp == "treatment") | group_cond == "control") %>% # Subset the two groups you want to compare
  group_by(group_cond) %>%
  summarize(across(starts_with("embed"),~mean(.x))) %>% # get the average embeddings of the two groups, respectively
  pivot_longer(-group_cond, names_to = "dim", values_to = "base_line") %>% 
  pivot_wider(values_from = base_line, names_from = group_cond, names_prefix = "base_") %>% # Put dimensions to rows (long) and the two groups to columns (wide)
  rowwise() %>%
  mutate(base_line = base_reapp - base_control) %>%
  ungroup()

#saveRDS(base_line, here("YOUR_PATH/base_line.rds"))

# Calculate each observation's distance to the reappraisal semantics
distance <- bert_data %>%
  pivot_longer(starts_with("embed"), names_to = "dim", values_to = "embed_value") %>%
  left_join(base_line, "dim") %>%
  group_by(group_cond, subgrp, grp_goal, grp_method, groupID, img, trial, sub_id) %>%
  summarise(dist = 1- cosine(embed_value, base_line),
            .groups = "drop")

#saveRDS(distance, here("YOUR_PATH/distance.rds"))

