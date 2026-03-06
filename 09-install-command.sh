#!/bin/bash

UserID=$(id -u)

if [ $UserID -ne 0 ]
then {
    echo "Error: You are running the command in no root user."
    exit 1
}
else {
    echo "Success: you are running the command in root user."
}
fi

dnf list installed nginx 
if [ $? -ne 0 ]

then {
   echo " nginx is not installed. Now going to install."

   dnf install nginx -y

   if [ $? -eq 0]

   then {
    echo "nginx has been installed successfully."
   }
   
   else {
    echo "nginx is not installed .... failure."
    exit 1
   }
   fi
}
else {
    echo "nginx is already installed nothing to do."
}
fi 