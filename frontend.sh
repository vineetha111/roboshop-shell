#!/bin/bash

USERID=$(id -u)
SCRIPT_DIR=$PWD

if [ $USERID -ne 0 ]
then 
    echo "ERROR::run with root user access only"
    exit 1
else 
    echo "you are already root user"
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo "$2 is ... SUCCESS"
    else 
        echo "$2 is ... FALURE"
    fi
}

dnf module disable nginx -y
VALIDATE $? "nginx module disabled"

dnf module enable ngins:1.24 -y
VALIDATE $? "nginx:1.24 enabled"

dnf install nginx -y
VALIDATE $? "nginx installed"

systemctl enable nginx
systemctl start nginx
VALIDATE $? "nginx started"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "removed default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "downloaded roboshop code"

cd /usr/share/nginx/html 
VALIDATE $? "moved to usr/share/nginx directory"

unzip /tmp/frontend.zip
VALIDATE $? "unzipped frontend code"

rm -rf /etc/nginx/nginx.conf
VALIDATE $? "removing nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx conf"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"


