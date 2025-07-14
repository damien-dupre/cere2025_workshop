recording_n <- 3
instruction_n <- 3

# single recording -------------------------------------------------------------
list_file <- unique(df_tidy_long$file)

df_tidy_long |> 
  filter(file == list_file[recording_n]) |> 
  ggplot() +
  aes(x = frame, y = recognition, colour = emotion) +
  geom_line(linewidth = 2) +
  theme_bw() +
  theme(legend.position = "bottom") +
  scale_y_continuous(limits = c(0, 1)) +
  scale_color_brewer(palette = "Dark2")

# all recordings for one instruction -------------------------------------------
list_instruction <- unique(df_tidy_long$instruction)

df_tidy_long |> 
  filter(instruction == list_instruction[instruction_n]) |> 
  ggplot() +
  aes(x = frame, y = recognition, group = ppt, colour = emotion) +
  geom_line(linewidth = 1) +
  facet_grid(emotion ~ ., switch = "x") +
  theme_bw() +
  theme(legend.position = "bottom") +
  scale_y_continuous(limits = c(0, 1), breaks = c(0, 0.5, 1)) +
  scale_color_brewer(palette = "Dark2")
