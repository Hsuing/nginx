#!/bin/bash
#Wed Jan 20 15:32:53 CST 2016
#author Han

MAIL=xxxxxx@163.com
LOG=/var/log/nginx/error.log
PHP_ERROR_LOG=/home/trustone/monitor_scripts/php_log.txt
PHP_RECORD=php_record.txt
TODAY=$(date "+%Y/%m/%d %H")

awk '/PHP message: PHP Warning/{print $0}' $LOG > $PHP_ERROR_LOG
egrep "$TODAY" $PHP_ERROR_LOG > $PHP_RECORD
#egrep "^PHP message" $PHP_ERROR_LOG >> $PHP_RECORD

SUM=$(cat $PHP_RECORD)
#判断是为空，如为空，则退出
if [ "$SUM" == "" ]
then
        exit 1
else
        mail -s "PHP WARING" $MAIL < $PHP_RECORD
fi
