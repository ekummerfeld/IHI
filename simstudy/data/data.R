library(readr)
data <- read_csv("~/work/IHI/simstudy/data/data.tsv")
data$nv <- as.factor(data$nv)
data$Alg <- factor(data$Alg, labels = c("FGES", "PC-Sa001", "PC-Sa005"))
library(ggplot2)

ggplot(data,aes(sampleSize,SHD, group = nv, col= nv)) + geom_point() + geom_line()+ facet_wrap(~Alg) + theme_classic()


