#!/bin/bash

apt-get update
apt-get update --fix-missing
apt-get install -y curl wget vim nano lsof net-tools dialog software-properties-common less unzip

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#Download appropriate package for the OS version
#Choose only ONE of the following, corresponding to your OS version

#Ubuntu 20.04
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
apt-get update

ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev mssql-server
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
