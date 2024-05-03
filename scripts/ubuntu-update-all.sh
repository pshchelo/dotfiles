#!/usr/bin/env bash

update_apt() {
    echo "=== updating package repos ==="
    sudo apt update
    echo "=== upgrading packages ==="
    sudo apt upgrade
    echo "=== removing no longer used packages ==="
    sudo apt autoremove
}

update_snap() {
    if command -v snap > /dev/null; then
        echo "=== updating snaps ==="
        sudo snap refresh
    fi
}

update_flatpak() {
    if command -v flatpak > /dev/null; then
        echo "=== updating flatpak apps ==="
        sudo flatpak update
    fi
}

update_brew() {
    if command -v brew > /dev/null; then
        # TODO: check for outdated first?
        brew update
        brew upgrade
    fi
}


check_reboot_required() {
    if [ -f /var/run/reboot-required ]; then
        cat /var/run/reboot-required
        cat /var/run/reboot-required.pkgs
    fi
}

update_apt
update_snap
update_flatpak
update_brew
check_reboot_required
