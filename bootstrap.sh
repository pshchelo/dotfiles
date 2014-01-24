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

# install latest git
#sudo apt-repository add ppa:git-core/ppa
#sudo apt-get update
#sudo apt-get install git

# install Anonymous Pro font
#sudo apt-get install ttf-anonymous-pro

# install ack
#curl http://beyondgrep.com/ack-2.12-single-file > ~/bin/ack && chmod 0755 !#:3

# install pip
#curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python

# install python packages privately
#pip install --user -r $dir/pip-personal.txt

# solarized colors for Gnome terminal
#git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/bin/gnome-terminal-colors-solarized
#sh ~/gnome-terminal-colors-solarized/solarize dark

# solarized colors for xfce4 terminal
#git clone https://github.com/sgerrand/xfce4-terminal-colors-solarized ~/bin/xfce4-terminal-colors-solarized
#cp ~/bin/xfce4-terminal-colors-solarized/dark/terminalrc ~/.config/xfce4/terminal/

# solarized colors for guake
#git clone ~/bin/guake-colors-solarized
#sh ~/bin/guake-colors-solarized/set_dark.sh

############
# MAKE LINKS
############

# environment
ln -s $dir/environment/pam_environment ~/.pam_environment
ln -s $dir/environment/profile ~/.profile
ln -s $dir/environment/pshchelo.pth ~/pshchelo.pth
# bash
ln -s $dir/bash/bashrc ~/.bashrc
ln -s $dir/bash/bash_aliases ~/.bash_aliases

# colors for ls command (github.com/sigurdga/ls-colors-solarized)
ln -s $dir/colors/dircolorss-solarized ~/.dircolors

# colors for mc (github.com/peel/mc)
ls -s $dir/colors/mc-solarized.ini ~/.config/mc/mc-solarized.ini

# SSH
ln -s $dir/ssh/config ~/.ssh/config

# git config files
ln -s $dir/git/gitconfig ~/.gitconfig
ln -s $dir/git/gitignore_global ~/.gitignore_global
ln -s $dir/git/tigrc ~/.tigrc
ln -s $dir/git/next_review ~/.next_review

# Vim
ln -s $dir/vim/vimrc ~/.vimrc
# install vundle to manage other plugins
#mkdir -p ~/.vim/bundle
#git clone git://github.com/gmarik/vundle.git ~/.vim/bundle

# Ack
ln -s $dir/ack/ackrc ~/.ackrc

#
# ipython
#ipython profile create
#ln -s $dir/ipython/ipython_config.py ~/.config/ipython/profile_default/ipython_config.py
#ln -s $dir/ipython/ipython_notebook_config.py ~/.config/ipython/profile_default/ipython_notebook_config.py
#ln -s $dir/ipython/ipython_qtconsole_config.py ~/.config/ipython/profile_default/ipython_qtconsole_config.py
#ln -s $dir/ipython/ipython_nbconvert_config.py ~/.config/ipython/profile_default/ipython_nbconvert_config.py

# matplotlib
#ln -s $dir/matplotlib/matplotlibrc ~/.config/matplotlib/matplotlibrc
