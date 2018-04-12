#!/bin/bash
#安装工具包
yum install -y bc nc >> /dev/null

url_server="http://10.8.14.219:8071/scts.server/login"
url_client="http://10.8.14.219:8061/scts.client/login"

#检查本机IP地址
IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | head -1`


echo -e "\n"


echo "本机IP "$IP
echo "###########"



#检查CPU个数
cpu_count=`cat /proc/cpuinfo | grep processor | wc -l`
echo "本机CPU个数 "$cpu_count

#检查CPU负载
five_min_cpu=`uptime | awk '{print $10}'`
ten_min_cpu=`uptime | awk '{print $11}'`
fifteen_min_cpu=`uptime | awk '{print $12}'`

echo "负载" "5分钟内 "$five_min_cpu  " 10分钟内 "$ten_min_cpu " 15分钟内 "$fifteen_min_cpu

#CPU总体使用率
##echo user nice system idle iowait irq softirq
CPULOG_1=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
SYS_IDLE_1=$(echo $CPULOG_1 | awk '{print $4}')
Total_1=$(echo $CPULOG_1 | awk '{print $1+$2+$3+$4+$5+$6+$7}')

sleep 2

CPULOG_2=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
SYS_IDLE_2=$(echo $CPULOG_2 | awk '{print $4}')
Total_2=$(echo $CPULOG_2 | awk '{print $1+$2+$3+$4+$5+$6+$7}')

SYS_IDLE=`expr $SYS_IDLE_2 - $SYS_IDLE_1`

Total=`expr $Total_2 - $Total_1`
SYS_USAGE=`expr $SYS_IDLE/$Total*100 |bc -l`

SYS_Rate=`expr 100-$SYS_USAGE |bc -l`

Disp_SYS_Rate=`expr "scale=3; $SYS_Rate/1" |bc`
echo 使用率 $Disp_SYS_Rate%
echo "###########"


#检查内存
total=`free -m | grep Mem | awk '{print $2}'`
used=`free -m | grep Mem | awk '{print $3}'`
free=`free -m | grep Mem | awk '{print $4}'`
buffers=`free -m | grep Mem | awk '{print $6}'`
cached=`free -m | grep Mem | awk '{print $7}'`

used_true=$(($used-$cached-$buffers))

free_true=$(($free+$buffers+$cached))

use_rate=`expr $used_true/$total*100 |bc -l`
mem_usage=`expr "scale=3; $use_rate/1" |bc`
echo  "内存占用"
echo  "总计"$total "MB "  "已用" $used_true "MB " "可用" $free_true "MB" 
echo  "使用率" $mem_usage%
echo -e "\n"

#检查磁盘
echo "磁盘占用"
df -h
echo "###########"

#内存占用前5名
echo -e "\n"
echo "内存占用前5名"
#内存占用第1
pid_m1=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==1{print $2}'`
pname_m1=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==1{print $11}'`
puse_m1=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==1{print $6/1024}'`

#内存占用第2
pid_m2=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==2{print $2}'`
pname_m2=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==2{print $11}'`
puse_m2=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==2{print $6/1024}'`

#内存占用第3
pid_m3=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==3{print $2}'`
pname_m3=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==3{print $11}'`
puse_m3=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==3{print $6/1024}'`

#内存占用第4
pid_m4=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==4{print $2}'`
pname_m4=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==4{print $11}'`
puse_m4=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==4{print $6/1024}'`

#内存占用第5
pid_m5=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==5{print $2}'`
pname_m5=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==5{print $11}'`
puse_m5=`ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk 'NR==5{print $6/1024}'`


ps auxc |grep -v PID | sort -k4nr | head -n 5 | awk '{print $2,$11,$6/1024"MB"}'


#CPU占用前5名
echo "CPU占用前5名"

#CPU占用第1
pid_c1=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==1{print $2}'`
pname_c1=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==1{print $11}'`
puse_c1=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==1{print $3}'`

#CPU占用第2
pid_c2=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==2{print $2}'`
pname_c2=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==2{print $11}'`
puse_c2=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==2{print $3}'`

#CPU占用第3
pid_c3=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==3{print $2}'`
pname_c3=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==3{print $11}'`
puse_c3=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==3{print $3}'`

#CPU占用第4
pid_c4=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==4{print $2}'`
pname_c4=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==4{print $11}'`
puse_c4=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==4{print $3}'`

#CPU占用第5
pid_c5=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==5{print $2}'`
pname_c5=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==5{print $11}'`
puse_c5=`ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk 'NR==5{print $3}'`

ps auxc |grep -v PID | sort -k3rn | head -n 5 | awk '{print $2 , $11, $3"%"}'
echo "###########"
echo -e "\n"

#检查前后台进程数量
count_client=`ps -ef | grep tomcat_client | grep -v grep | wc -l`
count_server=`ps -ef | grep tomcat_server | grep -v grep | wc -l`
echo "前台进程数量" $count_client
echo "后台进程数量" $count_server
echo -e "\n"

#检查前后台进程数量
count_uK=`ps -ef | grep uK | grep -v grep | wc -l`
if [ $count_uK -ne 4 ]; then
	echo "uK进程数量" $count_uK "异常情况."
else
	echo "uK进程数量正常" $count_uK
fi
echo -e "\n"

#ngmc-uc服务数量
count_uc=`ps -ef | grep gmc-uc | grep -v grep | wc -l`
if [ $count_uc -ne 1 ]; then
        echo "ncmc-uc进程数量" $count_uc "异常情况."
else
        echo "ngmc-uc进程数量正常" $count_uc
fi
echo -e "\n"


#检查端口nc是否安装

#package=`rpm -qa | grep ^nc-`

#if [ $package != `rpm -qa | grep ^nc-` ]; then
#   echo "安装包不完整，安装中..."
#   yum install nc -y >>/dev/null
#
#   else
#   echo "安装包完整"
#fi



usrls=( ${url_server} ${url_client}  )

for url in ${usrls[*]}
do
	status=$(curl -s -m 8 --head "${url}" | awk 'NR==1{print $2}')
	if [ ${status} -ne "200" ]; then
		echo "地址 ${url} 异常,请及时处理"
	else
		echo "地址 ${url} 正常"
	fi
done


#检测Mysql服务

mysql=`nc -w 10 -z $IP 3306 | awk  '{print $7}'`

	if [ "$mysql" == "succeeded!" ]; then
	   echo "MySQL端口3306正常"
	else
	   echo "MySQL端口3306故障,请检查!!"
	fi


#检测Redis服务

redis=`nc -w 10 -z $IP 6379 | awk  '{print $7}'`
	
	if [ "$redis" == "succeeded!" ]; then
	   echo "Redis端口6379正常"
	else
	   echo "Redis端口6379故障,请检查!!"
	fi


#检测UK的uKeyNative服务端口

uk=`nc -w 10 -z $IP 9188 | awk  '{print $7}'`

	if [ "$uk" == "succeeded!" ]; then
	   echo "UK端口9188正常"
	else
	   echo "UK端口9188故障,请检查!!"
	fi

#检测UK的uKeyCCV服务端口

uk=`nc -w 10 -z $IP 9189 | awk  '{print $7}'`

        if [ "$uk" == "succeeded!" ]; then
           echo "UK端口9189正常"
        else
           echo "UK端口9189故障,请检查!!"
        fi

#检测netproxy服务

netproxy=`nc -w 10 -z $IP 8090 | awk  '{print $7}'`

	if [ "$netproxy" == "succeeded!" ]; then
	   echo "netproxy端口8090正常"
	else
	   echo "netproxy端口8090故障,请检查!!"
	fi


#检测自助取票服务

qupiao=`nc -w 10 -z $IP 8500 | awk  '{print $7}'`

        if [ "$qupiao" == "succeeded!" ]; then
           echo "自助取票服务端口8500正常"
        else
           echo "自助取票服务端口8500故障,请检查!!"
        fi


#检测ngmc-uc服务
uc=`nc -w 10 -z $IP 8246 | awk  '{print $7}'`

        if [ "$uc" == "succeeded!" ]; then
           echo "ngmc-uc端口8246正常"
        else
           echo "ngmc-uc端口8246故障,请检查!!!"
        fi

#检查usb模块
usb_model=`lsusb | awk '/Feitian/{print $7}'`
	if [ ! $usb_model ]; then
	   echo usb模块$usb_model没有加载,请检查!!
	else
	   echo usb模块 $usb_model已加载
	fi

echo "###########"


#version_mysql=`mysql -V | awk '{print $5}' | sed -e 's/,//g'`
#if [ $version_mysql != 5.6.21 ]; then
#	echo "当前版本不是5.6.21,请替换"
#else
#	echo MySQL数据库版本正确 $version_mysql
#fi

#version_client=`/sctsapp/tomcat_client/bin/version.sh --version |awk '/Server version/{print $4}' | sed -e 's/Tomcat\///g'`
#if [ $version_client != 7.0.69 ]; then
#        echo "当前版本不是7.0.69,请替换"
#else
#        echo 前台Tomcat版本正确 $version_client
#fi

#version_server=`/sctsapp/tomcat_server/bin/version.sh --version |awk '/Server version/{print $4}' | sed -e 's/Tomcat\///g'`
#if [ $version_server != 7.0.69 ]; then
#        echo "当前版本不是7.0.69,请替换"
#else
#        echo 后台Tomcat版本正确 $version_server
#fi

#redis_version=`/sctsapp/linux_redis-2.4.5/redis-2.4.5/src/redis-server --version | awk '{print $4}'`
#if [ $redis_version != 2.4.5 ]; then
#        echo "当前版本不是2.4.5,请替换"
#else
#        echo 当前Redis版本正确 $redis_version
#fi
#echo "###########"




echo "诊断完成."
