#!/bin/bash
yum install httpd -y
service httpd start
yum install php php-mysql -y
yum install mysql-server -y
service mysqld start

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE myblog;
CREATE USER 'ec2-user'@'localhost' IDENTIFIED BY 'Dvir1994';
GRANT ALL PRIVILEGES ON myblog.* TO 'ec2-user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

#install wordpress
cd /var/www/html
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress myblog
cd myblog
mv wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/myblog/g" wp-config.php
perl -pi -e "s/username_here/ec2-user/g" wp-config.php
perl -pi -e "s/password_here/Dvir1994/g" wp-config.php

chkconfig --add httpd
chkconfig httpd on

chkconfig --add mysqld
chkconfig mysqld on

sudo shutdown -r now
