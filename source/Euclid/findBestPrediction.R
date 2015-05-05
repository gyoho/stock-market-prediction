# load library
library(forecast, quietly = T)
library(fpp, quietly = T)

findBestPrediction <- function(stock) {
  
	# Convert into time series object
	# rev(): revrse vector in ascending time order
	# start(year, quarter)
	stock.ts = ts(rev(stock$Close),start=c(2010, 1),frequency=12)
  
	# Create Train and Test data of the input stock
	train <- window(stock.ts, end=c(2014,12))
	test <- window(stock.ts, start=c(2015,1), end=c(2015,4))
	
	# a list of the method
	methods <- c("Polynominal", "Sesonal", "Holt-Winter Filter", "Exponential Smoothing", "ARIMA", "ARIMA Sesonal", "Neural Networks", "Advanced Linear Model")
  
	# Mean Absolute Errors of the 25 predictions are stored here
	# data: NA, num of row 25, num of col: test+1
	mae = matrix(NA,length(methods),length(test)+1)
	
  
### Agression ###
 
	## Polynominal fit ##
  	# generate sequence of number
	# start: 2000, end: 2013, by: (2013-2000)/length
	tl = seq(2010,2015,length=length(train))
	tl2 = tl^5
	polystock = lm(train ~ tl + tl2)
	stock.ts.poly=ts(polystock$fit,start=c(2010, 1),frequency=12)
	
	## Sesonal Fit ##
	# Decompose a time series into seasonal
	# s.window = "periodic": smoothing by taking the mean
	stlstock = stl(train,s.window="periodic")
	stock.ts.stl = stlstock$time.series[,2]
	
	
	##  Holt-Winter Filter ##
	HWstock_ng = HoltWinters(train,gamma=FALSE)
	# gamma=FALSE: exponential smoothing
	HWstock = HoltWinters(train)
	# Holt-Winters Filter: double exponential smoothing
	
	
	## Neural Networks ##
	NN.fit <- nnetar(train)
	
	## ARIMA model ##
	arima.fit <- arima(train, order=c(2,1,2))
	# arima.sesonal.fit <- arima(train, order=c(1,0,0), list(order=c(2,1,0), period=12))
	
	## Advanced Linear Model ##
	tslm.fit <- tslm(train ~ trend + season, lambda=0)
	# linear fits with trend and season components considered


### Prediction ###

	## Polynominal ##
	# pred.poly = window(predict(stock.ts.poly,n.ahead=39), start=2011)
	
	## Seasonal ##
	# pred.stl = window(predict(stock.ts.stl,n.ahead=39), start=2011)

	##  Holt-Winter Filter ##
	pred.HWstock = window(predict(HWstock,n.ahead=39), start=c(2015,1))
	pred.HWstock_ng = window(predict(HWstock_ng,n.ahead=39), start=c(2015,1))

	## ARIMA model ##
	pred.arima.fit = window(forecast(arima.fit,h=39)$mean, start=c(2015,1))
	# pred.arima.sesonal.fit = window(forecast(arima.sesonal.fit,h=39)$mean, start=2011)
	
	## Neural Networks ##
	pred.NN.fit = window(forecast(NN.fit,h=39)$mean, start=c(2015,1))

	## Advanced Linear Model ##
	pred.tslm.fit = window(forecast(tslm.fit, h=39)$mean, start=c(2015,1))


### Rank the model ###

	## Calculate Mean Absolute Error ##
	for(i in 1:length(test)) {
		# mae[1,i] <- abs(pred.poly[i]-test[i])
		# mae[2,i] <- abs(pred.stl[i]-test[i])
		mae[3,i] <- abs(pred.HWstock[i]-test[i]) 
		mae[4,i] <- abs(pred.HWstock_ng[i]-test[i])
		mae[5,i] <- abs(pred.arima.fit[i]-test[i]) 
		# mae[6,i] <- abs(pred.arima.sesonal.fit[i]-test[i])
		mae[7,i] <- abs(pred.NN.fit[i]-test[i]) 
		mae[8,i] <- abs(pred.tslm.fit[i]-test[i])
	}
  
	## Sum all Errors ##
	for(i in 1:8) {
		mae[i,length(test)+1] = sum(mae[i,1:length(test)])
	}
  
  
	## Find best Prediction ##
	bestModel <- which.min(mae[1:8,length(test)+1])
	cat("Best model:", methods[bestModel], "\n\n")
  
	return (bestModel)
}
