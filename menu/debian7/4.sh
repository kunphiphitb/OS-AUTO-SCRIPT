#!/bin/bash
read -p "old name: " namer
 if cat /etc/passwd |grep $namer: > /dev/null
 then
 echo " "
 else
 clear
 echo -e "\033[1;36muser $namer No name"
 exit
 fi
clear
echo -e "\033[1;36m[ Select menu \033[0m" 
echo -e "\033[1;36m1) change Password \033[0m" 
echo -e "\033[1;36m2) number of users\033[0m" 
echo -e "\033[1;36m3) Set new expiration date \033[0m" 
read -p "print: " option
if [ $option -eq 1 ]
then
read -p "Enter new passwd for $namer: " senha
(echo "$senha" ; echo "$senha" ) |passwd $namer > /dev/null 2>/dev/null
echo -e "\033[1;36mChange passwd successfully"
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo -e "\033[1;36m***********************************"
echo -e "\033[1;36m********** Download File ********** "
echo -e "\033[1;36m***********************************"
echo -e "----------------------------------------------------------------"
echo -e "Back to menu"
exit
