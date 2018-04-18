#!/bin/bash

echo "Begin to configure zabbix monitoring service..."
sleep 1

#rpm -ivh /opt/zabbix-agent-3.0.4-1.el6.x86_64.rpm


echo "Fetch the cinema code from database and specify hostname"
cinema=`mysql -uroot -pngV5123 -e "select * from SCTS.ng_base_cinema_info;" | grep -v "cinemaCode" | awk '{print $2}'`

sed -i "s/Hostname=Zabbix server/Hostname=$cinema/" /etc/zabbix/zabbix_agentd.conf

sleep 1

echo "Turn off passive mode"
sed -i 's/Server=127.0.0.1/#Server=127.0.0.1/' /etc/zabbix/zabbix_agentd.conf

sleep 1

echo "Set the remote server address"
sed -i 's/ServerActive=127.0.0.1/ServerActive=117.22.228.210:51001/' /etc/zabbix/zabbix_agentd.conf

echo "Set StartAgents parameter"
sed -i "s/# StartAgents=3/StartAgents=0/" /etc/zabbix/zabbix_agentd.conf
sleep 1

echo "start zabbix-agent service"
service zabbix-agent start >> /dev/null
if [ $? -eq 0 ]; then
	echo "zabbix-agent start successfully"
	else
	echo "zabbix-agent start failed"
fi

sleep 1

echo "automatic startup configuration"
chkconfig zabbix-agent on

sleep 1

echo "Zabbix monitoring service has been configured successfully"
