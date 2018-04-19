#/bin/bash

echo "check whether the nc has been installed or not"
package=`rpm -qa | grep ^nc-`

if [ $package != `rpm -qa | grep ^nc-` ]; then
   echo "preparing..."
   yum install nc -y >>/dev/null
   else
   echo "nc has been installd"
fi

for ip in `cat /tmp/gdc_new_final.txt`
do

ping $ip -c 2  >> /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo -e $ip is up "\c"

	sshd_port=`nc  -w 10 -z $ip 36566 | awk  '{print $7}'`

        if [ "$sshd_port" == "succeeded!" ]; then
           echo "port 36566 ok"
        else
           echo "port 36566 error"
        fi
else
	echo $ip is down
fi
done
