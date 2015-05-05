# load library
library(tseries, quietly = T)
library(forecast, quietly = T)

aapl <- read.csv("~/Class/Hadoop/Project/data/aapl.csv")

stock <- aapl

stock.ts = ts(rev(stock$Close),start=c(2010, 1),frequency=12)
train <- window(stock.ts, end=c(2014,12))
test <- window(stock.ts, start=c(2015,1), end=c(2015,4))

# Plot prediction
tl = seq(2000,2013,length=length(train))
tl2 = tl^5
polystock = lm(train ~ tl + tl2)
stlstock = stl(train,s.window="periodic")
NN.fit <- nnetar(train)
arima.fit <- arima(train, order=c(15,3,3))
arima2.fit <- arima(train, order=c(1,0,0), list(order=c(2,1,0), period=12))
tslm.fit <- tslm(train ~ trend + season, lambda=0)
HWstock_ng = HoltWinters(train,gamma=FALSE)
HWstock = HoltWinters(train)

 
# Plot all in a graph
plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red', main="Adjusted closing price of Apple")
plot(forecast(HWstock), main="Forecast of Holt-Winter Filter Model")
plot(forecast(HWstock_ng), main="Forecast of Exponential Smoothing Model")
plot(forecast(tslm.fit), main="Advanced Linear Model")
plot(forecast(NN.fit), main="Forecast of Neural Networks Model")
plot(forecast(arima2.fit), main="Forecast of ARIMA Sesonal Model")
plot(forecast(arima.fit), main="Forecast of ARIMA Model")
plot(forecast(stlstock), main="Sesonal Fit Model")
plot(forecast(polystock$fit), main="Polynominal Fit Model")


# Test
# plot(forecast(HWstock), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(HWstock_ng), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(tslm.fit), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(NN.fit), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(arima2.fit), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(arima.fit), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(stlstock), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')
#
# plot(forecast(polystock$fit), xlim=c(2010,2015))
# par(new=TRUE)
# plot(as.Date(aapl$Date, "%Y-%m-%d"), aapl$Adj.Close, axes = FALSE, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red')