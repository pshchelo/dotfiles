#!/bin/sh
echo "=== updating package repos ==="
sudo apt update
echo "=== upgrading packages ==="
sudo apt upgrade
echo "=== removing no longer used packages ==="
sudo apt autoremove
if command -v snap > /dev/null; then
    echo "=== updating snaps ==="
    sudo snap refresh
fi
if command -v flatpak > /dev/null; then
    echo "=== updating flatpak apps ==="
    sudo flatpak update
fi
if [ -f /var/run/reboot-required ]; then
    cat /var/run/reboot-required
    cat /var/run/reboot-required.pkgs
fi
