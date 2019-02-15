#!/bin/bash
echo $'\n'
echo -e "\e[30;103m                              \e[0m\e[49m A box with:"
echo -e "\e[30;103m                              \e[0m\e[49m   • io.js"
echo -e "\e[30;103m                              \e[0m\e[49m   • Node.js"
echo -e "\e[30;103m            \|||||/           \e[0m\e[49m   • nginx"
echo -e "\e[30;103m                              \e[0m\e[49m   • JBOSS"
echo -e "\e[30;103m             _   -            \e[0m\e[49m   • Apache"
echo -e "\e[30;103m          (  o   O  )         \e[0m\e[49m   • MySQL"
echo -e "\e[30;103m               ^              \e[0m\e[49m   • Perl"
echo -e "\e[30;103m             \___/            \e[0m\e[49m   • PHP"
echo -e "\e[30;103m                              \e[0m\e[49m   • and whatnot..."
echo -e "\e[30;103m______________________________\e[0m\e[49m"
echo -e "\e[30;103m                              \e[0m\e[49m"
echo -e "\e[30;103m   BINNJAMPPAW niah niah :)   \e[0m\e[49m"
echo -e "\e[30;103m                              \e[0m\e[49m"
echo $'\n'

VGR_MYSQL_PRESENT=1
VGR_NODE_PRESENT=1

if [ -d "/usr/local/node/bin" ] ; then
  export PATH=$PATH:/usr/local/node/bin
fi

uname -a
who am i
echo "PATH=$PATH"
apachectl status | grep Apache | head -2
perl -v | head -2 | tail -1
php --version | grep PHP | head -1
command -v node >/dev/null 2>&1 || { VGR_NODE_PRESENT=0; }
if [ ! $VGR_NODE_PRESENT = 0 ]; then
  VGR_NODE_VERSION=$(node --version | grep v | head -1)
  echo "Node.js" $VGR_NODE_VERSION
  unset VGR_NODE_PRESENT
  unset VGR_NODE_VERSION
fi
command -v mysql >/dev/null 2>&1 || { VGR_MYSQL_PRESENT=0; }
if [ ! $VGR_MYSQL_PRESENT = 0 ]; then
  VGR_MYSQL_VERSION=$(mysql --version | grep mysql | head -1)
  echo $VGR_MYSQL_VERSION
  unset VGR_MYSQL_VERSION
  unset VGR_MYSQL_PRESENT
fi
echo $'\n'