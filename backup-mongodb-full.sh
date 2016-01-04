#!/bin/bash

##
#use mongdump command to backup mongodb data every day
#you can add some parameters for your environment
##

host=localhost
mongodump=/usr/local/mongodb/bin/mongodump
date=$(date +"%Y%m%d")
backupdir=/backup/mongodb/$date
logfile=/backup/mongodb/mongodump.log

[ -d $backupdir ] && mkdir -p $backupdir

echo "---begin mongodump data ${date}---" >> $logfile
$mongodump -h $host -o $backupdir >> $logfile
