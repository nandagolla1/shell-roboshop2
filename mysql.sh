#!/bin/bash

source ./common.sh
APP_NAME=mysql

check_root

PACKAGE_INSTALLER mysql-server


systemctl enable mysqld  &>> $LOG_FILE
VALIDATE $? "enabling mysqld service"

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "starting mysqld service"

echo "Please enter root password to setup"
read -s MYSQL_ROOT_PASSWORD


mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>> $LOG_FILE
VALIDATE $? "Setting MySQL root password"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE

print_time