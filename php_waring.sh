#!/bin/bash
#Wed Jan 20 15:32:53 CST 2016
#author Han

MAIL=xxxxxx@163.com
LOG=/var/log/nginx/error.log
PHP_PATH=/home/trustone/monitor_scripts
PHP_ERROR_LOG=${PHP_PATH}/php_log.txt
PHP_RECORD=php_record.txt
TODAY=$(date "+%Y/%m/%d %H:%m")

awk '/PHP message: PHP Warning/{print $0}' $LOG > $PHP_ERROR_LOG
awk '/connect/{print $0}' $LOG >> $PHP_ERROR_LOG

egrep "$TODAY" $PHP_ERROR_LOG > $PHP_RECORD
#egrep "^PHP message" $PHP_ERROR_LOG >> $PHP_RECORD
echo "$TODAY" >> ${PHP_PATH}/record.txt
SUM=$(cat $PHP_RECORD)
if [ "$SUM" == "" ]
then
        exit 1
else
        mail -s "PHP WARING 79" $MAIL < $PHP_RECORD
fi
