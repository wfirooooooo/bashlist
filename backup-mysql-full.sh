#!/bin/bash

##
# full backup mysql databases every week
# 7 weeks rotate
# one database one file
##

bakdir=/backup/mysqldata
date=`date +"%Y%m%d"`
logfile=/backup/mysqldata/bak.log.${date}
mysqlcmd=`which mysql`
user=root
passd=123456
host=192.168.10.12
mysqldumpcmd=`which mysqldump`
all_dbs="$(${mysqlcmd} -h${host} -u${user} -p${passd} -Bse 'show databases')"
all_dbs=${all_dbs//information_schema/}
all_dbs=${all_dbs//performance_schema/}

[ ! -d $bakdir/backup.0 ] && mkdir -p $bakdir/backup.0

echo "-- begin full back up mysql databases -- $date --" >> $logfile 
for db in $all_dbs
do
  gzdumpfile=${db}_${date}.sql.gz
  $mysqldumpcmd -h${host} -u${user} -p${passd} --opt $db | gzip -9 > ${bakdir}/backup.0/${gzdumpfile} \
  && echo "$db backup success!" >> $logfile \
  && rm -f ${bakdir}/backup.7/*
done

for i in `seq 0 6 | tac`
do
  echo $i
  [ ! -d ${bakdir}/backup.${i} ] && mkdir ${bakdir}/backup.${i}
  next_i=`expr $i + 1`
  mv $bakdir/backup.${i} $bakdir/backup.${next_i}
done
