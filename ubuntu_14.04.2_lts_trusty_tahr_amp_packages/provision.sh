#!/usr/bin/env bash

# Ubuntu 14.04.2 LTS (Trusty Tahr) Vagrant box provisioning
# Basic install, no compilation, mostly from official dist repositories.
#
# Author: Wojciech Fornal <wojciechfornal.com>

# Exit immediately if any command returns anything other than 0
# set -e

# Do not ask questions
export DEBIAN_FRONTEND=noninteractive

VGR_SLEEP=2
VGR_TEMP_DIR="/tmp"
VGR_WAIT_FOR_USER=1

# Common prerequisites:
VGR_COMMON_PREREQUISITES_INSTALL=1

# Apache settings
VGR_APACHE_INSTALL=1

# io.js
VGR_IO_INSTALL=1

# MySQL
VGR_MYSQL_INSTALL=1

# nginx
VGR_NGINX_INSTALL=1

# Node.js
VGR_NODE_INSTALL=1

# Perl settings
VGR_PERL_INSTALL=1

#PHP settings
VGR_PHP_INSTALL=1

function prompt {
  while true; do
    read -p "Continue (y/n)?" yn
    case $yn in
      [Yy]* ) continue;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

echo "================================================================================"
echo "ADDING PACKAGES REPOSITORIES"
echo "================================================================================"
# This is where 3rd party repositories may be added.
# Refer to /etc/apt/sources.list and eventually to files inside /etc/apt/sources.list.d.
# Remember to download referenced PGP keys.
# apt-key adv -q --keyserver keyserver.ubuntu.com --recv-keys ...
echo ">>> nginx repositories"
cat <<EOF > /etc/apt/sources.list.d/nginx.list
deb http://nginx.org/packages/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/ubuntu/ trusty nginx 
EOF

if [ $VGR_WAIT_FOR_USER = 1 ]; then
prompt
fi

# Fetch PGP key silently to standard output and then add it to the keyring using standard input.
wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add - > /dev/null

echo "================================================================================"
echo "UPDATING LOCAL PACKAGES INDEXES"
echo "================================================================================"
# Resynchronize package index files from their sources.
apt-get update -y

# beg: if provisioned
# if [ ! -f "var/vagrant_provisioned" ]; then

  echo "================================================================================"
  echo "Software not yet provisioned, it seems..."
  echo "================================================================================"
  
  echo $'\n\n'
  
  # beg: install common prerequisites?
  if [ $VGR_COMMON_PREREQUISITES_INSTALL = 1 ]; then
  echo "================================================================================"
  echo "COMMON PREREQUISITES"
  echo "================================================================================"
  apt-get install -y dos2unix
  apt-get install -y perl-doc
  fi
  # end: install common prerequisites?
  
  # beg: install Apache?
  if [ $VGR_APACHE_INSTALL = 1 ]; then
  
    echo "================================================================================"
    echo "APACHE"
    echo "================================================================================"
    echo $'\n'
    
    VGR_TEST=$(service apache2 status 2>&1)
    if [[ $VGR_TEST == *"unrecognized"* ]]
    then
      echo -e "\e[41mApache 2 not present, installing...\033[0m"
      sleep $VGR_SLEEP
      sudo apt-get install -Vy apache2
      if [ ! -e /etc/apache2/conf-available/common.conf ]; then
        echo "creating /etc/apache2/conf-available/common.conf"
        printf '%s\n' 'ServerName localhost' >> /etc/apache2/conf-available/common.conf
      fi
      # Set up global server name by using common.conf.
      a2enconf common
      # Default Apache host configured (the "Debian Way"?).
      # It is already symlinked to /etc/apache2/sites-enabled/000-default.conf.
      mv -bf /tmp/000-default.conf /etc/apache2/sites-available/000-default.conf
      # service apache2 restart
      echo $'\n\n'
    else
      echo -e "\e[42mApache 2 already present, continue...\033[0m"
      sleep $VGR_SLEEP
    fi
  
  fi
  # end: install Apache?
  
  # beg: install nginx?
  echo "================================================================================"
  echo "NGINX"
  echo "================================================================================"
  echo $'\n'
  if [ $VGR_NGINX_INSTALL = 1 ]; then
    # Install nginx and upgrade configuration file if there are no local changes, otherwise preserve local configuration file
    apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install nginx
    cp -bf /tmp/nginx_default.conf /etc/nginx/conf.d/default.conf
    # no need to hot reload, force restart
    service nginx restart
  fi
  # end: install nginx?
  
  # beg: install PHP
  if [ $VGR_PHP_INSTALL = 1 ]; then
  
  echo "================================================================================"
  echo "PHP"
  echo "================================================================================"
  echo $'\n\n'
  
  VGR_PHP_TEST=$(php --version 2>&1)
  if [[ ! VGR_PHP_TEST = *"PHP"* ]]
  then
    echo -e "\e[41mPHP not present, installing...\033[0m"
    sleep $VGR_SLEEP
    apt-get install -Vy libapache2-mod-php5
    # back-up default php.ini (with productions settings)
    mv -uv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bak
    # use development config
    cp -fsv /usr/share/php5/php.ini-development /etc/php5/apache2/php.ini
    apt-get install -y php5-mysql
    service apache2 restart
  else
    echo -e "\e[42mPHP already present, continue...\033[0m"
    sleep $VGR_SLEEP
  fi
  
  fi
  # end: install PHP
  
  # beg: install MySQL
  echo "================================================================================"
  echo "MySQL"
  echo "================================================================================"
  echo $'\n\n'
  command -v node >/dev/null 2>&1 || { VGR_MYSQL_PRESENT=0; }
  if [ $VGR_MYSQL_INSTALL = 1 -a $VGR_MYSQL_PRESENT = 0 ]; then
    echo -e "\e[41mMySQL not present, installing...\033[0m"
    sleep $VGR_SLEEP
    # MySQL prompts for root password during installation.
    # Let's automate that by using a preconfiguration with debconf database.
    debconf-set-selections <<< 'mysql-server mysql-server/root_password password Temp123$'
    debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password Temp123$'
    sudo apt-get install -y mysql-server
  else
    echo -e "\e[42mMySQL already present, continue...\033[0m"
    sleep $VGR_SLEEP
  fi
  # end: install MySQL?
  
  # beg: install Node?
  echo "================================================================================"
  echo "Node.js"
  echo "================================================================================"
  command -v node >/dev/null 2>&1 || { VGR_NODE_PRESENT=0; }
  if [ $VGR_NODE_INSTALL = 1 -a $VGR_NODE_PRESENT = 0 ]; then
    echo -e "\e[41mNode.js not present, installing...\033[0m"
    sleep $VGR_SLEEP
    curl -s http://nodejs.org/dist/v0.12.1/node-v0.12.1-linux-x64.tar.gz -o /tmp/node.tar.gz
    tar -xvf /tmp/node.tar.gz -C /tmp
    cp -pr /tmp/node-v0.12.1-linux-x64 /usr/local
    ln -s /usr/local/node-v0.12.1-linux-x64/ /usr/local/node
    # Node.js /bin dir is added to the PATH in bash profile
  else
    echo -e "\e[42mNode.js already present, continue...\033[0m"
    sleep $VGR_SLEEP
  fi
  # end: install Node?
  
  # beg: tweaks
  mv -bfv /tmp/onlogin.sh /etc/profile.d/onlogin.sh
  dos2unix /etc/profile.d/onlogin.sh
  chmod +x /etc/profile.d/onlogin.sh
  mv -bfv /tmp/.profile ~/.profile
  mv -bfv /tmp/sudoers /etc/sudoers
  chown root:root /etc/sudoers
  # end: tweaks
  
# fi
# end: if provisioned

echo "================================================================================"
echo "CHECKS"
echo "================================================================================"
echo -e "\a"
sleep $VGR_SLEEP
apache2ctl status | grep Apache
# alternative approach: service apache2 status
php --version | grep PHP
a2enmod php5