#!/bin/sh
sudo apt update
sudo apt upgrade
sudo apt autoremove
if command -v snap > /dev/null; then
    sudo snap refresh
fi
if command -v flatpak > /dev/null; then
    sudo flatpak update
fi
if [ -f /var/run/reboot-required ]; then
    cat /var/run/reboot-required
    cat /var/run/reboot-required.pkgs
fi
