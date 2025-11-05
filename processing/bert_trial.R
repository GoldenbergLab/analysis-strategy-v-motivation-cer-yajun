if(!suppressWarnings(require(pacman))){install.packages("pacman");library("pacman")}
p_load(tidyverse, here, text, textclean, furrr, coop, patchwork)
here::i_am("processing/bert_trial.R")
# reticulate::conda_create(envname = "./bert_conda")
# textrpp_install(envname = 'bert_conda')
reticulate::use_condaenv(condaenv = './bert_conda')


#{new_base_line <- readRDS(here("data/trial_new_base_line.rds"))
#embeddings <- readRDS(here("data/ID_trial_embeddings.rds"))
#embeddings_dists <- readRDS(here("data/trial_embeddings_dists.rds"))
#embeddings_actual <- readRDS(here("data/trial_embeddings_actual.rds"))
#embeddings_dists_actual <- readRDS(here("data/trial_embeddings_dists_actual.rds"))}


plan(multisession, workers = 4)

emoreg_dat <- read_csv("../Data/emoReg_clean.csv")
emoreg_solo_dat <- read_csv("../Data/emoReg_clean_solo.csv")

emoreg_dat <- emoreg_dat %>% 
  filter(is.na(attention_check)) %>%
  filter(complete == "complete"|complete == "completed")

emoreg_solo_dat <- emoreg_solo_dat %>% 
  filter(is.na(attention_check)) %>%
  filter(complete == "complete"|complete == "completed")

text_data <- emoreg_dat %>% select(sub_id, groupID, studyID, subgrp,
                                   group_cond, grp_goal, grp_method, trial, img, txt)

text_solo_data <- emoreg_solo_dat %>% select(sub_id, groupID, studyID, group_cond, trial, img, txt)


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
    #select(-txt) %>%
    filter(clean_text != "") %>%
    {.}

head(forEmbed$clean_text)

forEmbed_solo <- text_solo_data %>%
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
  #select(-txt) %>%
  filter(clean_text != "") %>%
  {.}

head(forEmbed_solo$clean_text)

write.csv(forEmbed, "../Processing/clean_text_data.csv")
write.csv(forEmbed_solo, "../Processing/clean_text_solo_data.csv")


# concatenate at the ind-level

forEmbed_concat <- forEmbed %>%
  group_by(sub_id, studyID) %>%
  mutate(concat_text = paste0(clean_text, collapse = " "))  %>%
  ungroup() %>%
  select(sub_id, groupID, subgrp, group_cond, grp_goal, grp_method, concat_text) %>%
  distinct(concat_text, .keep_all = T)

forEmbed_concat %>% 
  group_by(sub_id) %>% tally() %>% arrange(desc(n))

write.csv(forEmbed_concat, "concat_text_data.csv", row.names = F)



# all_control_text <- forBert %>% filter(proportion_orig == 0) %>%
#     # slice_sample(n=2) %>%
#     pull(clean_text) %>% paste(collapse = "\n")
# all_reapp_text <- forBert %>% filter(proportion_orig == 1) %>%
#     # slice_sample(n=2) %>%
#     pull(clean_text) %>% paste(collapse = "\n")


# using AlephBERT
# control_embedded <- textEmbed(all_control_text, model = 'onlplab/alephbert-base')
# reapp_embedded <- textEmbed(all_reapp_text, model = 'onlplab/alephbert-base')
#
# base_line <- control_embedded$x[1,] %>%
#     t() %>%
#     as_tibble(rownames = "dim",.name_repair = "universal") %>%
#     rename(control = `...1`) %>%
#     left_join(reapp_embedded$x[1,] %>%
#                   t() %>%
#                   as_tibble(rownames = "dim",.name_repair = "universal") %>%
#                   rename(reapp = `...1`)) %>%
#     rowwise() %>%
#     mutate(base_line = mean(c(control,reapp))) %>%
#     select(dim,base_line)

# saveRDS(base_line, here("data/base_line.rds"))
textEmbed(forEmbed$clean_text, model = 'bert-base-uncased',layers = 11)

### ALLOCATED PROPORTION

embeddings <-
  forEmbed %>%
    # slice_sample(n=50) %>%
    mutate(embeddings = future_map(clean_text, ~textEmbed(.x, model = 'bert-base-uncased',layers = 11, contexts = F),.progress = T)) %>%
    select(-clean_text)
saveRDS(embeddings, here("data/ID_trial_embeddings.rds"))

    # group_by(condition, proportion_orig,group,trial, ID) %>%
new_base_line <-
    embeddings %>%
        filter(proportion_orig %in% c(0,1)) %>%
        mutate(embeddings = future_map(embeddings, "x",.progress = T)) %>%
        # mutate(embeddings = map(embeddings, "x")) %>%
        unnest_wider(embeddings) %>%
        group_by(proportion_orig) %>%
        summarize(across(starts_with("Dim"),~mean(.x))) %>%
        pivot_longer(-proportion_orig,names_to = "dim", values_to = "base_line") %>%
        pivot_wider(values_from = base_line, names_from = proportion_orig, names_prefix = "base_line") %>%
        rowwise() %>%
        mutate(base_line = base_line1 - base_line0) %>%
        ungroup()

saveRDS(new_base_line, here("data/ID_trial_new_base_line.rds"))

embeddings_dists <- embeddings %>%
    # slice_head(n=12) %>%
    mutate(embeddings = future_map(embeddings, "x",.progress = T)) %>%
    mutate(embeddings = future_map(embeddings, ~(t(.x) %>%
                                              as_tibble(rownames = "dim",.name_repair = "minimal",) %>%
                                              setNames(c("dim","embedd"))),.progress = T)) %>%
    unnest(embeddings) %>%
    left_join(new_base_line, "dim") %>%
    group_by(condition, proportion_orig,group,trial, ID) %>%
    summarise(dist = 1 - cosine(embedd,base_line),
              .groups = "drop")

saveRDS(embeddings_dists, here("data/ID_trial_embeddings_dists.rds"))

# new_base_line <- readRDS(here("data/trial_new_base_line.rds"))
# embeddings <- readRDS(here("data/trial_embeddings.rds"))
# embeddings_dists <- readRDS(here("data/trial_embeddings_dists.rds"))




### ACTUAL PROPORTION

embeddings_dists_actual <- embeddings %>%
    # slice_head(n=12) %>%
    mutate(embeddings = future_map(embeddings, "x",.progress = T)) %>%
    mutate(embeddings = future_map(embeddings, ~(t(.x) %>%
                                                     as_tibble(rownames = "dim",.name_repair = "minimal",) %>%
                                                     setNames(c("dim","embedd"))),.progress = T)) %>%
    unnest(embeddings) %>%
    left_join(new_base_line, "dim") %>%
    group_by(condition, actual_prop_orig,group,trial, ID) %>%
    summarise(dist = 1 - cosine(embedd,base_line),
              .groups = "drop")

saveRDS(embeddings_dists_actual, here("data/ID_trial_embeddings_dists_actual.rds"))

# embeddings_actual <- readRDS(here("data/trial_embeddings_actual.rds"))
# embeddings_dists_actual <- readRDS(here("data/trial_embeddings_dists_actual.rds"))

ylims <-NULL
my_method = "loess"
span= 1
fig_dim_h <- 10; fig_dim_v <- 7

base_plot_theme <-
    theme_bw()+
    theme(
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = 'white'),
        legend.title.align=0.5,
        legend.title =  element_text(colour = 'white'),
        legend.text = element_text(colour = 'black'),
        panel.grid = element_blank(),
        legend.background= element_rect(fill="white", colour=NA),
        plot.title = element_text(size = rel(1.3),hjust =.5, colour = 'black'),
        axis.title.y = element_text(face="bold",  size=14,colour = "black"),
        axis.text.x  = element_text( vjust=0.5, size=14,colour = "black", angle = 45),
        axis.text.y  = element_text( vjust=0.5, size=16,colour = "black"),
        axis.title.x = element_text(face="bold",  size=14,colour = "black"))

plot_dists <- function(dist,dist_label) {

     plot_dists_allocated <- ggplot(embeddings_dists %>%
                                       filter(!proportion_orig %in% c(0,1)) %>%
                                       mutate(proportion_orig = factor(proportion_orig %>% round(2))),
                                   aes(fill=condition, y={{dist}}, x=proportion_orig)) +
        coord_cartesian(ylim = ylims) +
        geom_smooth(aes(color = condition, group = condition), method=my_method, span = span) +
        base_plot_theme +
        scale_color_manual(values=c("#99CCFF", "#FF9999", "#66cc60"))+
        scale_fill_manual(values = c("grey","grey"))+
        ylab(paste("Cosine Distance from", dist_label)) +
        xlab("Allocated Proportion")

    plot_dists_actual <-
        ggplot(embeddings_dists_actual %>%
                   filter(!actual_prop_orig %in% c(0,1)) %>%
                   mutate(actual_prop_orig = actual_prop_orig %>% round(2)),
               aes(fill=condition, y={{dist}}, x=actual_prop_orig)) +
        geom_smooth(aes(color = condition, group = condition), method=my_method, span = span) +
        base_plot_theme +
        coord_cartesian(ylim = ylims) +
        scale_color_manual(values=c("#99CCFF", "#FF9999", "#66cc60"))+
        scale_fill_manual(values = c("grey","grey"))+
        ylab(paste("Cosine Distance from", dist_label)) +
        xlab("Actual Proportion")

    plot_dists_actual + plot_dists_allocated

}
plot_dists(dist, "Semantic Mean")
ggsave(here("figures","cosine dists.pdf"), width = fig_dim_h, height = fig_dim_v)

embeddings_dists_actual %>%
           filter(!actual_prop_orig %in% c(0,1)) %>%
            left_join(task_no_suspected %>% select(ID,trial,img), by = c("trial", "ID")) %>%
    lme4::lmer(data = .,dist ~ condition * actual_prop_orig + (1|trial) + (1|img) + (1|group) + (1|group:ID)) %>%
    parameters::model_parameters(standardize = "refit")
