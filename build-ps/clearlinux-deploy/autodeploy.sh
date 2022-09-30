#!/bin/sh

echo "This file can't be used to upgrade because replace datafiles."
echo "CRTL + c to cancel."
sleep 10
echo "Continue with deploy"
echo "Locating the tar.gz and extract to /usr/local/mysql"
tar xzf percona-xtradb* -C /usr/local/mysql
echo "Fixing systemd file"
cp mysql-systemd /usr/local/mysql/bin/
chmod +x /usr/local/mysql/bin/mysql-systemd
echo "Altering the operating system environment."
cp -rf sysconfig /etc/
cp profile /etc/
cp -rf security /etc/
cp sysctl.conf /etc/
cp mysql.service /etc/systemd/system/
echo "Install jemalloc"
mkdir /opt
cp -rf jemalloc /opt/
echo "Install openssl_1_1_1-stable"
cp -rf openssl /opt/
echo "Install configuration files"
cp -rf mysql /etc
echo "Creating other folders."
mkdir -p /var/lib/mysql
chown mysql:mysql /var/lib/mysql
:> /var/log/mysqld.log
chown mysql:mysql /var/log/mysqld.log 
mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld
echo "Initialize the default database."
/usr/local/mysql/bin/mysqld --initialize-insecure --console --user=mysql --datadir=/var/lib/mysql
echo "Enable MySQL and reboot server to load all things."
echo "After reboot, remember to change the password. Very important: execute mysql_secure_installation because root has no password."
systemctl enable mysql
reboot