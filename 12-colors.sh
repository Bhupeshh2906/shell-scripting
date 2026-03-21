#!/bin/bash

UserID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $UserID -ne 0 ]
then
    echo -e " $R ERROR:: please use run the script using root user. $N "
    exit 1
else
    echo -e " $Y You running the script using root user. $N "
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e " Installing $2 is $G successfully. $N "
    else
        echo -e " Installing $2 is $R failed. $N"
        exit 1
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo " The mysql is not installed. Now we are started installing."
    dnf install mysql -y
    validate $? "MYSQL"
else
    echo -e " The mysql is $y installed already $N,  $Y nothing to do. $N"
fi

dnf list installed python3
if [ $? -ne 0 ]
then
    echo "python3 is not installed... going to install it"
    dnf install python3 -y
    validate $? "python3"
else
    echo -e "Nothing to do python... $Y already installed $N"
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
    echo "nginx is not installed... going to install it"
    dnf install nginx -y
    validate $? "nginx"
else
    echo -e "Nothing to do nginx... $Y already installed $N"
fi