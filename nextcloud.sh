# Script works fine for BUSTER edition
cat /etc/os-release

# Update the software sources as follows
sudo apt-get update -y

# Install Apache webserver & extensions
sudo apt-get install apache2 -y
sudo apt-get -y install php php-gd sqlite php-sqlite3 php-curl php-zip php-xml php-mbstring libapache2-mod-php -y
sudo service apache2 restart

# Download and install Nextcloud
sudo wget https://download.nextcloud.com/server/releases/latest-21.zip
sudo mv latest-21.zip /var/www/html
cd /var/www/html
sudo unzip -q latest-21.zip
grep VersionString nextcloud/version.php
sudo chown www-data:www-data /var/www/html/nextcloud

# Datadir for cloud
sudo mkdir -p /var/nextcloud/data
sudo chown www-data:www-data /var/nextcloud/data
sudo chmod 750 /var/nextcloud/data

cd /var/www/html/nextcloud
sudo chown www-data:www-data config apps

sudo apt-get install -y mariadb-server python-mysqldb php-mysql
sudo /usr/bin/mysql_secure_installation

mysql -u root -pPASSWORD << EOF
create database nextcloud;
create user ncuser;
set password for ncuser = password("raindrop");
grant all PRIVILEGES on nextcloud.* to ncuser@localhost identified by 'raindrop';
EOF

sudo service apache2 restart
