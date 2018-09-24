#!/bin/bash
clear

read -p "Username : " Login
read -p "Password : " Passwd
read -p "Expired (Day): " TimeActive

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$TimeActive days" +"%Y-%m-%d"` -s /bin/nologin -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Passwd\n$Passwd\n"|passwd $Login &> /dev/null
echo "hard maxsyslogins $Maxmulti" >> /etc/security/limits.conf
echo "AllowUsers $Login" >> /etc/security/limits.conf
echo "MaxSessions $Maxmulti" >> /etc/security/limits.conf
echo "* hard maxsyslogins $Maxmulti" >> /etc/security/limits.conf
clear
echo -e "      Host:         $IP"
echo -e "      Username:     $Login"
echo -e "      Password:     $Passwd"
echo -e "      วันหมดอายุ:     $exp"
echo -e "      OPENVPN:      443"
echo -e "      DROPBEAR :    109, 110, 143"
echo -e "      SSH:          22"
echo -e "      SQUID:      8080"
echo -e "      Auto kill user maximal login 2"



