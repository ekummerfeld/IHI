library(tidyverse)
RAISE_LAT <- read_csv("./RAISE_LAT.csv")

normalize <- function(df) {
  as.data.frame(apply(df, 2, function(x) {
    mu <- mean(x)
    sd <- sd(x)
    return((x-mu)/sd)
  }))
}

QLSTS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|QLSTS.B", names(RAISE_LAT), value = T))
QLSTS_LAT <- na.omit(QLSTS_LAT)
#QLSTS_LAT <- normalize(QLSTS_LAT)
ggplot(QLSTS_LAT, aes(QLSTS.B)) + geom_density()

ggplot(QLSTS_LAT, aes(L9, QLSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(QLSTS_LAT, aes(L7, QLSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(QLSTS_LAT, aes(L10, QLSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(QLSTS_LAT, aes(L4, QLSTS.B)) + geom_point() + geom_smooth(method ="lm")

model <- lm("QLSTS.B ~.", QLSTS_LAT)

summary(model)
sqrt(sum((predict(model, QLSTS_LAT)- QLSTS_LAT$QLSTS.B)^2)*1/nrow(QLSTS_LAT))

ggplot(QLSTS_LAT, aes(L9, QLSTS.B)) + geom_point() + geom_smooth(span =.5)
ggplot(QLSTS_LAT, aes(L7, QLSTS.B)) + geom_point() + geom_smooth()
ggplot(QLSTS_LAT, aes(L10, QLSTS.B)) + geom_point() + geom_smooth()
ggplot(QLSTS_LAT, aes(L4, QLSTS.B)) + geom_point() + geom_smooth()

model2 <- loess("QLSTS.B ~.", QLSTS_LAT, degree = 2, span = .5)
summary(model2)


CDSSTS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|CDSSTS.B", names(RAISE_LAT), value = T))
CDSSTS_LAT <- na.omit(CDSSTS_LAT)
#CDSSTS_LAT <- normalize(CDSSTS_LAT)
ggplot(CDSSTS_LAT, aes(L9, CDSSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(CDSSTS_LAT, aes(L7, CDSSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(CDSSTS_LAT, aes(L10, CDSSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(CDSSTS_LAT, aes(L4, CDSSTS.B)) + geom_point() + geom_smooth(method ="lm")

model <- lm("CDSSTS.B ~.", CDSSTS_LAT)
model2 <- lm("CDSSTS.B ~L9", CDSSTS_LAT)
summary(model)
summary(model2)


model3 <- loess("CDSSTS.B ~.", CDSSTS_LAT)
model4 <- loess("CDSSTS.B ~ L9", CDSSTS_LAT)

summary(model3)
summary(model4)



PANPSTS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|PANPSTS.B", names(RAISE_LAT), value = T))
PANPSTS_LAT <- na.omit(PANPSTS_LAT)
PANPSTS_LAT <- normalize(PANPSTS_LAT)
ggplot(PANPSTS_LAT, aes(L9, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L7, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L10, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L4, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")

model <- lm("PANPSTS.B ~.", PANPSTS_LAT)
model2 <- lm("PANPSTS.B ~L9", PANPSTS_LAT)
summary(model)
summary(model2)


model3 <- loess("PANPSTS.B ~.", PANPSTS_LAT)
model4 <- loess("PANPSTS.B ~ L9", PANPSTS_LAT)

summary(model3)
summary(model4)

PANPSTS

PANPSTS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|PANPSTS.B", names(RAISE_LAT), value = T))
PANPSTS_LAT <- na.omit(PANPSTS_LAT)
PANPSTS_LAT <- normalize(PANPSTS_LAT)
ggplot(PANPSTS_LAT, aes(L9, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L7, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L10, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANPSTS_LAT, aes(L4, PANPSTS.B)) + geom_point() + geom_smooth(method ="lm")

model <- lm("PANPSTS.B ~.", PANPSTS_LAT)
model2 <- lm("PANPSTS.B ~L9", PANPSTS_LAT)
summary(model)
summary(model2)


model3 <- loess("PANPSTS.B ~.", PANPSTS_LAT)
model4 <- loess("PANPSTS.B ~ L9", PANPSTS_LAT)

summary(model3)
summary(model4)

PANNGTS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|PANNGTS.B", names(RAISE_LAT), value = T))
PANNGTS_LAT <- na.omit(PANNGTS_LAT)
PANNGTS_LAT <- normalize(PANNGTS_LAT)
ggplot(PANNGTS_LAT, aes(L9, PANNGTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANNGTS_LAT, aes(L7, PANNGTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANNGTS_LAT, aes(L10, PANNGTS.B)) + geom_point() + geom_smooth(method ="lm")
ggplot(PANNGTS_LAT, aes(L4, PANNGTS.B)) + geom_point() + geom_smooth(method ="lm")

model <- lm("PANNGTS.B ~.", PANNGTS_LAT)
model2 <- lm("PANNGTS.B ~L9", PANNGTS_LAT)
summary(model)
summary(model2)


model3 <- loess("PANNGTS.B ~.", PANNGTS_LAT)
model4 <- loess("PANNGTS.B ~ L9", PANNGTS_LAT)

summary(model3)
summary(model4)



cor(QLSTS_LAT, use = "complete.obs")

CDSS_LAT <- RAISE_LAT %>% select(grep( "L[0-9]+$|CDSS", names(RAISE_LAT), value = T))
CDSSB_LAT <- CDSS_LAT %>% select(grep( "L[0-9]+$|.B$", names(CDSS_LAT), value = T))
CDSSB_LAT <- CDSSB_LAT %>% select(-c(CDSS010.B, CDSS009.B, CDSS011.B))


cor(CDSSB_LAT, use = "complete.obs")[12:15,1:9]
