#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y php libapache2-mod-php php-mysql php-redis php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip apache2 mysql-server unzip
sudo systemctl start apache2 mysql
sudo systemctl enable apache2 mysql

# Change to the working directory
cd ${WORDPRESS_DIR}

# Download the latest WordPress
sudo wget https://wordpress.org/latest.zip

# Unzip the WordPress archive
unzip latest.zip

# Move WordPress files to Apache's web directory
sudo mv wordpress/* ${WORDPRESS_DIR}

# Create a WordPress configuration file from the sample
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/"${DB_NAME}"/" wp-config.php
sudo sed -i "s/username_here/"${DB_USER}"/" wp-config.php
sudo sed -i "s/password_here/"${DB_PASSWORD}"/" wp-config.php
sudo sed -i "s/localhost/"${RDS_ENDPOINT}"/" wp-config.php

#change permissions so wordpress can make changes
sudo chmod 755 /var/www/html

# Restart Apache
sudo systemctl restart apache2