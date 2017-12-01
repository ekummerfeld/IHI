setwd("~/work/RAISE")

library(lavaan)
library(readr)
library(mice)
library(tidyr)
library(dplyr)
library(ggplot2)
library(reshape2)

RAISE_SRF_B <- read_csv("./RAISE_SRF_B.csv")
RAISE_ALL <- read_csv("./alldata.csv")

# turn NaNs into NAs
library("parallel")
RAISE_ALL<-  as.data.frame(
  mclapply(RAISE_ALL, function(x) {ifelse(is.nan(x), NA, x)}
  )
)
RAISE_ALL$Subject_ID <- NULL

library(VIM)
aggr(VARS_WE_CARE_ABOUT, col=c('navyblue','red'), numbers=T, sortVars=TRUE, labels=names(VARS_WE_CARE_ABOUT), 
     cex.axis=.7, gap=0, ylab=c("Histogram of missing data","Pattern"))

# hack to drop rows that are missing all the values

RAISE_SRF_B <- RAISE_SRF_B %>% drop_na(SRF014.B)

cor <- cor(select(RAISE_SRF_B, c(SRF026.B, SRF006.B, SRF022.B, SRF030.B, SRF072.B, SRF062.B, SRF063.B)), use = "pairwise")
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

cor <- cor(select(RAISE_SRF_B, c(SRF026.B, SRF006.B, SRF022.B, SRF030.B, SRF072.B, SRF062.B, SRF063.B)), use = "pairwise")
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

cor <- cor(select(RAISE_SRF_B, c(SRF004.B, SRF010.B, SRF033.B, SRF035.B, SRF002.B)), use = "pairwise")
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

cor <- cor(select(RAISE_SRF_B, c(SRF018.B, SRF032.B, SRF001.B, SRF039.B, SRF064.B, SRF071.B)), use = "pairwise")
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

cor <- cor(select(RAISE_SRF_B, c(SRF061.B, SRF020.B, SRF003.B, SRF038.B, SRF070.B, SRF065.B)), use = "pairwise")
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

cor <- cor(is.na(RAISE_SRF_B))
cor <- ifelse(is.na(cor), 0, cor)
melt_cor <- melt(cor)

ggplot(melt_cor,aes(x=Var1,y=Var2, fill = value)) + 
  geom_tile() +  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()

IMP <-mice(RAISE_SRF_B, printFlag = F)

library(foreach)
foo<- foreach(i=1:5, '+') %do% {
  RAISE_IMP <- mice::complete(IMP, i)
  
  lv.model <- 'L9 =~ SRF026.B + SRF006.B + SRF022.B + SRF030.B + SRF072.B + SRF062.B + SRF063.B
             L10 =~ SRF004.B + SRF010.B + SRF033.B + SRF035.B + SRF002.B
             L7 =~ SRF018.B + SRF032.B + SRF001.B + SRF039.B + SRF064.B + SRF071.B
             L4 =~ SRF061.B + SRF020.B + SRF003.B + SRF038.B + SRF070.B + SRF065.B
            '
  fit <- cfa(lv.model, data=RAISE_IMP)
  inspect(fit, "cor.lv")
  
  predict(fit)
}
summary(fit)
latents<-foo[[1]]/5

RAISE_PLUS_LATENTS <- cbind(RAISE_SRF_B, latents)

summary(fit)

cov(RAISE_PLUS_LATENTS$L10, RAISE_PLUS_LATENTS$L9)

