#!/bin/bash
echo -e "\033[1;32m
====================================================
 VIEW ALL USERS
===================================================="
echo -e "\033[1;36m" 
echo "---------------------------------------------"
echo "BIL  user            status       expires   "
echo "---------------------------------------------"
C=1
ON=0
OFF=0
while read mumetndase
do
        acout="$(echo $mumetndase | cut -d: -f1)"
        ID="$(echo $mumetndase | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $acout | grep "Account expires" | awk -F": " '{print $2}')"
        online="$(cat /etc/openvpn/log.log | grep -Eom 1 $acout | grep -Eom 1 $acout)"
        if [[ $ID -ge 500 ]]; then
        if [[ -z $online ]]; then
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$acout" "------" "$exp"
        OFF=$((OFF+1))
        else
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$acout" "online" "$exp"
        ON=$((ON+1))
        fi
        C=$((C+1))
        fi
done < /etc/passwd
echo "---------------------------------------------"
echo " online : $ON     ofline : $OFF "
echo "---------------------------------------------"
echo -e "\033[1;32m" 
