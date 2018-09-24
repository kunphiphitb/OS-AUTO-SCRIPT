if [[ $1 == "" ]]
then
echo -e "\033[1;33m "
   echo "===Setting Reboot Time==="
   echo -e "\033[1;32m
   {1} Change time  reboot
   {2} Disable automatic reboot"
   
read -p " print : " opcao
else
opcao=$1
fi
case $opcao in
  01 | 1 )
  clear
  echo "=================="
read -p " hour    {00:02} : " Hour
read -p " minute  {00:59} : " Minute
echo "$Minute $Hour * * * root /sbin/reboot" > /etc/cron.d/reboot
service cron restart;;
 02 | 2 )
echo " " > /etc/cron.d/reboot
service cron restart;;
esac
