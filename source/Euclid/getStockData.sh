#!/bin/bash
# download the historical prices for past 5 years
# 4/30/2010 - 4/30/2015
# URL pattern: s=symbol, leave the period as it is

if [ "$#" -eq 0 ]
then
  echo no argument
else
	symbols=("$@")
	for arg;
	do
		url='http://real-chart.finance.yahoo.com/table.csv?s='
		url+=$arg
		url+='&a=03&b=30&c=2010&d=03&e=30&f=2015&g=d&ignore=.csv'
		# echo $url
		wget "$url" -O "$arg.csv"
	done
fi