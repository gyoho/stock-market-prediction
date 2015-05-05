# load a necessary library
library(tseries, quietly = T)
library(forecast, quietly = T)
library(ggplot2, quietly = T)


# import stock price data
appl <- read.csv("~/Class/Hadoop/Project/data/aapl.csv")

# plot the past one year's adjusted closing price
plot(as.Date(appl$Date, "%Y-%m-%d"), appl$Adj.Close, xlab= "Dates", ylab= "Adjusted closing price", type='l', col='red', main="Adjusted closing price of Apple")

# calculate the returns of stock prices
# returns: [log(Pt) - log(Pt-1)]*100
appl.ret <- 100*diff(log(appl[,7]))

# plot the returns
# because took the diff, total is less by 1   i.e) Date[-1]
plot(as.Date(appl$Date[-1], "%Y-%m-%d"), appl.ret, xlab= "Dates", ylab= "Returns percentage(%)", type='l', col='red', main="Daily returns of Apple")

# autocorrelation: lag.max=10*log10(N/m)
appl.acf <- acf(appl.ret, main = "ACF of Apple")

# find most significant Pearson product-moment correlation coefficient
# i.e) max(x[x!=max(x)]) returns max val. which.max returns location.
appl.ppm_cc.max <- which.max(abs(appl.acf$acf[appl.acf$acf!=max(appl.acf$acf)]))

# get the greatest correlation
# create a formula for a model with a large number of variables:
xnam <- paste0("appl.ret[appl.ppm_cc.max+1:length(appl.ret)-", 1:appl.ppm_cc.max, "]")
fmla <- as.formula(paste0("appl.ret[appl.ppm_cc.max+1:length(appl.ret)] ~ ", paste0(xnam, collapse= "+")))
# get the linear fit
appl.lm <- lm(fmla)
summary(appl.lm)

# apply ARMA model
appl.arma <- arma(appl.ret, order = c(2, 2))
summary(appl.arma)


# divide the data train:test=9:1
# Train dataset
appl.ret.train <- appl.ret[1:(0.9 * length(appl.ret))]
# Test dataset
appl.ret.test <- appl.ret[(0.9 * length(appl.ret) + 1):length(appl.ret)]

# fit arima model	i.e) arima is more compatible with prediction function
appl.arima <- arima(appl.ret.train, order = c(2, 0, 2))

# apply prediction
appl.arma.pred <- predict(appl.arima, n.ahead = (length(appl.ret) - (0.9 * length(appl.ret))))
appl.arma.forecast <- forecast(appl.arima, h = 25)

# evaluation
# summary(appl.arma.forecast)
plot(appl.arma.forecast, main="ARMA forecasts for Apple returns")
accuracy(appl.arma.pred$pred, appl.ret.test)[2]



### ARIMA model with day of the week variable
# get the weekdays for each days
appl$day <- as.factor(weekdays(as.Date(appl$Date, "%Y-%m-%d")))
appl.days <- appl$day[2:nrow(appl)]
xreg1 <- model.matrix(~as.factor(appl.days))[, 2:5]
colnames(xreg1) <- c("Monday", "Thursday", "Tuesday", "Wednesday")

# use day of the week as an exogenous variable to augment our ARMA model
appl.arimax <- arima(appl.ret.train, order = c(2, 0, 2), xreg = xreg1[c(1:(0.9 * length(appl.ret))),])
appl.arimax.pred <- predict(appl.arimax, n.ahead = 25, newxreg = xreg1[c(226:250), ])
appl.arimax.forecast <- forecast(appl.arimax, h = 25, xreg = xreg1[c(226:250), ])

# evaluation
plot(appl.arimax.forecast, main = "ARIMAX forecasts for Apple returns")
accuracy(appl.arimax.pred$pred, appl.ret.test)[2]  # should get lower RESM than pure ARMA
summary(appl.arimax.forecast)