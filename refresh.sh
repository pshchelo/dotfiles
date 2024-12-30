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
    echo "-e Update editor plugins (vim-plug and neovim-lazy)"
    echo "-y Assume YES for interactive prompts"
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
    APT_ENV=""
    APT_ARGS=""
    if [ "$ASSUME_YES" == "1" ]; then
        APT_ENV="DEBIAN_FRONTEND=noninteractive"
        APT_ARGS="-y"
    fi
    echo "=== updating apt package repos ==="
    sudo $APT_ENV apt update $APT_ARGS
    echo "=== upgrading apt packages ==="
    sudo $APT_ENV apt upgrade $APT_ARGS
    echo "=== removing no longer used apt packages ==="
    sudo $APT_ENV apt autoremove $APT_ARGS
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
        if [ "$ASSUME_YES" == "1" ]; then
            sudo flatpak update -y --noninteractive
        else
            sudo flatpak update
        fi
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

update_neovim() {
    if command -v nvim > /dev/null; then
        nvim --headless "+Lazy! sync" +qall
        #nvim "+autocmd User VeryLazy Lazy! sync" +qa
    fi
}

detect_vim() {
    # on my machines, vim is usually neovim, and vi is vim
    if command -v vim > /dev/null; then
        if ! vim --version | grep -qi nvim ; then
            echo "vim"
            return 0
        fi
    fi
    if command -v vi > /dev/null; then
        if ! vi --version | grep -qi nvim; then
            echo "vi"
            return 0
        fi
    fi
}

update_vim() {
    vim_cmd="$(detect_vim)"
    $vim_cmd +PlugUpgrade +PlugUpdate +qa
}

update_editors() {
    echo "=== updating (neo)vim pligins ==="
    update_neovim
    update_vim
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
EDITORS=0
ASSUME_YES=0

while getopts ':egpbsfyvh' arg; do
    case "${arg}" in
        p) ALL=0; PKG=1;;
        s) ALL=0; SNAP=1;;
        f) ALL=0; FLATPAK=1;;
        b) ALL=0; BREW=1;;
        g) ALL=0; GIT=1;;
        e) ALL=0; EDITORS=1;;
        y) ASSUME_YES=1 ;;
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
    EDITORS=1
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
if [[ $EDITORS -eq 1 ]]; then
    update_editors
fi
check_reboot_required
