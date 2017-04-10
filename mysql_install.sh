mysql_package="mysql-5.6.28-linux-glibc2.5-x86_64.tar.gz"
mysql_name="mysql-5.6.28-linux-glibc2.5-x86_64"
mysql_package_num=`rpm -qa|grep -i mysql |wc -l`
if [ ${mysql_package_num} -ge 1 ];then
	rpm -ev `rpm -qa|grep -i mysql` --nodeps
fi
rm -rf `find / -name mysql`
rm -rf /usr/local/mysql*
ps -ef|grep mysql|grep -Ev "grep|mysql_install.sh"|awk '{print $2}'|xargs kill -9
userdel -r mysql
groupdel mysql
groupadd mysql
useradd -r -g mysql mysql
tar xzvf /$mysql_package -C /usr/local
cd /usr/local
ln -s $mysql_name  mysql
chown -R mysql:mysql /usr/local/mysql
cd /usr/local/mysql/
scripts/mysql_install_db --user=mysql
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
service mysqld start
sed -i '/MYSQL_HOME/d' /etc/profile
sed -i '/mysql/d' /etc/profile
echo "MYSQL_HOME=/usr/local/mysql" >> /etc/profile
echo 'export PATH=$PATH:$MYSQL_HOME/bin' >> /etc/profile
source /etc/profile


####mysqladmin -u root password "quanyan888"
####GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'quanyan888' WITH GRANT OPTION;
####flush privileges;