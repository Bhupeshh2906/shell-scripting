#!/bin/bash

UserID= $(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGFOLDER="/var/log/shell-scripting-logs"
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE="$LOGFOLDER/$SCRIPTNAME.log"
PACKAGES=("mysql" "python" "nginx" "httpd")

mkdir -p $LOGFOLDER

if [ $UserID -ne 0 ]
then 
    echo -e " $R Error:: Please run the script as root user. $N" | tee -a $LOGFILE
    exit 1
else
    echo -e " $Y The script will be run by root user. $N" | tee -a $LOGFILE
fi

validate(){
    if [ $1 -eq 0 ]
    then 
        echo -e " $Y The $2 installation was successful. $N" | tee -a $LOGFILE
    else
        echo -e " $R The $2 installation was failed. $N"  | tee -a $LOGFILE
        exit 1
    fi 
}

for package in ${PACKAGES[@]}
do 
    dnf list installed $package &>> $LOGFILE
    if [ $? -ne 0 ]
    then 
        echo -e " $R $package is not installed. $N $Y will start installing.$N" | tee -a $LOGFILE
        dnf install $package -y &>> $LOGFILE
        validate $? "$package"
    else
        echo -e "$Y $package is already installed. $N $Y nothing to do. $N" | tee -a $LOGFILE
    fi
done
