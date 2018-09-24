#!/bin/bash
# Modified by kunphiphit
cd
sed -i '$ i\screen -AmdS limit /usr/bin/limit.sh' /etc/rc.local
sed -i '$ i\screen -AmdS ban /usr/bin/ban.sh' /etc/rc.local
sed -i '$ i\screen -AmdS limit /usr/bin/limit.sh' /etc/rc.d/rc.local
sed -i '$ i\screen -AmdS ban /usr/bin/ban.sh' /etc/rc.d/rc.local
echo "0 0 * * * root /usr/bin/user-expire" > /etc/cron.d/user-expire

cat > /usr/bin/ban.sh <<END3
#!/bin/bash
#/usr/bin/user-ban
END3

cat > /usr/bin/limit.sh <<END3
#!/bin/bash
#/usr/bin/user-limit
END3

cd /usr/bin/
wget -O a "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/premium-script"
wget -O menu "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/menu"
wget -O 1 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-add"
wget -O 2 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-generate"
wget -O 3 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/trial"
wget -O 4 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-active"
wget -O 5 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-password"
wget -O 6 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-ban"
wget -O 7 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-unban"
wget -O 8 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-lock"
wget -O 9 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-unlock"
wget -O 10 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-delete"
wget -O 11 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-detail"
wget -O 12 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-list"
wget -O 13 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-login"
wget -O 14 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-log"
wget -O 15 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-limit"
wget -O 16 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/infouser"
wget -O 17 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/expireduser"
wget -O 18 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-delete-expired"
wget -O 19 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-expire"
wget -O 20 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-limit"
wget -O 21 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-ban"
wget -O 22 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/speedtest"
wget -O 23 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/bench-network"
wget -O 24 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/ram"
wget -O 25 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port"
wget -O 26 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/auto-reboot"
wget -O 27 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-install"
wget -O 28 "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/diagnostics"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/premium-script"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-add"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-generate"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/trial"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-active"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-password"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-ban"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-unban"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-lock"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-unlock"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-delete"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-detail"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-list"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-login"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-log"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-limit"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/infouser"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/expireduser"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-delete-expired"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/user-expire"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-limit"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-ban"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/speedtest"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/bench-network"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/ram"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port-dropbear"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port-openssh"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port-openvpn"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/edit-port-squid"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/auto-reboot"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/log-install"
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/menu/deb8/diagnostics"
chmod +x a
chmod +x menu
chmod +x 1
chmod +x 2
chmod +x 3
chmod +x 4
chmod +x 5
chmod +x 6
chmod +x 7
chmod +x 8
chmod +x 9
chmod +x 10
chmod +x 11
chmod +x 12
chmod +x 13
chmod +x 14
chmod +x 15
chmod +x 16
chmod +x 17
chmod +x 18
chmod +x 19
chmod +x 20
chmod +x 21
chmod +x 22
chmod +x 23
chmod +x 24
chmod +x 25
chmod +x 26
chmod +x 27
chmod +x 28
chmod +x premium-script
chmod +x user-add
chmod +x user-generate
chmod +x trial
chmod +x user-active
chmod +x user-password
chmod +x user-ban
chmod +x user-unban
chmod +x user-lock
chmod +x user-unlock
chmod +x user-delete
chmod +x user-detail
chmod +x user-list
chmod +x user-login
chmod +x user-log
chmod +x user-limit
chmod +x infouser
chmod +x expireduser
chmod +x user-delete-expired
chmod +x user-expire
chmod +x log-limit
chmod +x log-ban
chmod +x speedtest
chmod +x bench-network
chmod +x ram
chmod +x edit-port
chmod +x edit-port-dropbear
chmod +x edit-port-openssh
chmod +x edit-port-openvpn
chmod +x edit-port-squid
chmod +x auto-reboot
chmod +x log-install
chmod +x diagnostics
chmod +x limit.sh
chmod +x ban.sh
screen -AmdS limit /usr/bin/limit.sh
screen -AmdS ban /usr/bin/ban.sh
clear
cd
echo " "
echo " "
echo "Premium Script Successfully Update!"
echo "Modified by kunphiphit"
echo " "
echo " "
