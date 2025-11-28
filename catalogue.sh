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

dnf module disable nodejs -y
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enabling nodejs:20"

dnf install nodejs -y
VALIDATE $? "Installing nodejs:20"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "creating sysytem user"

mkdir /app
VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Downloading catalogue"

cd /app
VALIDATE $? "changing to app directory"

unzip /tmp/catalogue.zip
VALIDATE $? "unzipping catalogue"

npm install
VALIDATE $? "Installing Dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue service"

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "starting catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
VALIDATE $? "installing mongodb client"

mongosh --host mongodb.vinnimakeovers.online </app/db/master-data.js





