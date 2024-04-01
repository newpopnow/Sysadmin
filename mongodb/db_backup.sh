#!/bin/bash
CONTAINER_NAME=ECRMS_DB_prd
DATE=$(date +%Y%m%d%H%M)
DUMP_DIR="db_dump/$DATE"
BACKUP_DIR="/home/ubuntu/db_backup"

echo "###### Backup started: $(date) ######"

docker exec $CONTAINER_NAME mkdir -p "$DUMP_DIR"

docker exec $CONTAINER_NAME mongodump --out "$DUMP_DIR"

docker exec $CONTAINER_NAME tar -czvf $DUMP_DIR.tar.gz $DUMP_DIR

mkdir -p "$BACKUP_DIR"

docker cp $CONTAINER_NAME:"$DUMP_DIR.tar.gz" $BACKUP_DIR

docker exec $CONTAINER_NAME rm -rf $DUMP_DIR $DUMP_DIR.tar.gz

echo "###### Backup ended: $(date) ######"

find $BACKUP_DIR -mindepth 1 -mtime +2 -delete

echo "###### Delete backup older than 2 days: $(date) ######"