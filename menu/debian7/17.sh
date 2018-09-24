clear
if [[ $1 == "" ]]
then
  echo ""
echo -e "\033[1;32m================
    Credit HTTP
================
   {1} Install Credit
   {2} Edit Credit 
   {3} Delet Credit\033[0m"
echo -e "\033[1;36m"
read -p "Selet : " opcao
else
opcao=$1
fi
case $opcao in
  1 | 01 )
echo 'DROPBEAR_BANNER="/etc/issue.net"' >> /etc/default/dropbear
nano /etc/issue.net
/etc/init.d/dropbear restart;;
  2 | 02 )
nano /etc/issue.net
/etc/init.d/dropbear restart;;
  3 | 03 )
echo '✮vpnseller.online✮' > /etc/issue.net
/etc/init.d/dropbear restart;;
esac
  
  
  
