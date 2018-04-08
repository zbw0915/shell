#!/bin/bash

#time_zone
sed -e 's/UTC/Asia\/Shanghai/' /etc/sysconfig/clock
echo "UTC=false" >> /etc/sysconfig/clock
echo "ARC=false" >> /etc/sysconfig/clock


#UTC->CST
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#crontab
package=`rpm -qa | grep crontabs`

if [ $package != `rpm -qa | grep crontabs` ]; then
   echo "没有安装定时任务，正在安装..."
   yum install crontabs -y >>/dev/null

   else
   echo "已安装定时任务"
fi

#start crond service
#service crond start

#echo "*/5 * * * * /usr/sbin/ntpdate pool.ntp.org" >> /var/spool/cron/root

#ntpdate
package=`rpm -qa | grep ntpdate`

if [ $package != `rpm -qa | grep ntpdate` ]; then
   echo "没有安装时间服务，正在安装..."
   yum install ntpdate -y >>/dev/null

   else
   echo "已安装时间服务"
fi

#add_dns
echo "nameserver 61.134.1.4" >> /etc/resolv.conf

#ad_time
/usr/sbin/ntpdate pool.ntp.org
sleep 2
hwclock --systohc

echo "调整时间完成"
