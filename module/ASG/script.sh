#!/bin/bash



# Install Apache
sudo su
sudo yum update -y
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd 
sudo systemctl start httpd



# Install mdb

sudo amazon-linux-extras install mariadb10.5 -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Install PHP

sudo amazon-linux-extras install php7.4 -y
sudo yum install php-mbstring php-xml php-gd -y



sudo systemctl restart httpd
sudo systemctl restart php-fpm



# permission

sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
chown apache:apache -R /var/www/html 


#!/bin/bash

sudo su
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz


#!/bin/bash
sudo systemctl stop httpd
sudo mkdir -p /var/www/html/wordpress
sudo sed -i 's#DocumentRoot "/var/www/html"#DocumentRoot "/var/www/html/wordpress"#' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd

#!/bin/bash

sudo yum update -y
sudo mkdir -p /var/www/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/ /var/www/html
sudo systemctl start httpd

#!/bin/bash


cd wordpress
sudo cp wp-config-sample.php wp-config.php


# Update the wp-config.php file with the provided values
sudo sed -i "s/database_name_here/${db_name}/" wp-config.php
sudo sed -i "s/username_here/${username}/" wp-config.php
sudo sed -i "s/password_here/${password}/" wp-config.php
sudo sed -i "s/localhost/${endpoint}/" wp-config.php


cd /
sudo cp -r wordpress /var/www/html/
sudo systemctl start httpd

