setwd("~/work/IHI/simstudy/generate/ss1000nv10/results/")
connection <- file("vanilla.comparison.txt")
file <- trimws(readLines(connection))
close(connection)
start <- grep("Algorithms:", file)
file <- file[start:length(file)]
file <- gsub("[ \t]+", " ", file)
file


foo<-strsplit(file, " ")
