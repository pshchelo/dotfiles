#!/usr/bin/env bash
# TODO: find some what to not download when not actually newer
BIN_INSTALL_DIR="/usr/local/bin"

github_release_api_url() {
    local repo="$1"
    echo "https://api.github.com/repos/$repo/releases/latest"
}

github_release_download_url() {
    local repo="$1"
    local fname="$2"
    echo "https://github.com/$repo/releases/latest/download/$fname"
}

chmodx_and_install() {
    local fname="$1"
    chmod +x "$fname"
    sudo mv "$fname" "$BIN_INSTALL_DIR"
}

fetch_and_install_from_targz() {
    local url="$1"
    local fname="$2"
    curl -sSL "$url" | tar -C /tmp -xz "$fname"
    chmodx_and_install "/tmp/$fname"
}

fetch_unpack_and_install_from_targz() {
    local url="$1"
    local fname="$2"
    curl -sSL "$url" | tar -C /tmp -xz --strip-components=1 --one-top-level="$fname"-release
    chmodx_and_install "/tmp/$fname-release/$fname"
    rm -rf "/tmp/$fname-release"
}

update_k9s() {
    local url
    url="$( github_release_download_url derailed/k9s k9s_Linux_amd64.tar.gz )"
    echo "=== fetching k9s ==="
    fetch_and_install_from_targz "$url" k9s
}


update_starship() {
    local url
    url="$( github_release_download_url starship/starship starship-x86_64-unknown-linux-musl.tar.gz )"
    echo "=== fetching starship ==="
    fetch_and_install_from_targz "$url" starship
}

update_lf() {
    local url
    url="$( github_release_download_url gokcehan/lf lf-linux-amd64.tar.gz )"
    echo "=== fetching lf ==="
    fetch_and_install_from_targz "$url" lf
}

update_jq() {
    local url
    url="$( github_release_download_url jqlang/jq jq-linux-amd64 )"
    echo "=== fetching jq ==="
    curl -sSL "$url" > /tmp/jq
    chmodx_and_install /tmp/jq
}

update_fzf() {
    local api_url
    api_url="$(github_release_api_url junegunn/fzf )"
    echo "=== fetching fzf ==="
    url=$(curl -sSL "$api_url" | jq -r '.assets[] | select((.name|contains("linux_amd64")) and .content_type == "application/gzip") | .browser_download_url')
    fetch_and_install_from_targz "$url" fzf
}

update_bat() {
    local api_url
    local url
    api_url="$(github_release_api_url sharkdp/bat )"
    echo "=== fetching bat ==="
    url=$(curl -sSL "$api_url" | jq -r '.assets[] | select((.name|contains("x86_64-unknown-linux-musl.tar.gz")) and .content_type == "application/gzip") | .browser_download_url')
    fetch_unpack_and_install_from_targz "$url" bat
}

update_fd() {
    local api_url
    local url
    api_url="$(github_release_api_url sharkdp/fd )"
    echo "=== fetching fd ==="
    url=$(curl -sSL "$api_url" | jq -r '.assets[] | select((.name|contains("x86_64-unknown-linux-musl.tar.gz")) and .content_type == "application/gzip") | .browser_download_url')
    fetch_unpack_and_install_from_targz "$url" fd
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
update_lf
update_bat
update_fd
check_reboot_required
