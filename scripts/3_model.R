# matching score ---------------------------------------------------------------
df_score_matching <- df_tidy_long |> 
  # keep only the frame with the highest value in each ties
  group_by(file) |> 
  filter(recognition == max(recognition)) |> 
  # in case of ties, label the emotions "undetermined" and remove duplicates
  add_count() |> 
  mutate(emotion = case_when(n != 1 ~ "undetermined", .default = emotion)) |> 
  select(file, emotion) |> 
  distinct() |> 
  # label the method
  mutate(method = "matching score")

# confidence score -------------------------------------------------------------
df_score_confidence <- df_tidy_long |> 
  # calculate the average value for each emotion in each file and keep the highest
  group_by(file, emotion) |> 
  summarise(mean_emotion = mean(recognition, na.rm = TRUE)) |> 
  slice_max(mean_emotion) |> 
  # in case of ties, label the emotions "undetermined" and remove duplicates
  add_count() |> 
  mutate(emotion = case_when(n != 1 ~ "undetermined", .default = emotion)) |> 
  select(file, emotion) |> 
  distinct() |> 
  # label the method
  mutate(method = "confidence score")

# frame score ------------------------------------------------------------------
df_score_frame <- df_tidy_long |> 
  # in each file, for each frame, find the highest value
  group_by(file, frame) |>
  slice_max(recognition) |> 
  # in case of ties, label the emotions "undetermined" and remove duplicates
  add_count(name = "n_frame") |> 
  mutate(emotion = case_when(n_frame != 1 ~ "undetermined", .default = emotion)) |> 
  select(file, frame, emotion) |> 
  distinct() |> 
  # count the occurrence of each emotion across all frames and select highest
  group_by(file, emotion) |> 
  count() |> 
  group_by(file) |> 
  slice_max(n) |> 
  # in case of ties, label the emotions "undetermined" and remove duplicates
  add_count(name = "n_file") |> 
  mutate(emotion = case_when(n_file != 1 ~ "undetermined", .default = emotion)) |> 
  select(file, emotion) |> 
  distinct() |> 
  # label the method
  mutate(method = "frame score")

# congruency calculation -------------------------------------------------------
df_congruency <- 
  bind_rows(
    df_score_matching, 
    df_score_confidence,
    df_score_frame
  ) |> 
  separate(col = file, into = c("ppt", "instruction"), sep = "_", remove = FALSE) |> 
  mutate(
    instruction = instruction |> 
      tolower() |> 
      str_replace_all(c("happy" = "happiness", "sad" = "sadness", "angry" = "anger")),
    congruency = if_else(instruction == emotion, 1, 0)
  )

# Generalized Linear Model -----------------------------------------------------
model <- df_congruency |> 
  glm(
    congruency ~ method*instruction, 
    data = _, 
    family = binomial
  ) |> 
  aov()

summary(model)