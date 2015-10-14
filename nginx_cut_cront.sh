#!/bin/bash - 
#===============================================================================
#
#          FILE: nginx_cut_log.sh
# 
#         USAGE: ./nginx_cut_log.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: 第三次修改,更灵活了
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Xiong.Han 
#        E-MAIL: hxopensource.163.com 
#  ORGANIZATION: 
#       CREATED: 2015年10月13日 16:00
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
pid=$(ps -ef |grep master | egrep -v "(grep|php-fpm)" | awk '{print $2}')
TMP_FILE="/var/log/nginx/"
MKTMP=$(mktemp $TMP_FILE${pid}.XXXXXX)
echo "$pid" > $MKTMP

LOG_PATH="/var/log/nginx/"
BAK_PATH_LOG="/var/log/nginx/logs/"

LOG_NAMES=(
        test.xx.com-access
        status
        )

if [ ! -d ${BAK_PATH_LOG}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/ ];then
        mkdir -p ${BAK_PATH_LOG}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/
else
        echo "${BAK_PATH_LOG}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/  存在!!"
        continue;
fi

num=${#LOG_NAMES[@]}

for((i=0; i<num; i++))
do
        mv ${LOG_PATH}${LOG_NAMES[i]}.log ${BAK_PATH_LOG}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/${LOG_NAMES[i]}_$(date -d "yesterday" +"%Y%m%d").log
done
        /bin/kill -USR1 `cat ${MKTMP} 2>/dev/null` 2>/dev/null || true
#rm TMP_FILE
rm -rf $MKTMP
