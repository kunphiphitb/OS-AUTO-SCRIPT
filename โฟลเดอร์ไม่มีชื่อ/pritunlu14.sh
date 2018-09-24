#!/bin/bash
# Pritunl Ubuntu 14

#go to root
cd

echo "installing...........20%"

#update
apt-get update; apt-get -y upgrade;

echo "installing...........40%"

#install command
apt-get -y install wget;
apt-get -y install curl;
apt-get -y install sudo;
apt-get -y install nano nmap;

echo "installing............60%"

#add ripository
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" >> /etc/apt/sources.list
echo "deb http://repo.pritunl.com/stable/apt trusty main" >> /etc/apt/sources.list

# install key
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 42F3E95A2C4F08279C4960ADD68FA50FEA312927
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
apt-get update;

echo "installing...............80%"

apt-get --assume-yes install pritunl mongodb-org
apt-get update; apt-get -y upgrade;

echo "installing................100%"
echo " "
echo "Done !!!"

#info
clear
echo " "
echo "IP ADDRESS: https://$MYIP"
echo " "
pritunl setup-key >> pritunl.key.txt
echo " "
nano pritunl.key.txt
echo "reboot vps ก่อนการใช้งาน" 
echo ""
