#!/bin/bash
# 功能：自动部署pptp client
# 适合环境：centos 6.x


# 参数初始化
##########################################
vpn_ip=117.22.228.210
user=$2         #需要修改
pass=$3         #需要修改
dst_ip=(
'192.168.98.87/32'
)

##########################################

# 卸载vpn client函数
#############################################################################################################
function remove()
{
	# 断开拔号
	poff
	# 卸载pptp相关包
	pptpsetup -delete mopon_vpn
	yum remove -y ppp pptp pptp-setup
        # 清除pptp模块
	rm -f /etc/sysconfig/modules/nf_conntrack_pptp.modules	
	# 清除ppp0路由
	sed  -i "/ppp0/d" /etc/sysconfig/network
	# 清除crontab
	sed -i "/断线重拔/d" /var/spool/cron/root
	sed -i "/ppp0/d" /var/spool/cron/root
	# 清除开机启动
	sed -i "/开机启动拔号/d" /etc/rc.local
	sed -i "/pon mopon_vpn/d" /etc/rc.local
	
	echo "vpn client清除完成"
	exit 0
}

# 调用vpn client卸载程序
if [ $1 == "-u" ];then remove;fi 



# 如果没有输入参数则显示帮助
##############################################################################################################
if [ $# -lt 2 ];then echo -e '''Usage:dial_vpn [OPTION] username "password"
OPTION:
	-i	install vpn client
	-u	remove vpn client
''';
exit 0;
fi

# 1.安装相关软件包
##############################################################################################################
if [ `/sbin/ifconfig|grep ppp0|wc -l` -eq 0 ];then poff;fi # 如果在线则断开拔号
 
yum install -y ppp pptp pptp-setup
cp /usr/share/doc/ppp-*/scripts/pon /usr/share/doc/ppp-*/scripts/poff /usr/share/doc/ppp-*/scripts/plog /usr/sbin/
chmod +x /usr/sbin/pon /usr/sbin/poff /usr/sbin/plog

# 2.开机加载nf_conntrack_pptp模块
##############################################################################################################
if [ ! -f /etc/sysconfig/modules/nf_conntrack_pptp.modules ];then
(
cat << EOF
#！/bin/sh 
/sbin/modinfo -F filename nf_conntrack_pptp > /dev/null 2>&1 
if [ \$? -eq 0 ]; then 
    /sbin/modprobe nf_conntrack_pptp 
fi
EOF
) > /etc/sysconfig/modules/nf_conntrack_pptp.modules
chmod 755 /etc/sysconfig/modules/nf_conntrack_pptp.modules
modprobe nf_conntrack_pptp
fi

# 3.配置pptp帐号并启动拔号
##############################################################################################################
if [ -f /etc/ppp/peers/mopon_vpn ];then	pptpsetup -delete mopon_vpn;fi
pptpsetup --create mopon_vpn --server $vpn_ip --username $user --password $pass --encrypt --start

# 4.添加永久路由
##############################################################################################################
sed  -i "/ppp0/d" /etc/sysconfig/network  #清除ppp0路由
if [ `cat /etc/sysconfig/network|grep "route add"|wc -l` -eq 0 ];then
	for i in "${dst_ip[@]}" ; do
        	ip=($i)
			if [ `echo $ip|grep "/32"|wc -l` -eq 1 ];then 
				route add $ip dev ppp0
				echo 'route add '$ip' dev ppp0' >> /etc/sysconfig/network
			else
				route add -net $ip dev ppp0
				echo 'route add -net '$ip' dev ppp0' >> /etc/sysconfig/network
			fi
	done
fi

# 5.断线重拔
##############################################################################################################
if [ `cat /var/spool/cron/root|grep "pon mopon_vpn"|wc -l` -eq 0 ];then
    echo '# vpn断线重拔' >>/var/spool/cron/root 
    echo '*/5 * * * * if [ `/sbin/ifconfig|grep ppp0|wc -l` -eq 0 ];then source /etc/init.d/functions;pon mopon_vpn;fi' >>/var/spool/cron/root 
fi

if [ `cat /var/spool/cron/root|grep "ping -c 2 -w 2 172.22.10.254"|wc -l` -eq 0 ];then
echo '*/5 * * * * ping -c 2 -w 2 172.22.10.254  &>/dev/null && result=0 || result=1 ; if [ "$result" == 1 ];then source /etc/init.d/functions; poff mopon_vpn >> /dev/null; pon mopon_vpn;fi' >> /var/spool/cron/root
fi

# 6.加入开动启动拔号
##############################################################################################################
if [ `cat /etc/rc.local|grep "pon mopon_vpn"|wc -l` -eq 0 ];then
    echo '# 开机启动拔号' >>/etc/rc.local 
	echo "pon mopon_vpn"  >>/etc/rc.local
fi
