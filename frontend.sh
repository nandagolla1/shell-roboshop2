#!/bin/bash

source ./common.sh
APP_NAME=frontend

dnf module disable nginx -y &>> $LOG_FILE
VALIDATE $? "Disabling default nginx package"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
VALIDATE $? "enabling nginx:1.24 version "

PACKAGE_INSTALLER nginx

systemctl enable nginx &>> $LOG_FILE
VALIDATE $? "nginx system service enabling"

systemctl start nginx &>> $LOG_FILE
VALIDATE $? "nginx system service starting"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE


curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "Downloading application code"

cd /usr/share/nginx/html &>> $LOG_FILE
VALIDATE $? "change current directory to the /usr/share/nginx/html directory"

unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "unzipping the application code to /usr/share/nginx/html directory"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>> $LOG_FILE
VALIDATE $? "updating nginx conf file"

systemctl restart nginx &>> $LOG_FILE
VALIDATE $? "Restarting nginx"

print_time