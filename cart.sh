#!/bin/bash

source ./common.sh
APP_NAME=cart

check_root
app_setup
nodejs_setup
systemd_setup
print_time