# csv processing ---------------------------------------------------------------
library(tidyverse)

df <- "/Users/damienhome/Drive/Projects/emotion_recognition_differences/data/au_emotion_resample.rds" |> 
  readRDS() |> 
  filter(system == "affectiva") |> 
  select(id = ID, label_emotion, frame, value) |> 
  pivot_wider(names_from = label_emotion, values_from = value)

list_id <- unique(df$id)

list_id |> 
  walk(~ df |> 
    filter(id == .x) |> 
    select(-id) |> 
    write_csv(glue::glue("{.x}.csv"))
)

# data wrangling ---------------------------------------------------------------
library(fs)

df <- 
  "/Users/damienhome/Drive/Projects/cere2025_workshop/data/selected" |> 
  dir_ls(glob = "*.csv") |> # regexp = "\\.au_class$", recursive = TRUE
  map_dfr(readr::read_csv, .id = "source")

df_tidy_wide <- df |> 
  mutate(source = source |> path_file() |> path_ext_remove())

df_tidy_long <- df_tidy_wide |> 
  pivot_longer(-c(source, frame))

list_source <- unique(df_tidy_long$source)

df_example <- df_tidy_long |> 
  filter(source == list_source[1])

ggplot(df_example) +
  