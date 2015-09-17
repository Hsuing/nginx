#!/bin/bash - 
#===============================================================================
#
#          FILE: nginx_cut.sh
# 
#         USAGE: ./nginx_cut.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Hsuing Han 
#	 E-MAIL: hxopensource.163.com 
#  ORGANIZATION: 
#       CREATED: 2015年04月20日 15:07
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
base_path='/var/log/nginx'
CUT_LOG='/root/CutLog'
MAKETEMP="`mktemp /root/list.XXXXXX`"
log_month=$(date +"%Y%m")
day=$(date -d yesterday +"%d")

LIST1="`ls -l ${base_path} | awk '{print $NF}'  | sed '1d' | awk -F'-' '{print $1}' | grep 'error.log' >$MAKETEMP`"
while read LINE
do
	mkdir -p ${CUT_LOG}/${log_month}/$LINE
done < $MAKETEMP
#
arry=(
	test.xx.com-access.log
	test.xx.com1-access.log
	test.xx.com2-access.log
	test.xx.com3-access.log
)

for i in ${arry[@]}
do
	#if [ -s ${base_path}/$i ]
	#then
		LIST2="`ls -l ${CUT_LOG}/${log_month} | awk '{print $NF}'  | sed '1d' | awk -F'-' '{print $1}' | grep -v 'error.log'`"
		mv $base_path/$i ${CUT_LOG}/$log_month/${i}_$day
	#else
	#	exit 0
	#fi
done

/bin/kill -USR1 `cat /var/run/nginx/nginx.pid 2>/dev/null` 2>/dev/null || true

rm -rf $MAKETEMP
