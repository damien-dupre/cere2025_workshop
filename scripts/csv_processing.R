# csv processing ---------------------------------------------------------------
library(tidyverse)
library(janitor)
df_names <- read_csv("/Users/damienhome/Downloads/data_machine_challenge/BU-4DFE.csv") |> 
  clean_names() |> 
  select(filename, original_filename)

df <- "/Users/damienhome/Drive/Projects/emotion_recognition_differences/data/au_emotion_resample.rds" |> 
  readRDS() |> 
  filter(system == "affectiva") |> 
  left_join(df_names, by = join_by(ID == filename)) |> 
  select(id = original_filename, label_emotion, frame, value) |> 
  pivot_wider(names_from = label_emotion, values_from = value)

list_id <- unique(df$id)

list_id |> 
  walk(~ df |> 
    filter(id == .x) |> 
    select(-id) |> 
    write_csv(glue::glue(here::here("data/{.x}.csv")))
)

# data wrangling ---------------------------------------------------------------
library(fs)

df <- 
  dir_ls(path = "data", glob = "*.csv") |> # list all csv files in folder "data"
  map_dfr(readr::read_csv, .id = "source") # read the files and merge them one after the other

df_tidy_wide <- df |> 
  mutate(source = source |> path_file() |> path_ext_remove())

df_tidy_long <- df_tidy_wide |> 
  pivot_longer(-c(source, frame))

list_source <- unique(df_tidy_long$source)

df_example <- df_tidy_long |> 
  filter(source == list_source[1])

ggplot(df_example) +
  