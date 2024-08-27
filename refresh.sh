#!/usr/bin/env bash

PLATFORM="$(uname)"

function usage() {
    echo "Usage: $(basename "$0") [-g] [-p] [-s] [-f] [-b] [-x] [-h]"
    echo "Update various software distribution systems"
    echo "if no system specified, update all supported systems"
    echo "-g Update main git repos"
    echo "-p Update system packages (apt or mac)"
    echo "-s Update snap packages"
    echo "-f Update flatpak packages"
    echo "-b Update brew packages"
    echo "-v Set verbose mode (set -x)"
    echo "-h Print this message and exit"
}

update_git_repos() {
    echo "=== updating git repos ==="
    if [ -d ~/dotfiles ]; then
        git -C ~/dotfiles pull
    fi
    if [ -d ~/src/stackdev ]; then
        git -C ~/src/stackdev pull
    fi
}

update_mac() {
    echo "=== updating MacOS software ==="
    softwareupdate -i -a
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
        if [ "$PLATFORM" == "Darwin" ]; then
            brew upgrade --casks # --greedy
        fi
        
    fi
}

update_system() {
    if [ "$PLATFORM" == "Darwin" ] ; then
        update_mac
    elif command -v apt > /dev/null; then
        update_apt
    fi
}

check_reboot_required() {
    if [ "$PLATFORM" == "Linux" ]; then
        echo "=== check reboot pending ==="
        if [ -f /var/run/reboot-required ]; then
            cat /var/run/reboot-required
            cat /var/run/reboot-required.pkgs
        else
            echo "no reboot pending"
        fi
    fi
}

ALL=1
PKG=0
SNAP=0
FLATPAK=0
BREW=0
GIT=0

while getopts ':gpbsfvh' arg; do
    case "${arg}" in
        p) ALL=0; PKG=1;;
        s) ALL=0; SNAP=1;;
        f) ALL=0; FLATPAK=1;;
        b) ALL=0; BREW=1;;
        g) ALL=0; GIT=1;;
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
    GIT=1
fi
if [[ $GIT -eq 1 ]]; then
    update_git_repos
fi
if [[ $PKG -eq 1 ]]; then
    update_system
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
