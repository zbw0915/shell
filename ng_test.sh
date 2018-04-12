#!/bin/bash

#检查本机IP地址
IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | head -1`

function local_source()

{

echo -e "\n"


echo "本机IP "$IP

#检查CPU个数
cpu_count=`cat /proc/cpuinfo | grep processor | wc -l`

echo "本机CPU个数 "$cpu_count


#检查CPU负载
five_min_cpu=`uptime | awk '{print $10}'`
ten_min_cpu=`uptime | awk '{print $11}'`
fifteen_min_cpu=`uptime | awk '{print $12}'`

echo "CPU负载:" "5分钟内 "$five_min_cpu  " 10分钟内 "$ten_min_cpu " 15分钟内 "$fifteen_min_cpu


#检查内存
total=`free -m | grep Mem | awk '{print $2}'`
used=`free -m | grep Mem | awk '{print $3}'`
free=`free -m | grep Mem | awk '{print $4}'`
buffers=`free -m | grep Mem | awk '{print $6}'`
cached=`free -m | grep Mem | awk '{print $7}'`

used_true=$(($used-$cached-$buffers))

free_true=$(($free+$buffers+$cached))

echo  "物理内存:" $total "MB "  "已使用:" $used_true "MB " "可用数:" $free_true "MB" 


#检查磁盘
#echo -e "\n"
echo "磁盘占用:"
df -h

}



function local_service()

{


#检查端口nc是否安装

package=`rpm -qa | grep ^nc-`

if [ $package != `rpm -qa | grep ^nc-` ]; then
   echo "安装包不完整，安装中..."
   yum install nc -y >>/dev/null

   else
   echo "安装包完整"
fi

echo -e "\n"
echo "正在检查系统服务..."



#检测前台服务
client=`nc -v -w 10 -z $IP 8061 | awk  '{print $7}'`

	if [ "$client" == "succeeded!" ]; then
	   echo "前台服务端口8061正常"
	else
	   echo "前台服务端口8061故障,请检查!!"
	fi


#检测后台服务
server=`nc -v -w 10 -z $IP 8071 | awk  '{print $7}'`

	if [ "$server" == "succeeded!" ]; then
	   echo "后台服务端口8071正常"
	else
	   echo "后台服务端口8071故障,请检查!!"
	fi


#检测Mysql服务

mysql=`nc -v -w 10 -z $IP 3306 | awk  '{print $7}'`

	if [ "$mysql" == "succeeded!" ]; then
	   echo "MySQL端口3306正常"
	else
	   echo "MySQL端口3306故障,请检查!!"
	fi


#检测Redis服务

redis=`nc -v -w 10 -z $IP 6379 | awk  '{print $7}'`
	
	if [ "$redis" == "succeeded!" ]; then
	   echo "Redis端口6379正常"
	else
	   echo "Redis端口6379故障,请检查!!"
	fi


#检测UK的uKeyNative服务端口

uk=`nc -v -w 10 -z $IP 9188 | awk  '{print $7}'`

	if [ "$uk" == "succeeded!" ]; then
	   echo "UK端口9188正常"
	else
	   echo "UK端口9188故障,请检查!!"
	fi

#检测UK的uKeyCCV服务端口

uk=`nc -v -w 10 -z $IP 9189 | awk  '{print $7}'`

        if [ "$uk" == "succeeded!" ]; then
           echo "UK端口9189正常"
        else
           echo "UK端口9189故障,请检查!!"
        fi

#检测netproxy服务

netproxy=`nc -v -w 10 -z $IP 8090 | awk  '{print $7}'`

	if [ "$netproxy" == "succeeded!" ]; then
	   echo "netproxy端口8090正常"
	else
	   echo "netproxy端口8090故障,请检查!!"
	fi


#检测自助取票服务

qupiao=`nc -v -w 10 -z $IP 8500 | awk  '{print $7}'`

        if [ "$qupiao" == "succeeded!" ]; then
           echo "自助取票服务端口8500正常"
        else
           echo "自助取票服务端口8500故障,请检查!!"
        fi


#检测ngmc-uc服务
uc=`nc -v -w 10 -z $IP 8246 | awk  '{print $7}'`

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

}

function component_location()
{

echo -e "\n"
echo "检查redis-server路径..."
if [ -f /sctsapp/linux_redis-2.4.5/redis-2.4.5/src/redis-server ];
then
	echo "redis-server路径正确,路径是/sctsapp/linux_redis-2.4.5/redis-2.4.5/src/redis-server"
else
	echo "redis-server路径错误,正确路径是/sctsapp/linux_redis-2.4.5/redis-2.4.5/src/redis-server"
fi

echo -e "\n"
echo "检查uKeyProxy路径..."
if [ -f /sctsapp/uKeyProxy/startup.sh ];
then
        echo "uKeyProxy路径正确,路径是/sctsapp/uKeyProxy/startup.sh"
else
        echo "uKeyProxy路径错误,正确路径是/sctsapp/uKeyProxy/startup.sh"
fi

echo -e "\n"
echo "检查netproxy路径..."
if [ -f /sctsapp/netproxy/startupNetProxy.sh ];
then
        echo "netproxy路径正确,路径是/sctsapp/netproxy/startupNetProxy.sh"
else
        echo "netproy路径错误,正确路径是/sctsapp/uKeyProxy/startup.sh"
fi

echo -e "\n"
echo "检查前台路径..."
if [ -f /sctsapp/tomcat_client/bin/startup.sh ];
then
        echo "前台路径正确,路径是/sctsapp/tomcat_client/bin/startup.sh"
else
        echo "前台路径错误, 正确路径是/sctsapp/tomcat_client/bin/startup.sh"
fi

echo -e "\n"
echo "检查后台路径..."
if [ -f /sctsapp/tomcat_server/bin/startup.sh ];
then
        echo "后台路径正确,路径是/sctsapp/tomcat_server/bin/startup.sh"
else
        echo "后台路径错误,正确路径是/sctsapp/tomcat_server/bin/startup.sh"
fi

}


function component_version()

{
echo -e "\n"

version_mysql=`mysql -V | awk '{print $5}' | sed -e 's/,//g'`
if [ $version_mysql != 5.6.21 ]; then
	echo "当前版本不是5.6.21,请替换"
else
	echo MySQL数据库版本正确 $version_mysql
fi

version_client=`/sctsapp/tomcat_client/bin/version.sh --version |awk '/Server version/{print $4}' | sed -e 's/Tomcat\///g'`
if [ $version_client != 7.0.69 ]; then
        echo "当前版本不是7.0.69,请替换"
else
        echo 前台Tomcat版本正确 $version_client
fi

version_server=`/sctsapp/tomcat_server/bin/version.sh --version |awk '/Server version/{print $4}' | sed -e 's/Tomcat\///g'`
if [ $version_server != 7.0.69 ]; then
        echo "当前版本不是7.0.69,请替换"
else
        echo 后台Tomcat版本正确 $version_server
fi

redis_version=`/sctsapp/linux_redis-2.4.5/redis-2.4.5/src/redis-server --version | awk '{print $4}'`
if [ $redis_version != 2.4.5 ]; then
        echo "当前版本不是2.4.5,请替换"
else
        echo 当前Redis版本正确 $redis_version
fi

#echo -e "\n"
}



function main()

{
echo -e "\n"
echo "欢迎使用NG平台诊断工具"
read -n1 -p "请选择需要选择
        1 检查本地资源
        2 检查NG服务
        3 检查各个组件路径
        4 检查各个组件版本
        N 退出
" choice
        case $choice in
	1)
                  local_source;
                  if [ $? != 0 ];
                  then
                        return 1;
                  fi
                  ;;

        2)
                  local_service;
                  if [ $? != 0 ];
                  then
                        return 1;
                  fi
                   ;;


        3)
                  component_location;
                  if [ $? != 0 ];
                  then
                        return 1;
                  fi
                   ;;

	4)
                  component_version;
                  if [ $? != 0 ];
                  then
                        return 1;
                  fi
                   ;;


N|n)
                        echo "用户已经退出"
                        exit 1
                   ;;
         *) echo "输入不正确"
                return 1;
                 ;;
        esac
        main
}
main

echo "NG系统诊断完成."
