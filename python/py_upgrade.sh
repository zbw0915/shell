#!/bin/bash

nowDir=`pwd`
dtInstall=`date +%Y%m%d%H%M%S`

echo "install the concerned package of python"
yum install -y gcc gcc-c++ make zlib zlib-devel openssl openssl-devel
sleep 2
echo "downloading python-2.7.13"

mkdir -p /opt/python/
wget -c ops.roamway.com:4766/python/Python-2.7.13.tgz -P /opt/python/
sleep 1

tar zxvf /opt/python/Python-2.7.13.tgz -C /opt/python/
sleep 1
cd /opt/python/Python-2.7.13/
./configure --prefix=/usr/local/python2.7.13  --enable-shared


make && make install


sleep 1

echo "Upgrading Python-2.6.6 to Python-2.7.13"
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/python2.7.13/bin/python2.7 /usr/bin/python
sed -i 's/\#\!\/usr\/bin\/python/\#\!\/usr\/bin\/python2\.6\.6/' /usr/bin/yum

echo "/usr/local/python2.7.13/lib" >> /etc/ld.so.conf

/sbin/ldconfig
/sbin/ldconfig -V
echo "Current Python has been upgraded,the version is " `python -V`




echo "install setuptool"
wget -c ops.roamway.com:4766/python/setuptools-39.0.1.zip#md5=75310b72ca0ab4e673bf7679f69d7a62 -P /opt/python/
unzip /opt/python/setuptools-39.0.1.zip -d /opt/python/
sleep 1
cd /opt/python/setuptools-39.0.1/
python setup.py install

sleep 2

echo "install pip"
wget -c ops.roamway.com:4766/python/pip-9.0.2.tar.gz#md5=2fddd680422326b9d1fbf56112cf341d -P /opt/python/
tar zxvf /opt/python/pip-9.0.2.tar.gz -C /opt/python/
sleep 1
cd /opt/python/pip-9.0.2/
python setup.py install
sleep 2
ln -s /usr/local/python2.7.13/bin/pip2.7 /usr/bin/pip

echo "pip has been installed "
pip -V

exit
