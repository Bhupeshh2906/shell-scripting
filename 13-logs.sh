#!/bin/bash

UserID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFOLDER="/var/log/shell-scripting-logs"
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE="$LOGFOLDER/$SCRIPTNAME.log"

mkdir -p $LOGFOLDER

if [ $UserID -ne 0 ]
then
    echo -e " $R ERROR:: please use run the script using root user. $N " | tee -a $LOGFILE
    exit 1
else
    echo -e " $Y You running the script using root user. $N " | tee -a $LOGFILE
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e " Installing $2 is $G successfully. $N " | tee -a $LOGFILE
    else
        echo -e " Installing $2 is $R failed. $N" | tee -a $LOGFILE
        exit 1
    fi
}

dnf list installed mysql &>> $LOGFILE
if [ $? -ne 0 ]
then
    echo " The mysql is not installed. Now we are started installing." | tee -a $LOGFILE
    dnf install mysql -y &>> $LOGFILE
    validate $? "MYSQL"
else
    echo -e " The mysql is $y installed already $N,  $Y nothing to do. $N" | tee -a $LOGFILE
fi

dnf list installed python3 &>> $LOGFILE
if [ $? -ne 0 ]
then
    echo "python3 is not installed... going to install it" | tee -a $LOGFILE
    dnf install python3 -y &>> $LOGFILE
    validate $? "python3"
else
    echo -e "Nothing to do python... $Y already installed $N" | tee -a $LOGFILE
fi

dnf list installed nginx &>> $LOGFILE
if [ $? -ne 0 ]
then
    echo "nginx is not installed... going to install it" | tee -a $LOGFILE
    dnf install nginx -y &>> $LOGFILE
    validate $? "nginx"
else
    echo -e "Nothing to do nginx... $Y already installed $N" | tee -a $LOGFILE
fi