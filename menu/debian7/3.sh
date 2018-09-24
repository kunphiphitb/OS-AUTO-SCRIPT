#!/bin/bash

printf "Name to edit : "; read user
if cat /etc/passwd |grep $user: >/dev/null 2>/dev/null
then
printf ""
else
echo "USERNAME EXIST"
exit
fi
printf "Change from $user to : "; read nome
usermod -l $nome $user 1>/dev/null 2>/dev/null
read -p "New password : " Passwd
echo -e "  "
echo -e "\nFrom $user Change To $nome "
echo -e " "
echo -e "$Passwd\n$Passwd\n"|passwd $nome &> /dev/null
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo -e "*************************************"
echo -e "********** Download File ************"
echo -e "*************************************"
echo -e "Back to menu"
echo -e"
exit
