# Tests the code on first 10 stocks

stockVector = list()
BestPrediction = vector()

fileList = list.files(path="./data", pattern="*.csv")


for(i in 1:length(fileList)) {
	stockVector[[i]] = read.table(paste0("./data/", fileList[i]), sep=",", header=TRUE)
}

# Populate the Best Error Vector
for(i in 1:length(stockVector)) {
	cat("Symbol:", fileList[i], "\n\n")
	findCorrelationDay(stockVector[[i]])
	findBestPrediction(stockVector[[i]])
	cat("--------------------------------\n\n")
}
