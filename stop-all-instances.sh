#!/bin/bash

echo "Fetching all EC2 instance IDs..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "No instances found."
  exit 0
fi

echo "Stopping all instances..."
aws ec2 stop-instances --instance-ids $INSTANCE_IDS

echo "Waiting for instances to stop..."
aws ec2 wait instance-stopped

echo "All instances have been stopped."
