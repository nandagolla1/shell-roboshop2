#!/bin/bash

source ./common.sh
APP_NAME=payment

check_root

app_setup


systemd_setup

END_TIME=$(date +%s) &>> $LOG_FILE
TOTAL_TIME=$(( $END_TIME - $START_TIME ))

echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE