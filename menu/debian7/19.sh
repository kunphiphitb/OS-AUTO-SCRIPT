echo "<BODY text='ffffff'>"
clear
if [[ $1 == "" ]]
then
echo " "
  echo -e "\033[01;31m  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"
  echo " {   Welcome all to Scrip Enter  } "
  echo "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"
  echo " {    Support all web servers    } "
  echo "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"
  echo " {  Scrip made by Smile Fighter  } "
  echo "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"
  echo " "
echo "====================================
  User backup And Restore ..? 
====================================
   {1} Backup
   {2} Restore"
   echo -e "\033[01;31m"
read -p "select : " opcao
else
opcao=$1
fi
case $opcao in
  1 | 01 )
tar cf /home/vps/public_html/user.tar /etc/passwd /etc/shadow /etc/gshadow /etc/group;;
 2 | 02 )
 cd /
 read -p "Enter  IP/IP And Restore : " IP
wget -O user.tar "http://$IP/user.tar"
tar xf user.tar
rm user.tar;;
esac
cd
rm backup
