#!/usr/bin/env bash

#Create Variables
DOMAIN="nucleomerce.gq"
MYSQL_USER_DOMAIN="root"
MYSQL_PASS_DOMAIN=""

#Update dependences
sudo apt-get update
#Upgrade dependences
sudo apt-get upgrade -y

#Install Tasksel
sudo apt-get install tasksel -y
#Install LAMP
sudo tasksel install lamp-server

#Configure Virtual Host
sudo mkdir -p /var/www/$DOMAIN/public_html/
sudo chown -R $USER:$USER /var/www/
sudo chmod -R 777 /var/www/
sudo echo "<?php echo ('<h1>' .  $DOMAIN . '</h1>');" >> /var/www/$DOMAIN/public_html/index.html
sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo a2enmod rewrite
sudo service apache2 restart
# sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$DOMAIN.conf
sudo echo "<VirtualHost *:80>
      ServerAdmin tony.inuma@gmail.com
      ServerName $DOMAIN
      ServerAlias www.$DOMAIN
      DocumentRoot /var/www/$DOMAIN/public_html

    RewriteEngine On
          RewriteOptions inherit
          <Directory /var/www/$DOMAIN/public_html/>
                  Options Indexes FollowSymLinks MultiViews
                  AllowOverride All
                  Require all granted
          </Directory>

      ErrorLog ${APACHE_LOG_DIR}/error.log
      CustomLog ${APACHE_LOG_DIR}/access.log combined
  </VirtualHost>
  " >> ~/$DOMAIN.conf
sudo mv ~/$DOMAIN.conf /etc/apache2/sites-available/$DOMAIN.conf
sudo a2ensite $DOMAIN.conf
sudo a2dissite 000-default.conf
sudo service apache2 restart

#MYSQL USER
sudo mysql -e "CREATE USER '${MYSQL_USER_DOMAIN}'@'localhost' IDENTIFIED BY '${MYSQL_PASS_DOMAIN}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER_DOMAIN}'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

#CERBOT
sudo apt-get install certbot -y
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-apache -y
# sudo certbot --apache -d $DOMAIN -d www.$DOMAIN

#Dependences
sudo apt-get install php-mbstring -y
sudo apt-get install php-gettext -y
sudo apt-get install php-curl -y
sudo apt-get install php-zip -y
# sudo apt-get install php-mbstring -y
# sudo apt-get install php-xml -y
sudo apt-get install php-gd -y
sudo apt-get install php-intl -y
sudo apt-get install php-mcrypt -y
sudo apt-get install php-mysql -y
sudo apt-get install php-json -y
sudo apt-get install php-xsl -y
sudo apt-get install php-bcmath -y
sudo apt-get install php-iconv -y
sudo apt-get install php-soap -y
sudo service apache2 restart
