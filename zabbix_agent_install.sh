#!/bin/bash


for i in `seq 1 3`
do
read -p "Please input mysql password for root: " -s passwd
mysql -uroot -p$passwd -e "show databases;" >> /dev/null 2>&1
if [ $? -eq 0 ]; then
        break
else
        if [ $i -le 2 ]; then
                echo -e "\nThe wrong password, please try again"
        else
                echo -e "\nToo many attempts"
                exit
        fi
fi
done

echo -e "\n"

read -p "Plseae set zabbix hostname: " hostname


echo "Begin to configure zabbix monitoring service..."

sleep 1


mkdir -p /opt/software/

wget -c http://ops.roamway.com:4766/zabbix/zabbix_agent/zabbix-agent-3.4.3-1.el6.x86_64.rpm -P /opt/software/
if [ $? -eq 0 ]; then
        echo "zabbix-agent download successfully"
        else
        echo "zabbix-agent download failed"
	exit
fi

sleep 2


rpm -ivh /opt/software/zabbix-agent-3.4.3-1.el6.x86_64.rpm
if [ $? -eq 0 ]; then
	echo "zabbix-agent installed successufully"
	else
	echo "zabbix-agent installed failed"
	exit
fi


echo "Your zabbix hostname is $hostname"

sed -i "s/Hostname=Zabbix server/Hostname=$hostname/" /etc/zabbix/zabbix_agentd.conf

sleep 1

echo "Turn off passive mode"
sed -i 's/Server=127.0.0.1/#Server=127.0.0.1/' /etc/zabbix/zabbix_agentd.conf

sleep 1

echo "Set the remote server address"
sed -i 's/ServerActive=127.0.0.1/ServerActive=115.28.70.230:32273/' /etc/zabbix/zabbix_agentd.conf

echo "Set StartAgents parameter"
sed -i "s/# StartAgents=3/StartAgents=0/" /etc/zabbix/zabbix_agentd.conf
sleep 1

echo "automatic startup configuration"
/sbin/chkconfig zabbix-agent on

sleep 1

echo "Zabbix monitoring service has been configured successfully"

sleep 2

echo "Begining to configure mysql monitor"
wget -c http://ops.roamway.com:4766/zabbix/percona-zabbix-templates/percona-zabbix-templates-1.1.8-1.noarch.rpm -P /opt/software/
if [ $? -eq 0 ]; then
	echo "percona-zabbix-templates-1.1.8-1.noarch.rpm download successfully"
	else
	echo "percona-zabbix-templates-1.1.8-1.noarch.rpm download failed, exit .."
	sleep 1
	exit
fi

echo -e "\n"

rpm -ivh /opt/software/percona-zabbix-templates-1.1.8-1.noarch.rpm
if [ $? -eq 0 ]; then
        echo "zabbix-template installed successufully"
        else
        echo "zabbix-template installed failed"
        exit
fi


sleep 2

rm -rf /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /etc/zabbix/zabbix_agentd.d/

sed -i 's/cactiuser/zabbix/g' /var/lib/zabbix/percona/scripts/ss_get_mysql_stats.php

echo "add zabbix user and configure privileges"
mysql -uroot -p$passwd -e "GRANT USAGE,PROCESS,REPLICATION CLIENT,REPLICATION SLAVE ON *.* TO zabbix@localhost IDENTIFIED BY 'zabbix';"

mysql -uroot -p$passwd -e "flush privileges;"

echo "zabbix user have been added and configured completed"

echo "start zabbix-agent service"

/etc/init.d/zabbix-agent start >> /dev/null
if [ $? -eq 0 ]; then
        echo "zabbix-agent start successfully"
        else
        echo "zabbix-agent start failed"
fi

rm -rf /opt/software

echo "The end.."

sleep 2
