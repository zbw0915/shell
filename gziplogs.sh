#!/bin/bash
gziptomcat_client_logs(){
logspath=/sctsapp/tomcat_client/logs/
date_suffix=$(date +'%Y-%m-%d' -d '-3day')
today_suffix=$(date +'%Y-%m-%d')

for logs in `/bin/ls -l  $logspath |awk '{print $9}' |grep -v "^d"|grep -v "$date_suffix" |grep -v "$today_suffix"|grep -v ".gz"`
do
/bin/gzip $logspath/$logs
#echo $logspath/$logs
done
}

gziptomcat_server_logs(){
logspath=/sctsapp/tomcat_server/logs/
date_suffix=$(date +'%Y-%m-%d' -d '-3day')
today_suffix=$(date +'%Y-%m-%d')

for logs in `/bin/ls -l  $logspath |awk '{print $9}' |grep -v "^d"|grep -v "$date_suffix" |grep -v "$today_suffix"|grep -v ".gz"`
do
/bin/gzip $logspath/$logs
#echo $logspath/$logs
done
}

gzipuklog4native(){
logspath=/sctsapp/uKeyProxy/log4native/
date_suffix=$(date +'%Y-%m-%d' -d '-3day')
today_suffix=$(date +'%Y-%m-%d')

for logs in `/bin/ls -l  $logspath |awk '{print $9}' |grep -v "^d"|grep -v "$date_suffix" |grep -v "$today_suffix"|grep -v ".gz"`
do
/bin/gzip $logspath/$logs
#echo $logspath/$logs
done
}

gzipuklog4ccv(){
logspath=/sctsapp/uKeyProxy/log4ccv/
date_suffix=$(date +'%Y-%m-%d' -d '-3day')
today_suffix=$(date +'%Y-%m-%d')

for logs in `/bin/ls -l  $logspath |awk '{print $9}' |grep -v "^d"|grep -v "$date_suffix" |grep -v "$today_suffix"|grep -v ".gz"`
do
/bin/gzip $logspath/$logs
#echo $logspath/$logs
done
}

gzipfolders(){
logs_folder="/home/cec/.cec/logs"
last_month=`date -d last-month +%Y-%m`
#month=$(date +"%Y-%m-%d" -d "-30day")
cd $logs_folder
for folders in `ls -l |grep ^d |awk '{print $9}' |grep -v backup |grep -v temp| grep -v mtx| grep ^$month`;do
/bin/tar -zcvf $folders.tar.gz ./$folders
#echo $folders
if [ `du -sh $folders.tar.gz |awk '{print $1}' |cut -dM -f1` -gt 20 ] ; then
rm -rf $folders
#echo $folders
fi
done
}


gziptomcat_client_logs
gziptomcat_server_logs
gzipuklog4native
gzipuklog4ccv
#gzipfolders
