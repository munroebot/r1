#!/bin/bash

# This script is designed to disable the airport wireless interface when you logoff.
# To use it, you need to install it as a Loginwindow LogoutHook
#
# To install - ./turn_off_wifi.sh install
#
# To remove the feature - ./turn_off_wifi.sh remove
#
# To see the status of the LogoutHook - ./turn_off_wifi.sh status
#
# If you don't pass any arguments to the script (./turn_off_wifi.sh) then
# it will disable the wifi interace (the default behavior).
#

root_plist="/private/var/root/Library/Preferences/com.apple.loginwindow";

if [ ${1} ]; then
    
    if [ ${1} == 'install' ]; then
        echo -n "Installing the turn_off_wifi LogoutHook..."
        /usr/bin/sudo /usr/bin/defaults write ${root_plist} LogoutHook /Users/bmunroe/r1/code-misc/turn_off_wifi.sh;
        echo "done.";
    fi
    
    if [ ${1} == 'delete' ]; then
        echo -n "Deleting the turn_off_wifi LogoutHook..."
        /usr/bin/sudo /usr/bin/defaults delete ${root_plist} LogoutHook;
        echo "done.";
    fi
    
    if [ ${1} == 'status' ]; then
        echo "Current value of com.apple.loginwindow LogoutHook:"
        /usr/bin/sudo /usr/bin/defaults read ${root_plist} LogoutHook;
    fi
        
else
    /usr/sbin/networksetup -setairportpower en1 off;
fi