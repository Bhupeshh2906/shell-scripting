#!/bin/bash

UserID=$(id -u)

if [ $UserID -ne 0 ]
then
    echo "The user is not having the privilege to install the package. Please try with root privilege."
    exit 1
else
    echo "The user is having the privilege to install packages. You may proceed to install."
fi

validate(){
    if [ $1 -eq 0 ]
    then 
        echo "The package $2 has been installed successfully."
    else
        echo "The package $2 has been failed to install."
        exit 1
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "MySQL is not installed. Now going to install."
    dnf install mysql -y
    validate $? "mysql"
else
    echo "MySQL is already installed. Nothing to do."
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
    echo "nginx is not installed. Now going to install."
    dnf install nginx -y
    validate $? "nginx"
else
    echo "nginx is already installed. Nothing to do."
fi

dnf list installed python3
if [ $? -ne 0 ]
then
    echo "Python is not installed. Now going to install."
    dnf install python3 -y
    validate $? "python3"
else
    echo "python is already installed. Nothing to do."
fi


