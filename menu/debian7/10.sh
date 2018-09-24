echo -e ""
    echo -e "\033[1;31m				TOTAL DATA INTERNET"
    echo ""
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Download: /g' | sed -e 's/TX [a-z:0-9]*/\nupload: /g'
	
	echo ""
	echo "back to menu"
