library(tidyverse)
setwd("work/IHI/schiz")
Schiz_data_for_test_validation_062917_1 <- read_csv("data/Schiz data for test-validation_062917-1.csv")

nm <- names(Schiz_data_for_test_validation_062917_1)

cog_sym_scores <- Schiz_data_for_test_validation_062917_1 %>% select(
  grep("global.|sop.|ver_wm.|vis_wm.|wm.|ver_lrn.|ver_mem.|vis_lrn.|vis_mem.|Tto|PTotal|PPosT|PNegT|PGenT", nm, value = T)
)

write_csv(cog_sym_scores,"data/cog_sym_scores.csv")
