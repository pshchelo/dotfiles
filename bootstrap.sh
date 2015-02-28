#!/bin/bash
# get dotfiles repo
dir="$(dirname "$(readlink -f "$0")")"

# create private bin directory if abscent
#if [ -d "$HOME/bin" ] ; then
    #mkdir "$HOME/bin"
#fi

#####################
# SET COMMON SETTINGS
#####################

./$dir/bootstrap-main.sh

###############
# INSTALL TOOLS
###############

# install some extra system python packages
sudo -H pip install -r $dir/requirements/extra-dev-requirements.txt

# solarized colors for Gnome terminal
#git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/bin/gnome-terminal-colors-solarized
#sh ~/gnome-terminal-colors-solarized/solarize dark

# solarized colors for xfce4 terminal
#git clone https://github.com/sgerrand/xfce4-terminal-colors-solarized ~/bin/xfce4-terminal-colors-solarized
#cp ~/bin/xfce4-terminal-colors-solarized/dark/terminalrc ~/.config/xfce4/terminal/

# solarized colors for guake
#git clone ~/bin/guake-colors-solarized
#sh ~/bin/guake-colors-solarized/set_dark.sh

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
FILES="ipython_config.py
ipython_notebook_config.py
ipython_qtconsole_config.py"

for file in $FILES
do
    rm ~/.ipython/profile_default/$file
    ln -s $dir/ipython/default/$file ~/.ipython/profile_default/$file
done

# matplotlib
mkdir -p ~/.config/matplotlib
ln -s $dir/matplotlib/matplotlibrc ~/.config/matplotlib/matplotlibrc
