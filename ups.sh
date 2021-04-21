#!/usr/bin/env/sh

# Check internet, otherwise quit
ping -c 5 -i 0.2 8.8.8.8 || exit

# Update 
apt update && apt dist-upgrade -y && apt autoremove -y 

exit
