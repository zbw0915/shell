#!/bin/bash


echo "install xtrabackup"
ver_old=`rpm -qa | grep percona-xtrabackup`

if [ $ver_old != `rpm -qa | grep ^percona-xtrabackup` ]; then
echo "xtrabackup not exist，perparing..."
	sleep 2
	mkdir -p /opt/percona-xtrabackup/

	wget -c http://117.22.228.210:7082/percona-xtrabackup/percona-xtrabackup-24-2.4.9-1.el6.x86_64.rpm -P /opt/percona-xtrabackup/
	wget -c http://117.22.228.210:7082/percona-xtrabackup/libev-4.15-1.el6.rf.x86_64.rpm -P /opt/percona-xtrabackup/
	sleep 2
	yum install -y perl-DBD-MySQL rsync >> /dev/null
	rpm -ivh /opt/percona-xtrabackup/libev-4.15-1.el6.rf.x86_64.rpm
	rpm -ivh /opt/percona-xtrabackup/percona-xtrabackup-24-2.4.9-1.el6.x86_64.rpm

	ver_new=`rpm -qa | grep xtrabackup`

	echo -e "\n"	

	echo "xtrabackup has been installed,version is" $ver_new
else
	echo -e "\n"
	echo "xtrabackup version is" $ver_old
fi

#	rm -rf /opt/percona-xtrabackup/*
sleep 2
