#!/bin/bash
BACKUP_DIR="/home/ubuntu/db_backup"
S3_DIR="ecrms-mongo-backup/staging"

/usr/bin/aws s3 sync $BACKUP_DIR s3://$S3_DIR