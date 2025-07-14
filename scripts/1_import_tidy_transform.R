# install packages (only once) -------------------------------------------------
install.packages("tidyverse")
install.packages("fs")
install.packages("here")
install.packages("report")

# load packages ----------------------------------------------------------------
library(tidyverse)
library(fs) 
library(here) 
library(report)

# combine all .csv files -------------------------------------------------------
df <- 
  dir_ls(path = here("data"), glob = "*.csv") |>
  map_dfr(read_csv, .id = "source")

# tidy the data object ---------------------------------------------------------
df_tidy <- df |> 
  mutate(file = source |> path_file() |> path_ext_remove(), .keep	= "unused") |> 
  separate(col = file, into = c("ppt", "instruction"), sep = "_", remove = FALSE) |> 
  mutate(instruction = instruction |> 
           tolower() |> 
           str_replace_all(c("happy" = "happiness", "sad" = "sadness", "angry" = "anger"))
  )

# pivot the data from wide to long ---------------------------------------------
df_tidy_long <- df_tidy |> 
  pivot_longer(
    cols = c(anger, disgust, fear, happiness, sadness, surprise),
    names_to = "emotion",
    values_to = "recognition"
  )

# observe the 10 first rows of `df_tidy_long` ----------------------------------
head(df_tidy_long, 10)