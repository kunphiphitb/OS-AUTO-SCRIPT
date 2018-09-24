#!/bin/bash
# Pritunl Debian 8 OS X86 & 64

# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#Add DNS Server ipv4
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 8.8.8.8" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 8.8.4.4" >> /etc/resolv.conf' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

#update
apt-get update; apt-get -y upgrade;

#install command
apt-get -y install wget;
apt-get -y install curl;
apt-get -y install sudo;
apt-get -y install nano nmap;

#add ripository

echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" > /etc/apt/sources.list.d/mongodb-org-3.4.list;
echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list;
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 0C49F3730359A14518585931BC711F9BA15703C6;
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A;
cat > /etc/apt/sources.list <<END1
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
END1
apt-get update

# dotdebkey
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs vnstat less screen psmisc apt-file whois ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential
apt-get -y install libio-pty-perl libauthen-pam-perl apt-show-versions

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i eth0
service vnstat restart

# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/kunphiphit/Debian8/master/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END2
user www-data;
worker_processes 1;
pid /var/run/nginx.pid;
events {
	multi_accept on;
  worker_connections 1024;
}
http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;
	autoindex on;
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;
	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;
	fastcgi_read_timeout 600;
  include /etc/nginx/conf.d/*.conf;
}
END2
mkdir -p /home/vps/public_html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END3
server {
  listen       5002;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/vps-access.log;
  error_log /var/log/nginx/vps-error.log error;
  root   /home/vps/public_html;
  location / {
    index  index.html index.htm index.php;
    try_files $uri $uri/ /index.php?$args;
  }
  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
}
END3
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# install dropbear
apt-get install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
/etc/init.d/dropbear restart

# install webmin
cd
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/jcameron-key.asc"
apt-key add jcameron-key.asc; 
rm -rf jcameron-key.asc;
apt-get update;
wget "https://prdownloads.sourceforge.net/webadmin/webmin_1.881_all.deb"
dpkg --install webmin_1.881_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -rf webmin_1.881_all.deb;
service webmin restart;
service vnstat restart;

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/kunphiphit/Debian8/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/kunphiphit/Debian8/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/kunphiphit/Debian8/master/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

# install pritunl
apt-get --assume-yes install pritunl mongodb-org
systemctl start mongod pritunl
systemctl enable mongod pritunl
apt-get update

# install squid3
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<-END
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl CONNECT method GET POST
acl SSH dst xxxxxxxxx-xxxxxxxxx
http_access allow SSH
http_access allow localnet
http_access deny all
http_port 8080
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname www.viber.com
END
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

#Setting UFW
apt-get -y install ufw
ufw allow 22,80,81,109,110,143,443,3128,8080,5002,7300,9000,10000/tcp
ufw allow 22,80,81,109,110,143,443,3128,8080,5002,7300,9000,10000/udp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cat > /etc/ufw/before.rules <<-END
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 172.16.0.0/12 -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.0.0/16 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
END
ufw enable
ufw status

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://github.com/kunphiphit/Debian8/blob/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://github.com/kunphiphit/Debian8/blob/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# install ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip
unzip master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/master.zip
rm -rf /root/ddos-deflate-master

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/kunphiphit/Debian8/master/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

#Setting IPtables
cat > /etc/iptables.up.rules <<-END
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -j SNAT --to-source xxxxxxxxx
-A POSTROUTING -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.0.0.0/8 -o eth0 -j MASQUERADE
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
-A POSTROUTING -s 172.16.0.0/12 -o eth0 -j MASQUERADE
-A POSTROUTING -s 192.168.0.0/16 -o eth0 -j MASQUERADE
COMMIT
*filter
:INPUT ACCEPT [19406:27313311]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9393:434129]
-A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i tun0 -o eth0 -j ACCEPT
-A INPUT -p tcp -m multiport --dports 22 -j fail2ban-ssh
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 81  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 81  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 82  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 82  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 142  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 142  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 109  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 109  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 110  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 110  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 445  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 445  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1080  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1080  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1195  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1195  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 5002  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 5002  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 7300  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 7300  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8000  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8000  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8080  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8080  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8081  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8081  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8082  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8082  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8989  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8989  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 9000  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 9000  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 10000  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 10000  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 52000  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 52000  -m state --state NEW -j ACCEPT
COMMIT
*raw
:PREROUTING ACCEPT [158575:227800758]
:OUTPUT ACCEPT [46145:2312668]
COMMIT
*mangle
:PREROUTING ACCEPT [158575:227800758]
:INPUT ACCEPT [158575:227800758]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [46145:2312668]
:POSTROUTING ACCEPT [46145:2312668]
COMMIT
END
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i $MYIP2 /etc/iptables.up.rules;
iptables-restore < /etc/iptables.up.rules
echo " "
echo "Done !!!"
# download script
cd
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/updates/install-premiumscript.sh"
chmod +x install-premiumscript.sh;
./install-premiumscript.sh;
rm -rf install-premiumscript.sh;
wget "https://raw.githubusercontent.com/kunphiphit/Debian8/master/req/option.sh"
chmod +x option.sh;
./option.sh;
rm -rf option.sh;

# finalizing
echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service vnstat restart
service pritunl restart
service snmpd restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
sysv-rc-conf rc.local on
#clearing history
history -c

# info
clear
echo -e "\e[34;1m=======================================================\e[0m"
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Installation has been completed!! \e[0m"
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Configuration Setup Server \e[0m"
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Modified by kunphiphit \e[0m"                         
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Server Information \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Timezone   : Asia/Bangkok (GMT +7) \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Dflate     : [ON] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - IPtables   : [ON] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Auto-Reboot: [00:00] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - IPv6       : [OFF] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Bruteforce Protection: [ON] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Port Scanning Protection: [ON] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Torrent Blocking: [ON] \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Application & Port Information \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - OpenSSH    : 22-81-82 \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Dropbear   : 109-110-5002 \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Squid Proxy: 3128-8000-8080 (limit to IP Server) \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Badvpn     : 7300 \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Nginx      : 80 \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Server Tools \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - htop \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - iftop \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - mtr \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - nethogs \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - screenfetch \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Premium Script Information \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m To display list of commands: menu \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Explanation of scripts and VPS setup \e[0m" | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Important Information \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Webmin: http://$MYIP:10000/ \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Vnstat: http://$MYIP/vnstat/ \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - MRTG  : http://$MYIP/mrtg/ \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m - Installation Log: cat /root/log-install.txt \e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m"  | tee -a log-install.txt
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Script Created By kunphiphit) \e[0m"
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m\e[0m \e[031;1m\e[0m Modified by kunphiphit \e[0m"
echo -e "\e[34;1m\e[0m"
echo -e "\e[34;1m=======================================================\e[0m"
echo -e "\e[34;1m\e[0m"
rm -rf pritunldeb8.sh          
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
