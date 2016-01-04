#!/bin/bash

##
# increment backup mysql use binlog everyday
# 1-6 days
##

date=$(date +"%Y%m%d")
mysqldir=/var/lib/mysql
backupdir=/backup/mysqldata

cd $mysqldir

filelist=$(find ./ -iname "mysql-bin.*" -mtime -1 | awk -F"/" '{print$2}')

[ ! -d $backupdir/backup.0 ] && mkdir -p $backupdir/backup.0

tar zcf $backupdir/backup.0/binlog-${date}.tar.gz $filelist
