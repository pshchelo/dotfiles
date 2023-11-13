#!/usr/bin/env bash
# TODO: autodetect OS and arch
K9S_OS=${K9S_OS:-Linux}
K9S_ARCH=${K9S_ARCH:-amd64}
K9S_ARTIFACT="${K9S_OS}_${K9S_ARCH}"
K9S_RELEASES_URL="https://api.github.com/repos/derailed/k9s/releases/latest"
K9S_DOWNLOAD_URL=$(curl -s $K9S_RELEASES_URL | jq -r --arg ARTIFACT $K9S_ARTIFACT '.assets[] | select(.name|contains($ARTIFACT)).browser_download_url')
curl -sL "$K9S_DOWNLOAD_URL" | tar -C ~/.local/bin -xz k9s
