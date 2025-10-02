#!/bin/bash

# =====================================
# EC2 Health Check & Backup Script
# =====================================

INSTANCE_ID="i-0cfced343ff2e87bf"
REGION="us-east-1"   # Change this if your instance is in a different region
LOGFILE="ec2_automation.log"

echo "===== Starting EC2 Automation Script =====" | tee -a "$LOGFILE"

# 1. Check EC2 instance health
echo "Checking health status of EC2 instance: $INSTANCE_ID ..." | tee -a "$LOGFILE"
HEALTH_STATUS=$(aws ec2 describe-instance-status \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query "InstanceStatuses[0].InstanceStatus.Status" \
  --output text)

if [ "$HEALTH_STATUS" == "ok" ]; then
    echo "✅ Instance $INSTANCE_ID is healthy." | tee -a "$LOGFILE"
else
    echo "⚠️ Instance $INSTANCE_ID is not healthy! Status: $HEALTH_STATUS" | tee -a "$LOGFILE"
fi

# 2. Create an AMI backup
BACKUP_NAME="backup-$(date +%F-%H-%M)"
echo "Creating backup AMI: $BACKUP_NAME ..." | tee -a "$LOGFILE"

aws ec2 create-image \
  --instance-id $INSTANCE_ID \
  --region $REGION \
  --name "$BACKUP_NAME" \
  --no-reboot >> "$LOGFILE" 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Backup AMI $BACKUP_NAME created successfully." | tee -a "$LOGFILE"
else
    echo "❌ Failed to create backup AMI." | tee -a "$LOGFILE"
fi

echo "===== Script Completed =====" | tee -a "$LOGFILE"

