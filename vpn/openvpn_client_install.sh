#!/bin/sh

##auto install openvpn client for centos6

##cinema number
read -p "Please enter your number:" num

##install openvpn yum epel and dependent packages
yum -y install openssl openssl-devel lzo
rpm -ivh http://ip:8766/epel-release-5-4.noarch.rpm
sed -i 's:^mirrorlist=https:mirrorlist=http:g' /etc/yum.repos.d/epel.repo
yum -y install openvpn

##get keys file
wget -P /etc/openvpn/keys/ http://ip:8766/ca.crt
wget -P /etc/openvpn/keys/ http://ip:8766/ta.key
wget -P /etc/openvpn/keys/ http://ip:8766/client${num}.key
wget -P /etc/openvpn/keys/ http://ip:8766/client${num}.crt

##edit client config
cp /usr/share/doc/openvpn-2.3.14/sample/sample-config-files/client.conf /etc/openvpn/
sed -i 's:remote my-server-1 1194:remote ip 8765:g' /etc/openvpn/client.conf
sed -i 's:ca ca.crt:ca /etc/openvpn/keys/ca.crt:g' /etc/openvpn/client.conf
sed -i 's:cert client.crt:cert /etc/openvpn/keys/client'${num}'.crt:g' /etc/openvpn/client.conf
sed -i 's:key client.key:key /etc/openvpn/keys/client'${num}'.key:g' /etc/openvpn/client.conf
sed -i 's:remote-cert-tls server:;remote-cert-tls server:g' /etc/openvpn/client.conf
sed -i '/remote-cert-tls server/a\ns-cert-type server' /etc/openvpn/client.conf
sed -i 's:;tls-auth ta.key 1:tls-auth /etc/openvpn/keys/ta.key 1:g' /etc/openvpn/client.conf
sed -i 's:cipher AES-256-CBC:;cipher AES-256-CBC:g' /etc/openvpn/client.conf
sed -i 's:#comp-lzo:comp-lzo:g' /etc/openvpn/client.conf

###start and auto start
#sed -i '/var/lock/subsys/local/a\su -c "openvpn /etc/openvpn/client.conf >> /etc/openvpn/client.log &"' /etc/rc.local
##su -c "openvpn /etc/openvpn/client.conf >> /etc/openvpn/client.log &"
service openvpn start
chkconfig openvpn on
