#!/bin/bash

test=`cat /etc/ssh/sshd_config | grep "#sftp_end"`
if [[ $test != "#sftp_end" ]]; then
echo "开始部署sftp"
sleep 2

#定义sftp路径、组、用户
sftp_path=/home/admin/zhuanzi  
group=ngsftp                      
user=admin       
#添加组、用户、密码
groupadd $group
useradd -g $group -s /bin/false $user   
echo $user:123 | chpasswd
#创建sftp路径并分配相应权限
mkdir -p $sftp_path
usermod -d $sftp_path $user
chown root:$group /home/admin
chmod 755 $sftp_path
#配置ssh已保证sftp用户登录后固定在特定目录下
sed -i 's/^Subsystem/#&/' /etc/ssh/sshd_config

sed -i '/\Port 36566/a\Port 8026\' /etc/ssh/sshd_config

cat << EOF >> /etc/ssh/sshd_config
Subsystem       sftp    internal-sftp
Match Group ngsftp
ChrootDirectory /home/admin/zhuanzi
ForceCommand    internal-sftp
AllowTcpForwarding no
X11Forwarding no
EOF
echo "#sftp_end" >> /etc/ssh/sshd_config
#重启ssh服务
service sshd restart
sleep 2

else
echo "sftp已经部署,无需重复操作."
sleep 1
exit
fi
