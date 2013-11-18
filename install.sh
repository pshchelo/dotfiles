# environment
ln -s environment/pam_environment ~/.pam_environment
ln -s environment/profile ~/.profile

# bash
ln -s bash/bashrc ~/.bashrc
ln -s bash/bash_aliases ~/.bash_aliases
# install solarized color for Gnome terminal
#git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git
#cd gnome-terminal-colors-solarized && ./solarize

# colors for ls command
# github.com/sigurdga/ls-colors-solarized
ln -s colors/dircolorss-solarized ~/.dircolors
# colors for mc
# github.com/peel/mc
ls -s colors/mc-solarized.ini ~/.config/mc/solarized.ini

# git config files
ln -s git/gitconfig ~/.gitconfig
ln -s git/gitignore_global ~/.gitignore_global

# Vim
ln -s vim/vimrc ~/.vimrc
# install vundle to manage other plugins
# mkdir -p ~/.vim/bundle && cd ~/.vim/bundle
# git clone git://github.com/gmarik/vundle.git

# matplotlib
ln -s matplotlib/matplotlibrc ~/.config/matplotlib/matplotlibrc

# ipython
# ipython profile create
ln -s ipython/ipython_config.py ~/.config/ipython/profile_default/ipython_config.py
ln -s ipython/ipython_notebook_config.py ~/.config/ipython/profile_default/ipython_notebook_config.py
ln -s ipython/ipython_qtconsole_config.py ~/.config/ipython/profile_default/ipython_qtconsole_config.py
ln -s ipython/ipython_nbconvert_config.py ~/.config/ipython/profile_default/ipython_nbconvert_config.py
