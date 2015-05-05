# stock-market-prediction
### CS286 Class Project
- Stock market predictions in R
- Developed a program to evaluate the best model for an input data


###### List of Models
    * Polynomial
    * Seasonal
    * Holt-Winter Filter
    * Exponential Smoothing
    * ARIMA
    * ARIMA Seasonal
    * Neural Networks
    * Advanced Linear Model

![Euclid](https://github.com/gyoho/stock-market-prediction/blob/master/document/Euclid.png?raw=true)

## Install
1. Install [R](http://www.r-project.org/)
2. Install [SparkR](https://amplab-extras.github.io/SparkR-pkg/) if desired
3. Install [RStudio](http://www.rstudio.com/products/rstudio/download/)
4. Required Package
    * stats
    * tseries
    * forecast
    * fpp
    * ggplot2

## Usage
1. Clone Repo

    ```
    $ git clone git@github.com:gyoho/stock-market-prediction.git
    ```
2. Change into Source Euclid Directory

    ```
    $ cd stock-market-prediction/source/Euclid/
    ```
3. Download Historical Data of Your Desired Symbols

    ```
    $ ./getStockData.sh symbol1 symbol2 symbol3 ...
    ```
4. Install the Required Package Listed Above

    ```
    [Instruction on Youtube Video](https://www.youtube.com/watch?v=u1r5XTqrCTQ)
    ```
5. Load Necessary Functions in R Space

    ```
    Copy and paste findBestPrediction.R into RStudio console
    Copy and paste findCorrelationDay.R into RStudio console
    ```
6. Invoke the Main Function

    ```
    Copy and paste run.R into RStudio console
    ```
7. Enjoy!
