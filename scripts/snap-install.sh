#!/usr/bin/env bash
# TODO: re-implement with ansible https://docs.ansible.com/ansible/latest/collections/community/general/snap_module.html
sudo snap install kubectl --classic --channel 1.28/stable # update channel when k8s is upgraded in MOSK
sudo snap install helm --classic
# NeoVim
sudo snap install nvim --classic
# log viewer
sudo snap install lnav

# GUI/desktop
#sudo snap install blender --classic
#sudo snap install inkscape
#sudo snap install multipass
#sudo snap install pdftk
#sudo snap install pycharm-community --classic
#sudo snap install skype
#sudo snap install telegram-desktop
#sudo snap install wine-platform-3-stable  # wine-platform-runtime ???
#sudo snap install zoomclient
