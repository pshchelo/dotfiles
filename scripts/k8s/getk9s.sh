#!/usr/bin/env bash
K9S_RELEASES_URL="https://api.github.com/repos/derailed/k9s/releases/latest"
# platform and arch detection code adapted from https://starship.rs/install.sh
detect_platform() {
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "${platform}" in
    # mingw is Git-Bash
    mingw*) platform="Windows" ;;
    msys_nt*) platform="Windows" ;;
    cygwin_nt*) platform="Windows";;
    linux) platform="Linux" ;;
    darwin) platform="Darwin" ;;
  esac

  printf '%s' "${platform}"
}
detect_arch() {
  arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

  case "${arch}" in
    x86_64) arch="amd64" ;;
    armv*) arch="arm" ;;
  esac

  # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
  if [ "${arch}" = "amd64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=i686
  elif [ "${arch}" = "arm64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=arm
  fi

  printf '%s' "${arch}"
}

K9S_ASSET="$(detect_platform)_$(detect_arch)"
K9S_DOWNLOAD_URL=$(curl -s $K9S_RELEASES_URL | jq -r --arg ASSET "${K9S_ASSET}" '.assets[] | select(.name|contains($ASSET)).browser_download_url')
curl -sL "$K9S_DOWNLOAD_URL" | tar -C ~/.local/bin -xz k9s
