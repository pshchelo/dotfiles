#!/usr/bin/env bash

function usage() {
    echo "Usage: $(basename "$0") [-p] [-s] [-f] [-b] [-x] [-h]"
    echo "Update various software distribution systems"
    echo "if no system specified, update all supported systems"
    echo "-p Update system packages (currently only apt supported)"
    echo "-s Update snap packages"
    echo "-f Update flatpak packages"
    echo "-b Update brew packages"
    echo "-v Set verbose mode (set -x)"
    echo "-h Print this message and exit"
}

update_apt() {
    echo "=== updating apt package repos ==="
    sudo apt update
    echo "=== upgrading apt packages ==="
    sudo apt upgrade
    echo "=== removing no longer used apt packages ==="
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
        echo "=== updating brew apps ==="
        brew update
        brew upgrade
    fi
}

update_packages() {
    if command -v apt > /dev/null; then
        update_apt
    fi
}

check_reboot_required() {
    echo "=== check reboot pending ==="
    if [ -f /var/run/reboot-required ]; then
        cat /var/run/reboot-required
        cat /var/run/reboot-required.pkgs
    else
        echo "no reboot pending"
    fi
}

ALL=1
PKG=0
SNAP=0
FLATPAK=0
BREW=0

while getopts ':pbsfvh' arg; do
    case "${arg}" in
        p) ALL=0; PKG=1;;
        s) ALL=0; SNAP=1;;
        f) ALL=0; FLATPAK=1;;
        b) ALL=0; BREW=1;;
        v) set -x;;
        h) usage; exit 0;;
        *) usage; exit 1;;
    esac
done

if [[ $ALL -eq 1 ]]; then
    PKG=1
    SNAP=1
    FLATPAK=1
    BREW=1
fi
if [[ $PKG -eq 1 ]]; then
    update_packages
fi
if [[ $SNAP -eq 1 ]]; then
    update_snap
fi
if [[ $FLATPAK -eq 1 ]]; then
    update_flatpak
fi
if [[ $BREW -eq 1 ]]; then
    update_brew
fi
check_reboot_required
