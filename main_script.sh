#!/bin/bash

BASE_DIR="/home/ec2-user/deployment"
HOSTS_FILE="$BASE_DIR/hosts.txt"

while read IP DIR USER PASS; do
  echo "Deploying to $IP ($DIR)..."

  REMOTE_HOME="/home/$USER"
  sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "mkdir -p $REMOTE_HOME/$DIR"

  # Copy all files to user's home directory inside a folder
  sshpass -p "$PASS" scp -o StrictHostKeyChecking=no $BASE_DIR/$DIR/* $USER@$IP:$REMOTE_HOME/$DIR/

  # Run the setup script from the user's home directory using sudo
  sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "echo $PASS | sudo -S bash $REMOTE_HOME/$DIR/setup.sh"

  echo "Done with $IP"
  echo "------------------------"

done < $HOSTS_FILE
