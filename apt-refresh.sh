#!/usr/bin/env sh
RED='\033[0;31m'
NOC='\033[0m'
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
if [ -f /var/run/reboot-required ]; then
    echo "$RED$(cat /var/run/reboot-required)$NOC"
    cat /var/run/reboot-required.pkgs
fi
