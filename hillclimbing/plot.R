library(readr)
library(tidyverse)
vanilla_data <- read_csv("~/work/IHI/hillclimbing/results/tetrad_sim2.csv")
hc_data <- read_csv("~/work/IHI/hillclimbing/results/hc_sim2.csv")

vd <- vanilla_data %>% select(-c(SHD))


df <- rbind(hc_data,vd)


df$Alg <- as.factor(df$Alg)
levels(df$Alg) <- c("FGES, MVPBIC", "PC-S, FZ(a = .01)", "GFCI, FZ(a = .01)\nand MVPBIC", 
                    "Boostrapped HC\n(B = 100, R = 5, P = 10)", "HC (R = 5, P = 10)")
df$Vars <- as.factor(df$numMeasures)


ggplot(df, aes( x = sampleSize, y = log(E), color = Alg)) + geom_line() + 
  facet_wrap(~Vars, labeller = label_both) +
  labs(title = "Comparison of Hillclimbing to Various Causal Discovery Algorithms", color = "Algorithm") +
  theme(legend.key.size = unit(1.5, "lines"))



ggplot(df, aes( x = sampleSize, y = AP, color = Alg)) + geom_line(data=df[df$Alg != "Boostrapped HC\n(B = 100, R = 5, P = 10)",]) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize < 10000,]) +
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars == 100,], linetype = 2) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars != 100,]) + 
  facet_wrap(~Vars, labeller = label_both) +
  labs(title = "Comparison of Hillclimbing to Various Causal Discovery Algorithms", color = "Algorithm") +
  theme(legend.key.size = unit(1.5, "lines"))
ggplot(df, aes( x = sampleSize, y = AR, color = Alg)) + geom_line(data=df[df$Alg != "Boostrapped HC\n(B = 100, R = 5, P = 10)",]) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize < 10000,]) +
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars == 100,], linetype = 2) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars != 100,]) + 
  facet_wrap(~Vars, labeller = label_both) +
  labs(title = "Comparison of Hillclimbing to Various Causal Discovery Algorithms", color = "Algorithm") +
  theme(legend.key.size = unit(1.5, "lines"))
ggplot(df, aes( x = sampleSize, y = AHP, color = Alg)) + geom_line(data=df[df$Alg != "Boostrapped HC\n(B = 100, R = 5, P = 10)",]) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize < 10000,]) +
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars == 100,], linetype = 2) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars != 100,]) + 
  facet_wrap(~Vars, labeller = label_both) +
  labs(title = "Comparison of Hillclimbing to Various Causal Discovery Algorithms", color = "Algorithm") +
  theme(legend.key.size = unit(1.5, "lines"))
ggplot(df, aes( x = sampleSize, y = AHR, color = Alg)) + geom_line(data=df[df$Alg != "Boostrapped HC\n(B = 100, R = 5, P = 10)",]) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize < 10000,]) +
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars == 100,], linetype = 2) + 
  geom_line(data=df[df$Alg == "Boostrapped HC\n(B = 100, R = 5, P = 10)" & df$sampleSize > 500 & df$Vars != 100,]) + 
  facet_wrap(~Vars, labeller = label_both) +
  labs(title = "Comparison of Hillclimbing to Various Causal Discovery Algorithms", color = "Algorithm") +
  theme(legend.key.size = unit(1.5, "lines"))
