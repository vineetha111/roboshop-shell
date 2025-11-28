#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "ERROR::run with root user access only"
    exit 1
else 
    echo "you are already root user"
if

VALIDATE(){
    if [$1 -eq 0 ]
    then 
        echo "$2 is ... SUCCESS "
    else 
        echo "$2 is ... FALURE "
    fi
}

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Installing mongodb server"

systemctl enable mongod 
VALIDATE $? "enabling MongoDB"

systemctl start mongod
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing mongodb conf file for remote connections"

systemctl restart mongod
VALIDATE $? "Restarting MongoDB"