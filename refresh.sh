#!/usr/bin/env bash

PLATFORM="$(uname)"
RED='\033[0;31m'
GREEN='\033[0;32m'
NOC='\033[0m'
echo_green() {
    echo -e "$GREEN$1$NOC"
}
echo_red() {
    echo -e "$RED$1$NOC"
}

usage() {
    echo "Usage: $(basename "$0") [-gGpPsSfFbBtTeEyvh]"
    echo "Update various software distribution systems"
    echo "if no system specified, update all supported systems"
    echo "-g Update main git repos"
    echo "-G Do not update main git repos"
    echo "-p Update system packages (apt or mac)"
    echo "-P Do not update system packages (apt or mac)"
    echo "-s Update snap packages"
    echo "-S Do not update snap packages"
    echo "-f Update flatpak packages"
    echo "-F Do not update flatpak packages"
    echo "-b Update brew packages"
    echo "-B Do not update brew packages"
    echo "-t Update python tool packages (pipx and uv)"
    echo "-T Do not update python tool packages (pipx and uv)"
    echo "-e Update editor plugins (vim-plug and neovim-lazy)"
    echo "-E Do not update editor plugins (vim-plug and neovim-lazy)"
    echo "-y Assume YES for interactive prompts"
    echo "-v Set verbose mode (set -x)"
    echo "-h Print this message and exit"
}

update_git_repos() {
    if command -v git > /dev/null; then
        echo_green "=== updating git repos ==="
        if [ -d ~/dotfiles ]; then
            echo -e "Updating ${GREEN}dotfiles${NOC} repo..."
            git -C ~/dotfiles pull
        fi
        if [ -d ~/src/stackdev ]; then
            echo -e "Updating ${GREEN}stackdev${NOC} repo..."
            git -C ~/src/stackdev pull
        fi
    fi
}

update_mac() {
    if [ "$PLATFORM" == "Darwin" ] ; then
        echo_green "=== updating MacOS software ==="
        softwareupdate -i -a
    fi
}

update_apt() {
    if command -v apt-get > /dev/null; then
        local dpkg_lock_file
        dpkg_lock_file="/var/lib/dpkg/lock-frontend"
        APT_ENV=""
        APT_ARGS=""
        if [ "$ASSUME_YES" == "1" ]; then
            APT_ENV="DEBIAN_FRONTEND=noninteractive"
            APT_ARGS="-y"
        fi
        echo_green "=== updating apt package repos ==="
        sudo $APT_ENV apt-get update $APT_ARGS
        if sudo lsof $dpkg_lock_file > /dev/null 2>&1 ; then
            echo_red "Failed to acquire lock, try again laiter"
            return
        fi
        echo_green "=== upgrading apt packages ==="
        sudo $APT_ENV apt-get upgrade $APT_ARGS
        echo_green "=== removing no longer used apt packages ==="
        sudo $APT_ENV apt-get autoremove $APT_ARGS
    fi
}

update_snap() {
    if command -v snap > /dev/null; then
        echo_green "=== updating snaps ==="
        sudo snap refresh
    fi
}

update_flatpak() {
    if command -v flatpak > /dev/null; then
        echo_green "=== updating flatpak apps ==="
        if [ "$ASSUME_YES" == "1" ]; then
            sudo flatpak update -y --noninteractive
        else
            sudo flatpak update
        fi
    fi
}

update_brew() {
    if command -v brew > /dev/null; then
        echo_green "=== updating brew apps ==="
        brew update
        brew upgrade
        if [ "$PLATFORM" == "Darwin" ]; then
            brew upgrade --casks # --greedy
        fi
    fi
}

update_system() {
    update_mac
    update_apt
}

update_neovim() {
    if command -v nvim > /dev/null; then
        echo_green "=== updating neovim Lazy plugins ==="
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
    if [ -n "$vim_cmd" ]; then
        echo_green "=== updating vim-plug pligins ==="
        $vim_cmd +PlugUpgrade +PlugUpdate +qa
    fi
}

update_editors() {
    update_neovim
    update_vim
}

update_pytools() {
    if command -v uv > /dev/null 2>&1; then
        echo_green "=== update uv-installed tools ==="
        uv tool update --all
    fi
    if command -v pipx > /dev/null 2>&1; then
        echo_green "=== update pipx-installed tools ==="
        pipx upgrade-all --include-injected
    fi
}

check_reboot_required() {
    if [ "$PLATFORM" == "Linux" ]; then
        echo_green "=== check reboot pending ==="
        if [ -f /var/run/reboot-required ]; then
            echo_red "*** System restart required ***"
            cat /var/run/reboot-required.pkgs
        else
            echo_green "no reboot pending"
        fi
    fi
}

ALL=1
PKG=0
SKIP_PKG=0
SNAP=0
SKIP_SNAP=0
FLATPAK=0
SKIP_FLATPAK=0
BREW=0
SKIP_BREW=0
GIT=0
SKIP_GIT=0
EDITORS=0
SKIP_EDITORS=0
PYTOOLS=0
SKIP_PYTOOLS=0
ASSUME_YES=0

while getopts ':eEgGpPbBsSfFtTyvh' arg; do
    case "${arg}" in
        p) ALL=0; PKG=1;;
        P) SKIP_PKG=1;;
        s) ALL=0; SNAP=1;;
        S) SKIP_SNAP=1;;
        f) ALL=0; FLATPAK=1;;
        F) SKIP_FLATPAK=1;;
        b) ALL=0; BREW=1;;
        B) SKIP_BREW=1;;
        t) ALL=0; PYTOOLS=1;;
        T) SKIP_PYTOOLS=1;;
        g) ALL=0; GIT=1;;
        G) SKIP_GIT=1;;
        e) ALL=0; EDITORS=1;;
        E) SKIP_EDITORS=1;;
        y) ASSUME_YES=1 ;;
        v) set -x;;
        h) usage; exit 0;;
        *) usage; exit 1;;
    esac
done

if [[ $ALL -eq 1 ]]; then
    [[ $SKIP_PKG -eq 0 ]] && PKG=1
    [[ $SKIP_SNAP -eq 0 ]] && SNAP=1
    [[ $SKIP_FLATPAK -eq 0 ]] && FLATPAK=1
    [[ $SKIP_BREW -eq 0 ]] && BREW=1
    [[ $SKIP_PYTOOLS -eq 0 ]] && PYTOOLS=1
    [[ $SKIP_GIT -eq 0 ]] && GIT=1
    [[ $SKIP_EDITORS -eq 0 ]] && EDITORS=1
fi

if [[ $PLATFORM != "Darwin" ]]; then
    if [[ $PKG -eq 1 || $SNAP -eq 1 || $FLATPAK -eq 1 ]]; then
        sudo -v
    fi
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
if [[ $PYTOOLS -eq 1 ]]; then
    update_pytools
fi
if [[ $EDITORS -eq 1 ]]; then
    update_editors
fi
check_reboot_required
