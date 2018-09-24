# !/bin/bash
#

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
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
echo "nameserver 203.144.225.242" > /etc/resolv.conf
echo "nameserver 203.144.255.72" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 203.144.225.242" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 203.144.255.72" >> /etc/resolv.conf' /etc/rc.local
echo "nameserver clarinet.asianet.co.th" > /etc/resolv.conf
echo "nameserver conductor.asianet.co.th" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver clarinet.asianet.co.th" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver conductor.asianet.co.th" >> /etc/resolv.conf' /etc/rc.local

# update
apt-get update; apt-get -y upgrade;

# install wget and curl
apt-get update; apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# set repo
cat > /etc/apt/sources.list <<END2
deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free
deb http://http.us.debian.org/debian jessie main contrib non-free
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
END2
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg

# remove unused
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;
apt-get -y purge sendmail*
apt-get -y remove sendmail*

# install webserver
apt-get -y install nginx php5-fpm php5-cli

# install essential package
echo "mrtg mrtg/conf_mods boolean true" | debconf-set-selections
apt-get -y install bmon iftop htop nmap axel nano iptables traceroute sysv-rc-conf dnsutils bc nethogs openvpn vnstat less screen psmisc apt-file whois ptunnel ngrep mtr git zsh mrtg snmp snmpd snmp-mibs-downloader unzip unrar rsyslog debsums rkhunter
apt-get -y install build-essential
apt-get -y install libio-pty-perl libauthen-pam-perl apt-show-versions

# disable exim
service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat
vnstat -u -i eth0
service vnstat restart

# install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/kunphiphit/premscript/master/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .profile
echo "screenfetch" >> .profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cat > /etc/nginx/nginx.conf <<END3
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
END3
mkdir -p /home/vps/public_html
#wget -O /home/vps/public_html/index.html "http://home.trueid.net/"
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
cat > /etc/nginx/conf.d/vps.conf <<END4
server {
  listen       80;
  server_name  127.0.0.1 localhost;
  server_name  $MYIP home.trueid.net;
  server_name  119.46.28.169 Script.truevisions.tv;
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

END4
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i '/Port 22/a Port  90' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=442/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
/etc/init.d/dropbear restart

# install vnstat gui
cd /home/vps/public_html/
wget https://raw.githubusercontent.com/kunphiphit/premscript/master/vnstat.tar.gz
tar xf vnstat.tar.gz
rm vnstat.tar.gz
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'en';/\$language = 'th';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# install squid3
apt-get -y install squid3
cat > /etc/squid3/squid.conf <<-END
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8 ::1
acl localnet src 172.16.0.0/12 ::1
acl localnet src 192.168.0.0/16 ::1
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
acl CONNECT method GET
acl CONNECT method POST
acl CONNECT method HEAD
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access allow manager localhost
http_access deny manager
http_access deny all
http_port 8080
http_port 3128
http_port 1080
http_port 8081
http_port 8082
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname Script.truevisions.tv
END
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install stunnel4
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/kunphiphit/premscript/master/updates/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/kunphiphit/premscript/master/req/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# install webmin
cd
wget "https://prdownloads.sourceforge.net/webadmin/webmin_1.881_all.deb"
dpkg --install webmin_1.881_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.881_all.deb
service webmin restart
service vnstat restart

# install mrtg
wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/kunphiphit/premscript/master/snmpd.conf"
wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/kunphiphit/premscript/master/mrtg-mem.sh"
chmod +x /root/mrtg-mem.sh
cd /etc/snmp/
sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd
service snmpd restart
snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1
mkdir -p /home/vps/public_html/mrtg
cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost
curl "https://raw.githubusercontent.com/kunphiphit/premscript/master/mrtg.conf" >> /etc/mrtg.cfg
sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg
sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg
indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
cd

#install OpenVPN
apt-get -y install openvpn easy-rsa openssl iptables
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys
# replace bits
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="TH"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Thailand"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Bangkok"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="Script.truevisions.tv"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="home.trueid.net@Script.truevisions.tv"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="home.trueid.net"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="server"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=home.trueid.net|' /etc/openvpn/easy-rsa/vars
#Create Diffie-Helman Pem
openssl dhparam -out /etc/openvpn/dh2048.pem 2048
# Create PKI
cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# setting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
cd
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt
# Setting Server
cat > /etc/openvpn/server.conf <<-END
port 8888
proto tcp
dev tun
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem

server 10.8.0.0 255.255.255.0
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login

client-cert-not-required
username-as-common-name
client-to-client

ifconfig-pool-persist ipp.txt
push "route 10.0.0.0 255.255.255.0"
push "route 0.0.0.0/0 255.255.255.255 net_gateway"
push "route 10.0.0.0/8 255.255.255.255 net_gateway"
push "route 10.8.0.0/24 255.255.255.255 net_gateway"
push "route 10.10.10.10/32 255.255.255.255 net_gateway"
push "route 172.16.0.0/12 255.255.255.255 net_gateway"
push "route 192.168.0.0/16 255.255.255.255 net_gateway"
push "redirect-gateway def1''
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DOMAIN www.google.co.th"
push "dhcp-option DNS 208.67.220.220"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DOMAIN www.opendns.com"
push "dhcp-option DNS 203.144.225.242"
push "dhcp-option DNS 203.144.255.72"
push "dhcp-option DOMAIN Script.truevisions.tv"

push "redirect-gateway local def1"
push "redirect-gateway local def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DOMAIN www.google.co.th"
push "dhcp-option DNS 208.67.220.220"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DOMAIN www.opendns.com"
push "dhcp-option DNS 203.144.225.242"
push "dhcp-option DNS 203.144.255.72"
push "dhcp-option DOMAIN Script.truevisions.tv"

push "redirect-gateway def1"
push "redirect-gateway def1  bypass-dns"
push "dns-option DOMAIN http://home.trueid.net/"
push "dns-option DOMAIN Script.truevisions.tv"
push "dns-option DOMAIN https://www.facebook.com/Truevisions"
push "dns-option DOMAIN https://twinesocial.com/"
push "dns-option DOMAIN www.google.co.th"
push "dns-option DOMAIN m.facebook.net.line-apps.com"
push "dns-option DOMAIN edge-star-mini-shv-02-lax3.facebook.com"
push "dns-option DOMAIN edge-mqtt-shv-01-kut2.facebook.com"

keepalive 10 120
cipher AES-128-CBC
comp-lzo yes
persist-key
persist-tun
tun-mtu 1500
mssfix 1450
push "sndbuf 0"
push "rcvbuf 0"
status openvpn-status.log
log         openvpn.log
verb 4
duplicate-cn
END

#Create OpenVPN Config
mkdir -p /home/vps/public_html
cat > /home/vps/public_html/client.ovpn <<-END
client
dev tun
dev-type tun
proto tcp
remote Script.truevisions.tv 1 udp
remote $MYIP 443 tcp
remote $MYIP 80 tcp
remote $MYIP 8080 tcp
remote $MYIP 8888 tcp
remote $MYIP 1194 tcp
http-proxy $MYIP 8080
http-proxy-option AGENT Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER GET HTTP/1.1
http-proxy-option CUSTOM-HEADER POST HTTP/1.1
http-proxy-option CUSTOM-HEADER HEAD HTTP/1.1
http-proxy-option CUSTOM-HEADER "X-Online-Host: http://home.trueid.net/"
http-proxy-option CUSTOM-HEADER "X-Online-Host: script.truevisions.tv"
http-proxy-option CUSTOM-HEADER "X-Online-Host: https://www.facebook.com/Truevisions"
http-proxy-option CUSTOM-HEADER "X-Online-Host: https://twinesocial.com/"
http-proxy-option CUSTOM-HEADER "X-Online-Host: m.facebook.net.line-apps.com"
http-proxy-option CUSTOM-HEADER "X-Online-Host: edge-star-mini-shv-02-lax3.facebook.com"
http-proxy-option CUSTOM-HEADER "X-Online-Host: edge-mqtt-shv-01-kut2.facebook.com"
http-proxy-option CUSTOM-HEADER "Connection: keep-alive"
http-proxy-option CUSTOM-HEADER "Proxy-Connection: keep-alive"
http-proxy-retry
http-proxy-timeout 5
push "route 10.0.0.0 255.255.255.0"
route 0.0.0.0/0 255.255.255.255 net_gateway
route 10.0.0.0/8 255.255.255.255 net_gateway
route 10.8.0.0/24 255.255.255.255 net_gateway
route 10.10.10.10/32 255.255.255.255 net_gateway
route 172.16.0.0/12 255.255.255.255 net_gateway
route 192.168.0.0/16 255.255.255.255 net_gateway
push "redirect-gateway def1"
push "redirect-gateway def1  bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DOMAIN www.google.co.th"
push "dhcp-option DNS 208.67.220.220"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DOMAIN www.opendns.com"
push "redirect-gateway local def1"
push "redirect-gateway local def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DOMAIN www.google.co.th"
push "dhcp-option DNS 208.67.220.220"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DOMAIN www.opendns.com"
push "dhcp-option DNS 203.144.225.242"
push "dhcp-option DNS 203.144.255.72"
push "dhcp-option DOMAIN Script.truevisions.tv"
push "redirect-gateway def1"
push "redirect-gateway def1  bypass-dns"
push "dns-option DOMAIN http://home.trueid.net/"
push "dns-option DOMAIN Script.truevisions.tv"
push "dns-option DOMAIN https://www.facebook.com/Truevisions"
push "dns-option DOMAIN https://twinesocial.com/"
push "dns-option DOMAIN www.google.co.th"
push "dns-option DOMAIN m.facebook.net.line-apps.com"
push "dns-option DOMAIN edge-star-mini-shv-02-lax3.facebook.com"
push "dns-option DOMAIN edge-mqtt-shv-01-kut2.facebook.com"
keepalive 10 120
connect-retry-tal 1
connect-retry 1 300
comp-lzo yes
route-nopull
resolv-retry infinite
nobind
machine-readable-output
allow-recursive-routing
cipher AES-128-CBC
mute-replay-warnings
persist-remote-ip
tun-mtu 1500
persist-tun
preresolve
ifconfig-nowarn
mssfix 1450
auth-user-pass
rcvbuf 0
sndbuf 0
verb 4

END
echo '<ca>' >> /home/vps/public_html/client.ovpn
cat /etc/openvpn/ca.crt >> /home/vps/public_html/client.ovpn
echo '</ca>' >> /home/vps/public_html/client.ovpn
cd /home/vps/public_html/
cd

# Restart openvpn
/etc/init.d/openvpn restart
service openvpn start
service openvpn status

#Setting UFW
apt-get install ufw
ufw allow ssh
ufw allow 8888,80,443,1194/tcp
ufw allow 8888,80,443,1194/udp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cat > /etc/ufw/before.rules <<-END
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to eth0
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT
# END OPENVPN RULES
END
ufw enable
ufw status
ufw disable

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/kunphiphit/premscript/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/kunphiphit/premscript/master/badvpn-udpgw64"
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

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/kunphiphit/premscript/master/issue.net"
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
-A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
COMMIT

*filter
:INPUT ACCEPT [19406:27313311]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [9393:434129]
-A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i tun0 -o eth0 -j ACCEPT
-A INPUT -p ICMP --icmp-type 8 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 80  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 442  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 143  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 109  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 110  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1194  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 8888  -m state --state NEW -j ACCEPT
-A INPUT -p tcp --dport 3128  -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 3128  -m state --state NEW -j ACCEPT
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
-A INPUT -p tcp --dport 10000  -m state --state NEW -j ACCEPT
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

# download script
cd
wget https://raw.githubusercontent.com/daybreakersx/premscript/master/updates/install-premiumscript.sh -O - -o /dev/null|sh

# finalizing
apt-get -y autoremove
chown -R www-data:www-data /home/vps/public_html
service nginx start
service php5-fpm start
service vnstat restart
service openvpn restart
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
echo " "
echo "Installation has been completed!!"
echo " "
echo "--------------------------- Configuration Setup Server -------------------------"
echo "                         Copyright Script.truevisions.tv                          "
echo "                                  http://home.trueid.net/                         "
echo "                              Created By Script.truevisions.tv)                 "
echo "                                Modified by Script.truevisions.tv                             "
echo "--------------------------------------------------------------------------------"
echo ""  | tee -a log-install.txt
echo "Server Information"  | tee -a log-install.txt
echo "   - Timezone    : Asia/Bangkok (GMT +7)"  | tee -a log-install.txt
echo "   - Dflate      : [ON]"  | tee -a log-install.txt
echo "   - IPtables    : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot : [OFF]"  | tee -a log-install.txt
echo "   - IPv6        : [OFF]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Application & Port Information"  | tee -a log-install.txt
echo "   - OpenVPN     : TCP 8888 "  | tee -a log-install.txt
echo "   - OpenSSH     : 22, 90, 143"  | tee -a log-install.txt
echo "   - Stunnel4    : 443"  | tee -a log-install.txt
echo "   - Dropbear    : 109, 110, 442"  | tee -a log-install.txt
echo "   - Squid Proxy : 1080, 3128, 8080, 8081, 8082 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn      : 7300"  | tee -a log-install.txt
echo "   - Nginx       : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Server Tools"  | tee -a log-install.txt
echo "   - htop"  | tee -a log-install.txt
echo "   - iftop"  | tee -a log-install.txt
echo "   - mtr"  | tee -a log-install.txt
echo "   - nethogs"  | tee -a log-install.txt
echo "   - screenfetch"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Premium Script Information"  | tee -a log-install.txt
echo "   To display list of commands: menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   Explanation of scripts and VPS setup" | tee -a log-install.txt
echo "   follow this link: https://www.facebook.com/Truevisions"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Important Information"  | tee -a log-install.txt
echo "   - Download Config OpenVPN : http://$MYIP/client.ovpn"  | tee -a log-install.txt
echo "   - Webmin                  : http://$MYIP:10000/"  | tee -a log-install.txt
echo "   - Vnstat                  : http://$MYIP/"  | tee -a log-install.txt
echo "   - MRTG                    : http://$MYIP/mrtg/"  | tee -a log-install.txt
echo "   - Installation Log        : cat /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------- Script Created By Script.truevisions.tv(https://www.facebook.com/Truevisions) ------------"
echo "------------------------------ Modified by Script.truevisions.tv -----------------------------"
