#!/usr/bin/env bash

# list installed programs
ls -l "$HOME/.local/bin" > ls-local-bin.txt
ls /opt > ls-opt.txt
command -v apt && apt list --installed | grep -v ,automatic | awk -F '/' '{print $1}'> apt-list-installed.txt
command -v brew && brew list --installed-on-request > brew-installed-on-request.txt
command -v uv && uv tool list > uv-tool-list.txt
command -v snap && snap list > snap-list.txt
command -v flatpak && flatpack list > flatpack-list.txt
command -v docker && docker images > docker-images.txt && docker ps -a > docker-ps.txt
command -v podman && podman images > podman-images.txt && podman ps -a > podman-ps.txt
command -v lsvirtualenv && lsvirtualenv > lsvirtualenv.txt

# save config files
tar -caf etc.tar.gz "/etc"
tar -caf configs.tar.gz "$HOME/.config"
tar -caf docker.tar.gz "$HOME/.docker"
# TODO: add more directories as I remember them
