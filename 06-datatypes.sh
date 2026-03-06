#!/bin/bash

number1=$1
number2=$2

Timestamp=$(date)

echo " The script is executed at $Timestamp."
sum=$(( $number1 + $number2 ))

echo " The sum of the two numbers is $sum."