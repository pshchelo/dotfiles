#!/bin/bash
# get dotfiles repo
dir="$(dirname "$(readlink -f "$0")")"

# create private bin directory if abscent
#if [ -d "$HOME/bin" ] ; then
    #mkdir "$HOME/bin"
#fi

###############
# INSTALL TOOLS
###############

# install Anonymous Pro font
sudo apt-get install ttf-anonymous-pro wajig python-dev build-essential

# install pip
curl https://bootstrap.pypa.io/get-pip.py | sudo python

# install python packages privately
sudo pip install -r $dir/dev-requirements.txt

# solarized colors for Gnome terminal
#git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/bin/gnome-terminal-colors-solarized
#sh ~/gnome-terminal-colors-solarized/solarize dark

# solarized colors for xfce4 terminal
#git clone https://github.com/sgerrand/xfce4-terminal-colors-solarized ~/bin/xfce4-terminal-colors-solarized
#cp ~/bin/xfce4-terminal-colors-solarized/dark/terminalrc ~/.config/xfce4/terminal/

# solarized colors for guake
#git clone ~/bin/guake-colors-solarized
#sh ~/bin/guake-colors-solarized/set_dark.sh

#####################
# SET COMMON SETTINGS
#####################

./$dir/bootstrap-main.sh

#################
# MAKE MORE LINKS
#################

# environment
ln -s $dir/environment/pam_environment ~/.pam_environment
ln -s $dir/environment/pshchelo.pth ~/pshchelo.pth

# git config files
ln -s $dir/git/gitconfig ~/.gitconfig

# ipython
ipython profile create
ln -s $dir/ipython/default/ipython_config.py ~/.config/ipython/profile_default/ipython_config.py
ln -s $dir/ipython/default/ipython_notebook_config.py ~/.config/ipython/profile_default/ipython_notebook_config.py
ln -s $dir/ipython/default/ipython_nbconvert_config.py ~/.config/ipython/profile_default/ipython_nbconvert_config.py

# matplotlib
ln -s $dir/matplotlib/matplotlibrc ~/.config/matplotlib/matplotlibrc
