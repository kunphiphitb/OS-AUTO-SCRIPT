#!/bin/bash
#Script del SSH & OpenVPN
read -p " USERNAME REMOVE: " USER

if getent passwd $User > /dev/null 2>&1; then
        userdel $USER
        echo -e "USER $deleted:deleted Successfull"
else
        echo -e "BY: ✮vpnseller.online✮ $USER NOT FOUND."
fi
