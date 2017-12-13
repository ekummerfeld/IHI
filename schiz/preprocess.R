library(tidyverse)
setwd("~/IHI/schiz")
Schiz_data_for_test_validation_062917_1 <- read_csv("data/Schiz data for test-validation_062917-1.csv")

nm <- names(Schiz_data_for_test_validation_062917_1)
# select relevant variables
cog_sym_scores <- Schiz_data_for_test_validation_062917_1 %>% select(
  grep("global.|sop.|ver_wm.|vis_wm.|wm.|ver_lrn.|
       ver_mem.|vis_lrn.|vis_mem.|Tto|PTotal|PPosT|PNegT|PGenT", nm, value = T)
)

write_csv(cog_sym_scores, "data/cog_sym_scores.csv")

# missing data pattern
library(VIM)
aggr(cog_sym_scores, numbers = T, sortVars = TRUE, labels = names(cog_sym_scores),
     cex.axis=.7, gap=0, ylab=c("Histogram of missing data","Pattern"))


cog_sym_scores_no_na <- na.omit(cog_sym_scores)
write_csv(cog_sym_scores_no_na, "data/cog_sym_scores_no_na.csv")


normalize <- function(df) {
  as.data.frame(apply(df, 2, function(x) {
    mu <- mean(x)
    sd <- sd(x)
    return((x-mu)/sd)
  }))
}

# select relevant varaibles
pre_treatment_cog_sym_scores_no_na <- cog_sym_scores_no_na %>% 
  select(grep("1$", names(cog_sym_scores_no_na), value = T))

# normalize
pre_treatment_cog_sym_scores_no_na <- normalize(pre_treatment_cog_sym_scores_no_na)
# write to file
write_csv(pre_treatment_cog_sym_scores_no_na, "data/pre_treatment_cog_sym_scores_no_na.csv")


post_treatment_cog_sym_scores_no_na <- cog_sym_scores_no_na %>% 
  select(grep("2$", names(cog_sym_scores_no_na), value = T))

post_treatment_cog_sym_scores_no_na <- normalize(post_treatment_cog_sym_scores_no_na)
write_csv(post_treatment_cog_sym_scores_no_na, "data/post_treatment_cog_sym_scores_no_na.csv")


diff_cog_sym_scores_no_na <- cog_sym_scores_no_na %>% 
  select(grep("_mean$", names(cog_sym_scores_no_na), value = T))
diff_cog_sym_scores_no_na <- normalize(diff_cog_sym_scores_no_na)
write_csv(diff_cog_sym_scores_no_na, "data/diff_cog_sym_scores_no_na.csv")

