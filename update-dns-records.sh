#!/bin/bash

# === USER CONFIG ===
HOSTED_ZONE_ID="Z0241085GWXCWOXHL9YW"
DOMAIN_NAME="nanda.cyou"

# === Start all EC2 instances ===
echo "Starting all EC2 instances..."
aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text | tr '\t' '\n' | while read instance_id; do
  aws ec2 start-instances --instance-ids "$instance_id" >/dev/null
done

echo "Waiting for instances to enter 'running' state..."
aws ec2 wait instance-running

# === Get instance info ===
echo "Fetching IP addresses..."

aws ec2 describe-instances \
  --query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name']|[0].Value,PrivateIpAddress,PublicIpAddress]" \
  --output text | while read INSTANCE_ID NAME PRIVATE_IP PUBLIC_IP; do

  if [ "$NAME" == "None" ]; then
    NAME=$INSTANCE_ID  # fallback
  fi

  if [ "$NAME" == "frontend" ]; then
    IP="$PUBLIC_IP"
  else
    IP="$PRIVATE_IP"
  fi

  FQDN="${NAME}.${DOMAIN_NAME}."
  echo "Updating DNS: $FQDN → $IP"

  cat > dns-${NAME}.json <<EOF
{
  "Comment": "Updating DNS record for ${FQDN}",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${FQDN}",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${IP}"
          }
        ]
      }
    }
  ]
}
EOF

  aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch file://dns-${NAME}.json

  rm -f dns-${NAME}.json
done
