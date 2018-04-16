#!/bin/bash
service scts.client stop
service scts.server stop

pid_redis=`ps -ef | grep redis | grep -v grep | awk  '{print $2}'`
kill -9 $pid_redis

service mysql stop
sleep 5
yum remove -y MySQL-*
sleep 5
rm -rf /sctsapp/data/*
rm -rf /var/log/mysqld.log
rm -rf /var/lib/mysql
rm -rf /etc/my.cnf
rm -rf /etc/init.d/mysql

rm -rf /sctsapp/*

/sbin/chkconfig mysql off
/sbin/chkconfig scts.server off
/sbin/chkconfig scts.client off

/sbin/chkconfig mysql --del
/sbin/chkconfig scts.server --del
/sbin/chkconfig scts.client --del

yum remove -y jdk1.8.0_45-1.8.0_45-fcs.x86_64
