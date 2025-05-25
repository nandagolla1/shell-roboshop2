#!/bin/bash
APP_NAME=catalogue

source ./common.sh

check_root
app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding repos which is required for mongo client installation"

PACKAGE_INSTALLER mongodb-mongosh &>> $LOG_FILE
VALIDATE $? "downloading and installing mongo client"




#=========the below condition is to check whether a database named catalogue exists on a MongoDB server.================

STATUS=$(mongosh --host mongodb.nanda.cyou --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.nanda.cyou </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi

print_time