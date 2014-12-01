#!/usr/bin/env sh
# install personal dev dependencies and sets up dev environment

# get dotfiles repo
DOTFILES="$(dirname "$(readlink -f "$0")")"

# install some tools and dependencies
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
sudo apt-get install mc htop ctags

# create links to config files
# make backups
mv "$HOME/.profile" "$HOME/.profile-original"
mv "$HOME/.bashrc" "$HOME/.bashrc-original"
# environment
ln -s "$DOTFILES/environment/profile" "$HOME/.profile"
# shells
ln -s "$DOTFILES/shell/tmux.conf" "$HOME/.tmux.conf"
ln -s "$DOTFILES/shell/bash_aliases" "$HOME/.bash_aliases"
ln -s "$DOTFILES/colors/dircolors-solarized" "$HOME/.dircolors"
ln -s "$DOTFILES/shell/bashrc" "$HOME/.bashrc"
ln -s "$DOTFILES/ssh/config" "$HOME/.ssh/config"

# git and tig (.gitconfig processed separately)
ln -s "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"
ln -s "$DOTFILES/git/tigrc" "$HOME/.tigrc"

ln -s "$DOTFILES/ack/ackrc" "$HOME/.ackrc"
ln -s "$DOTFILES/vim/vimrc" "$HOME/.vimrc"
ln -s "$DOTFILES/powerline" "$HOME/.config/powerline"
#source $HOME/.bashrc

# install Python packages in local user location
pip install --user -r user-dev-requirements.txt

#Make links to scripts/binaries
ln -s "$DOTFILES/bin/tig-2.0.3_x64" "$HOME/.local/bin/tig"
ln -s "$DOTFILES/scripts/ack" "$HOME/.local/bin/ack"
ln -s "$DOTFILES/scripts/ppclean" "$HOME/.local/bin/ppclean"
ln -s "$DOTFILES/scripts/dtestr" "$HOME/.local/bin/dtestr"

# prepare Vundle to later install ViM plugins
mkdir -p "$HOME/.vim/bundle"
git clone https://github.com/gmarik/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
# setup all ViM plugins (requires input)
vim -c BundleInstall
