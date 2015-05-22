#!/bin/bash
 
# Update und Apache installieren
sudo apt-get -y update
sudo apt-get -y install apache2
 
# MySQL installieren
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server
 
# MySQL Konfiguration anpassen und externe Connections zulassen
sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
sudo mysql -u root -proot --execute "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' with GRANT OPTION; FLUSH PRIVILEGES;" mysql
 
# MySQL neu starten
sudo service mysql restart
 
# PHP 5.3 installieren
sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-xdebug
 
# php.ini anpassen
# Loglevel hochsetzen
sudo sed -i.bak 's/error_reporting = E_ALL &amp; ~E_DEPRECATED/error_reporting = E_ALL/g' /etc/php5/apache2/php.ini
# XDebug konfigurieren
echo "xdebug.default_enable = 1" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.idekey = \"PHPStorm\"" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_enable = 1" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_autostart = 0" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_port = 9000" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_handler = dbgp" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
echo "xdebug.remote_host = `netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10`" | sudo tee -a /etc/php5/apache2/conf.d/xdebug.ini
 
# Apache neu starten
sudo service apache2 restart
 
# IP-Adresse nochmal ausgeben
echo "+------------------------------------------------------------------"
echo "|"
/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print "| Website erreichbar unter http://dev.torto.net (IP: "$1")"}'
echo "|"
echo "+------------------------------------------------------------------"