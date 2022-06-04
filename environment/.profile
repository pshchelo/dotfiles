# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# LANG=en_US.UTF-8
# LANGUAGE=en_US.UTF-8
# LC_NUMERIC=en_US.UTF-8
# LC_MONETARY=en_US.UTF-8
# LC_NAME=en_US.UTF-8
# LC_ADDRESS=en_US.UTF-8
# LC_TELEPHONE=en_US.UTF-8
# LC_IDENTIFICATION=en_US.UTF-8
# Britain locale settings for sane European defaults
# LC_MEASUREMENT=en_GB.UTF-8
# LC_TIME=en_GB.UTF-8
# LC_PAPER=en_GB.UTF-8
# PAPERSIZE=a4

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set vi/vim as default editor
export EDITOR="vi"
export VISUAL="vim"
export VIEWER="vim -R"

export GOPATH="$HOME/src/go"

# set PATH so it includes user's local bin if exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
