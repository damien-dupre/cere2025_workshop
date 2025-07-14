# effects visualisation --------------------------------------------------------
df_congruency |> 
  group_by(method, instruction) |> 
  summarise(mean_se(congruency)) |> 
  ggplot() + 
  aes(
    x = fct_reorder(instruction, y, .fun = "mean"),
    y = y,
    ymin = ymin,
    ymax = ymax,
    fill = method,
    shape = method
  ) +
  ggstats::geom_stripped_cols() +
  geom_errorbar(width = 0, position = position_dodge(width = 0.8)) +
  geom_point(stroke = 0, size = 4, position = position_dodge(width = 0.8)) +
  scale_y_continuous("Congruence between instruction and recognition", limits = c(0, 1), labels = scales::percent) +
  scale_x_discrete("") +
  scale_fill_brewer("Method", palette = "Dark2") +
  scale_shape_manual("Method", values = c(21, 22, 23, 24)) +
  guides(
    shape = guide_legend(reverse = TRUE, position = "inside"),
    fill = guide_legend(reverse = TRUE, position = "inside")
  ) +
  theme_bw() +
  theme(
    text = element_text(size = 12),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.line.y = element_blank(),
    legend.title = element_text(hjust = 0.5),
    legend.position.inside = c(0.8, 0.2),
    legend.background = element_rect(fill = "grey80")
  ) +
  coord_flip(ylim = c(0, 1)) 

# effects statistics -----------------------------------------------------------
report(model)