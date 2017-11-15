nvars <- 30
ss <- 1000
p <- 1 - 1/30

temp <- rep(0, 20)
for (k in 1:100) {

nas <- nvars * ss * (1 - p)
samp <- sample(1:ss, nas, replace = T)
boxes <- rep(0, ss)

for (i in samp)
  boxes[i] <- boxes[i] + 1
empty <- 0
for (j in 1:ss)
  ifelse(boxes[j] == 0, empty <- empty + 1, NA)
temp[k] <- empty
}

dist <- quantile(temp)
print(dist)
