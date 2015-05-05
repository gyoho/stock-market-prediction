findCorrelationDay <- function(stock) {
	# calculate the returns of stock prices
	# returns: [log(Pt) - log(Pt-1)]*100
	stock.ret <- 100*diff(log(stock[,7]))

	# autocorrelation: lag.max=10*log10(N/m)
	stock.acf <- acf(stock.ret, plot = FALSE)

	# find most significant Pearson product-moment correlation coefficient
	# i.e) max(x[x!=max(x)]) returns max val. which.max returns location.
	stock.ppm_cc.max <- which.max(abs(stock.acf$acf[stock.acf$acf!=max(stock.acf$acf)]))

	# get the greatest correlation
	# create a formula for a model with a large number of variables:
	xnam <- paste0("stock.ret[stock.ppm_cc.max+1:length(stock.ret)-", 1:stock.ppm_cc.max, "]")
	fmla <- as.formula(paste0("stock.ret[stock.ppm_cc.max+1:length(stock.ret)] ~ ", paste0(xnam, collapse= "+")))
	# get the linear fit
	stock.lm <- lm(fmla)
	
	cat("strong correlation with : ", stock.ppm_cc.max, "days ago\n")
	cat("p-value:", summary(stock.lm)$coefficients[stock.ppm_cc.max+1,4], "\n")
	cat("this model covers", "~", summary(stock.lm)$adj.r.squared*100, "% of the explanation\n\n")
}