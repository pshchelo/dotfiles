#!/bin/sh
STARHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz"
JQ_URL="https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64"
K9S_URL="https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"
FZF_RELEASE_URL="https://api.github.com/repos/junegunn/fzf/releases/latest"
BIN_INSTALL_DIR="/usr/local/bin"

update_k9s() {
    echo "=== fetching k9s ==="
    curl -sSL "$K9S_URL" | tar -C /tmp -xz k9s
    chmod +x /tmp/k9s
    sudo mv /tmp/k9s "$BIN_INSTALL_DIR"
}

update_jq() {
    echo "=== fetching jq ==="
    curl -sSL "$JQ_URL" > /tmp/jq
    chmod +x /tmp/jq
    sudo mv /tmp/jq $BIN_INSTALL_DIR
}

update_fzf() {
    echo "=== fetching fzf ==="
    fzf_url=$(curl -sSL "$FZF_RELEASE_URL" | jq -r '.assets[] | select((.name|contains("linux_amd64")) and .content_type == "application/gzip") | .browser_download_url')
    curl -sSL "$fzf_url" | tar -C /tmp -xz fzf
    chmod +x /tmp/fzf
    sudo mv /tmp/fzf $BIN_INSTALL_DIR
}

update_starship() {
    echo "=== fetching starship ==="
    curl -sSL "$STARHIP_URL" | tar -C /tmp -xz starship
    chmod +x /tmp/starship
    sudo mv /tmp/starship "$BIN_INSTALL_DIR/starship"
}

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

check_reboot_required() {
    if [ -f /var/run/reboot-required ]; then
        cat /var/run/reboot-required
        cat /var/run/reboot-required.pkgs
    fi
}

update_apt
update_snap
update_flatpak
update_jq
update_fzf
update_k9s
update_starship
check_reboot_required
