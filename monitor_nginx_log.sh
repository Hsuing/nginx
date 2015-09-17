#!/bin/bash - 
#===============================================================================
#
#          FILE: nginx_log_monitor.sh
# 
#	  时间范围段[]
#         USAGE: ./nginx_log_monitor.sh  xxx.log  "17/Apr/2015:0[8-9]" 
#	  or
#	  整点
#         USAGE: ./nginx_log_monitor.sh  xxx.log  "17/Apr/2015:09" 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Xiong.Han 
#	     E-MAIL: hxopensource.163.com 
#  ORGANIZATION: 
#       CREATED: 2015年04月17日 14:46
#      REVISION:  ---
#===============================================================================
set -o nounset                              # Treat unset variables as an error
#log=/root/xkh.log
tmp=/root/temp.txt
#logdate=`date -d "yesterday" +%Y:%m:%d`

#as root running
if [ $UID -ne 0 ]
then
        echo "Please as root running!!!!"
        exit 0;
fi
        if [ $# != 2 ]
        then
                echo  "Please input 2 parameter"
                echo "[]代表时间段"
                echo "exmaple: ./monitor_nginx_log.sh  xxx.log  '17/Apr/2015:0[8-9]'"
                echo -e "or\n"
                echo "整点"
                echo "exmaple: ./monitor_nginx_log.sh xxx.log   '17/Apr/2015:8'"
                exit 1; 
        fi
#传递参数
logfile=$1
time1=$2
#统计访问量最大的元素
        #printf   "%-5s %-10s %-4s\n" counts\(file出现次数\)    KB      file  
        echo -e "\033[31m-----------------------------统计访问量最大的元素-----------------------------\033[0m"
        echo  -e "\033[31mcounts(次)    总大小(KB)   avg every(Kb)    file    refer\033[0m"
        egrep $time1 $logfile | awk '{a[$9"       "$6"     "$10]++}END{for (i in a) printf("%-13s %-12s %-50s\n", a[i] ,i*a[i]/1024 ,i)}' | sort -nr -k6
		if [ ! -f $tmp ]
		then
            egrep $time1 $logfile | awk '{a[$9"        "$6"    "$10]++}END{for (i in a) print a[i] ,i*a[i] ,i}' | sort -nr -k 1 > $tmp
		fi
        echo " "
#输出大小超出100KB文件
        echo -e "\033[31m输出大小超出100KB文件 \033[0m"
        printf "%-12s %-15s %-35s %-10s\n" "次数" "总大小(Kb)" "平均每个出现大小(Kb)" "file" 
        awk '{if($3>1000){printf( "%-10s %-12s %-27s %-10s\n",$1,$2,$3,$4);}}' $tmp | sort -nr
        #echo "计算你刚才所统计的总流量"
        #awk -F " " '{num+=$3}END{print "sum="num}' $tmp
#删除临时文件
        rm -rf $tmp

