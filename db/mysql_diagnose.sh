#!/bin/bash
for i in `seq 1 3`
do
read -p "Please mysql password for root: " -s passwd
mysql -uroot -p$passwd -e "show databases" >> /dev/null 2>&1
if [ $? -eq 0 ]; then
	break
else
	
	if [ $i -le 2 ]; then	
		echo -e "\nWrong passwd ,try again! "
        else
		echo -e "\nTwo many attemps"
	exit
	fi
fi
done


user="root"


echo "connections"
mysql -u$user -p$passwd -e "show global status like 'max_used_connections';"

#echo -e "\n"
mysql -u$user -p$passwd -e "show variables like 'max_connections';"

echo -e "\n"

max_used_connections=`mysql -uroot -p$passwd -e "show global status like 'max_used_connections';" | grep "Max_used_connections" | awk '{print $2}'`

max_connections=`mysql -uroot -p$passwd -e "show variables like 'max_connections';" | grep "max_connections" | awk '{print $2}'`

con_rate=`expr $max_used_connections/$max_connections*100 | bc -l`

conncet_rate=`expr "scale=3; $con_rate/1" |bc`
#echo $conncet_rate%

if [[ $connect_rate -lt 85 ]]; then
	echo "connection is ok"
else
	echo "connection is out of range"
fi





echo "temp tables"
mysql -u$user -p$passwd -e "show global status like 'created_tmp%';"

#echo -e "\n"

mysql -u$user -p$passwd -e "show variables where Variable_name in ('tmp_table_size', 'max_heap_table_size');"

echo -e "\n"

Created_tmp_disk_tables=`mysql -uroot -p$passwd -e "show global status like 'created_tmp%';" | grep "Created_tmp_disk_tables" | awk '{print $2}'`

Created_tmp_tables=`mysql -uroot -p$passwd -e "show global status like 'created_tmp%';" | grep "Created_tmp_tables" | awk '{print $2}'`

tmp_rate=`expr $Created_tmp_disk_tables/$Created_tmp_tables*100 | bc -l`

tmptab_rate=`expr "scale=3; $tmp_rate/1" |bc`
#echo $tmptab_rate%

if [ $tmptab_rate -lt 25 ]; then
	echo "temp table rate is ok"
else
	echo "temp table rate is out of range"
	echo "you should increase tmp_table_size and max_heap_table_size"
fi



echo -e "\n"
echo "open tables"
mysql -u$user -p$passwd -e "show global status like 'open%tables%';"

echo -e "\n"

echo "Threads"
mysql -u$user -p$passwd -e  "show global status like 'Thread%';"

echo -e "\n"

echo "query cache"
mysql -u$user -p$passwd -e "show global status like 'qcache%';"

echo -e "\n"

echo "Innodb_buffer_pool"
mysql -u$user -p$passwd -e "show status like 'Innodb_buffer_pool_%';"

echo -e "\n"

echo "table scan reate"
mysql -u$user -p$passwd -e "show global status like 'handler_read%';"

#echo -e "\n"

mysql -u$user -p$passwd -e "show global status like 'com_select';"

echo -e "\n"

echo "slow query"
mysql -u$user -p$passwd -e "show variables like '%slow%';"

