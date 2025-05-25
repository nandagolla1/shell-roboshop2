#!/bin/bash

source ./common.sh
check_root

dnf module disable redis -y  &>> $LOG_FILE
VALIDATE $? "Disabling the default redis version"

dnf module enable redis:7 -y &>> $LOG_FILE
VALIDATE $? "enable redis version:7 "

PACKAGE_INSTALLER redis


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>> $LOG_FILE
VALIDATE $? "Edited redis.conf to accept remote connections"


systemctl enable redis &>> $LOG_FILE
VALIDATE $? "Enabling Redis"


systemctl start redis  &>> $LOG_FILE
VALIDATE $? "starting redis application"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE

print_time