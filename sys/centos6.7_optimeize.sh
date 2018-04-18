#!/bin/bash

echo "To ensure the system works effectively ,some default parameter will be initialized"
echo "by this script. Initializing system will take about 5 five miniutes, which is depend"
echo "on performance of this machine and network"

sleep 5

touch /tmp/initialize
test=`cat /tmp/initialize`
if [[ $test != "completed" ]]; then
echo "ready to initialize!"
sleep 2

#turn off selinux
sed -i '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config

#optimize history and uK environment
echo 'export HISTTIMEFORMAT="%F %T `whoami` "' >> /etc/profile
source /etc/profile

#optimize limits.conf
cat >> /etc/security/limits.conf << EOF
*     soft    nofile    65535
*     hard    nofile    65535
root  soft    nproc     65535
root  hard    nproc     65535
EOF

#optimize 90-nproc.conf
sed -i 's/1024/unlimited/' /etc/security/limits.d/90-nproc.conf

#optimize kernel parameter
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fack = 1" >> /etc/sysctl.conf
echo "net.ipv4.neigh.default.gc_thresh1 = 8192" >> /etc/sysctl.conf
echo "net.ipv4.neigh.default.gc_thresh2 = 4092" >> /etc/sysctl.conf
echo "net.ipv4.neigh.default.gc_thresh3 = 8192" >> /etc/sysctl.conf

echo -e "\n"  >> /etc/sysctl.conf
echo "# Controls the use of TCP syncookies" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "# Controls the maximum number of shared memory segments, in pages" >> /etc/sysctl.conf
echo "kernel.shmall =  4294967296" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "vm.swappiness = 15" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "########滑动窗口" >> /etc/sysctl.conf
echo "net.core.wmem_default = 9174960" >> /etc/sysctl.conf
echo "net.core.rmem_default = 9174960" >> /etc/sysctl.conf
echo "net.core.rmem_max = 9174960" >> /etc/sysctl.conf
echo "net.core.wmem_max = 9174960" >> /etc/sysctl.conf
echo "net.core.optmem_max = 921600" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 92160 6000000 17476000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096  40960   409600" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "#######syn cookies" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 819200" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 94500000 915000000 927000000" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "#####TCP sockets最大数量" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_orphans = 3276800" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 120" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1024  65535" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog =  40960" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "#########并发连接########" >> /etc/sysctl.conf
echo "net.core.somaxconn = 40960" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "########TIME_WAIT 总量及重用" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 1440000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 5" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 15" >> /etc/sysctl.conf
echo "net.ipv4.tcp_retries2 = 5" >> /etc/sysctl.conf
echo "net.ipv4.tcp_orphan_retries = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_reordering = 5" >> /etc/sysctl.conf
echo "net.ipv4.tcp_retrans_collapse = 0" >> /etc/sysctl.conf
echo "net.ipv4.ipfrag_high_thresh = 5242880" >> /etc/sysctl.conf
echo "net.ipv4.tcp_slow_start_after_idle = 0" >> /etc/sysctl.conf
echo "net.ipv4.ipfrag_low_thresh = 2932160" >> /etc/sysctl.conf

echo -e "\n" >> /etc/sysctl.conf
echo "#####文件描述符" >> /etc/sysctl.conf
echo "fs.file-max = 500000" >> /etc/sysctl.conf
echo "fs.inotify.max_user_watches = 8192000" >> /etc/sysctl.conf
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
echo "vm.dirty_ratio = 1" >> /etc/sysctl.conf
echo "vm.dirty_background_ratio = 1" >> /etc/sysctl.conf
echo "vm.dirty_writeback_centisecs = 10" >> /etc/sysctl.conf 
echo "vm.dirty_expire_centisecs = 50" >> /etc/sysctl.conf

sysctl -p

#optimize SSH service
sed -i '/DNS/{s/#//g;s/yes/no/g}' /etc/ssh/sshd_config
sed -i '/\#Port 22/a\Port 36566\' /etc/ssh/sshd_config
service sshd restart

#optimize iptables
sed -i 's/-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/-A INPUT -m state --state NEW -m tcp -p tcp --dport 36566 -j ACCEPT/' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 36566 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 8061 -j ACCEPT\' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 8061 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 8071 -j ACCEPT\' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 8071 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 8500 -j ACCEPT\' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 8500 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT\' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 8026 -j ACCEPT\' /etc/sysconfig/iptables

/sbin/chkconfig iptables on
service iptables restart
sleep 1

#Add default DNS
echo "nameserver 114.114.114.114" > /etc/resolv.conf
echo "nameserver 223.5.5.5" >> /etc/resolv.conf

#uninstall mysql5.1 lib and all java development kit
yum remove -y mysql-libs-5.1.73-5.el6_6.x86_64
sleep 2

#install tools
yum install -y wget zip unzip vim lsof telnet gcc gcc-c++ autoconf automake make cmake openssh-clients bind-utils traceroute mtr lvm*  usbutils pciutils vixie-cron crontabs  ntp system-config-network-tui openssh-clients lrzsz
sleep 3

#sync time
/usr/sbin/ntpdate time.dnion.com >> /dev/null &
/usr/sbin/hwclock -w >> /dev/null &

#start crond
service crond start
sleep 2

#crond optimize
echo "15 3 * * * /home/scts/gziplogs.sh" >> /var/spool/cron/root
echo "* * */1 * * /usr/sbin/ntpdate time.dnion.com" >> /var/spool/cron/root
echo "50 23 * * * echo '' >  /sctsapp/tomcat_server/logs/catalina.out" >> /var/spool/cron/root
echo "55 23 * * * echo '' >  /sctsapp/tomcat_client/logs/catalina.out" >> /var/spool/cron/root

#the last of optimizing
echo "completed" >> /tmp/initialize
echo "mission complete！"
sleep 2

else
echo "System has already been initialized ,nothing to do."
sleep 1
exit
fi
