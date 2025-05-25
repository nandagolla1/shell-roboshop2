#!/bin/bash
source ./common.sh
APP_NAME=mongodb

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding mongo repo"

PACKAGE_INSTALLER mongodb-org

systemctl enable mongod
VALIDATE $? "mongod system service enabling"

systemctl start mongod
VALIDATE $? "mongod system service starting"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing MongoDB conf file for remote connections"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"