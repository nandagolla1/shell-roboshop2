#!/bin/bash

# Customize as needed
USER="ec2-user"
DEFAULT_PASSWORD="YourDefaultPassword"   # Update with actual password
FOLDER_PREFIX="instance"

REGION="us-east-1"  # Update to your region

echo "Generating hosts.txt..."
> hosts.txt  # Clear file

# Get all running instance IPs and names
aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[PrivateIpAddress,Tags[?Key==`Name`]|[0].Value]' \
  --output text | while read IP NAME; do

    # Optional: Normalize NAME if it's empty
    if [[ -z "$NAME" ]]; then
      NAME="${FOLDER_PREFIX}_$IP"
    fi

    echo "$IP $NAME $USER $DEFAULT_PASSWORD" >> hosts.txt
done

echo "hosts.txt created:"
cat hosts.txt
