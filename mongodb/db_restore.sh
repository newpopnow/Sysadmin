#!/bin/bash
CONTAINER_NAME=ECRMS_DB_prd
DATE=$1
DUMP_DIR="mongo_backup/$DATE"
RESTORE_DIR="mongo_restore"
BACKUP_DIR="/home/ubuntu/mongo_backup"
S3_DIR="ecrms-mongo-backup"

echo "Enter restore version, format YmdHM eg. 202404011010: "

read DATE

echo "###### Restore started: $(date) ######"

mkdir -p "$BACKUP_DIR"

/usr/bin/aws s3 sync s3://$S3_DIR $BACKUP_DIR

docker exec $CONTAINER_NAME mkdir -p "$RESTORE_DIR"

docker cp "$BACKUP_DIR/$DATE.tar.gz" $CONTAINER_NAME:$RESTORE_DIR

docker exec $CONTAINER_NAME tar -xzvf "$RESTORE_DIR/$DATE.tar.gz" $DUMP_DIR

docker exec $CONTAINER_NAME mongorestore "$DUMP_DIR"

docker exec $CONTAINER_NAME rm -rf $DUMP_DIR

echo "###### Restore ended: $(date) ######"