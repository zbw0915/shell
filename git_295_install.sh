#!/bin/bash

echo "Remove the old git"
yum remove -y git

mkdir -p /opt/git/

echo "Install related dependence packages"
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel libcurl-devel perl-ExtUtils-MakeMaker

sleep 2

wget -c http://ops.roamway.com:4766/libiconv/libiconv-1.15.tar.gz -P /opt/git/

sleep 2

tar zxvf /opt/git/libiconv-1.15.tar.gz -C /opt/git/

sleep 2

cd /opt/git/libiconv-1.15

./configure --prefix=/usr/local/libiconv

sleep 2

make

sleep 2

make install



wget -c http://ops.roamway.com:4766/git/git-2.9.5.tar.gz -P /opt/git/

sleep 2

tar zxvf /opt/git/git-2.9.5.tar.gz -C /opt/git/
sleep 2

cd /opt/git/git-2.9.5/
./configure --with-curl --with-expat --with-iconv=/usr/local/libiconv/
make
sleep 2
make install

echo "git-2.9.5 has been installed successfully!"
