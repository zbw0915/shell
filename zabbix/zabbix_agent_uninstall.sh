#!/bin/bash

echo "stop zabbix-agent sevice"

/sbin/chkconfig zabbix-agent off
/etc/init.d/zabbix-agent stop
if [ $? -eq 0 ]; then
	echo "zabbix-agent stoped successuflly.."
else
	echo "zabbix-agent stoped failed.."
	exit
fi

sleep 2

echo "remove zabbix-agent and mysql-templete"

echo -e "\n"

yum remove percona-zabbix-templates-1.1.8-1.noarch zabbix-agent-3.4.3-1.el6.x86_64 -y
if [ $? -eq 0 ]; then
	echo "zabbix-agent and mysql-templete has been removed successfully.."
else
	echo "zabbix-agent and mysql-templete has been removed failed.."
	exit
fi

sleep 2

echo -e "\n"

echo "delete other files"
rm -rf /etc/zabbix
rm -rf /var/lib/zabbix

echo "The end.."
sleep 2
exit
