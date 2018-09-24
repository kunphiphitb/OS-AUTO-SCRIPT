#!/bin/bash
# Script restart service dropbear, webmin, squid3, openvpn, openssh

service dropbear restart
service webmin restart
service squid3 restart
/etc/init.d/openvpn stop
/etc/init.d/openvpn start
/etc/init.d/openvpn restart
/etc/init.d/openvpn cond-restart
/etc/init.d/openvpn force-restart
/etc/init.d/openvpn force-reload
/etc/init.d/openvpn reload
/etc/init.d/openvpn status
service ssh restart
