#!/bin/bash

DATE=`date +"%Y%m%d%H%M%S"`
FILENAME="database_backup_"$DATE".sql"
BACKUPS_DIR=/home/manos/backups
SQLFILE=$BACKUPS_DIR/$FILENAME
XZFILE=$BACKUPS_DIR/$FILENAME".tar.xz"

docker exec manos-service-database-1 pg_dump --verbose --clean --no-acl --no-owner -h localhost -U user -d manos > $SQLFILE
tar cJvf $XZFILE $SQLFILE
rm $SQLFILE
cd $BACKUPS_DIR
git add $XZFILE
git commit -m "Backup $DATE"
#git push -u origin
GIT_SSH_COMMAND='ssh -i ~/.ssh/backups -o IdentitiesOnly=yes' git push
