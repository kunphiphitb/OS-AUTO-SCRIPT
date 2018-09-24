#!/bin/bash
# Script unlock dropbear, webmin, squid3, openvpn, openssh
read -p "Username : " Login
usermod -L $Login